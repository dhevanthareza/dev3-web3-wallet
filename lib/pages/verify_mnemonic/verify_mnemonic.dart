import 'package:dev3_wallet/pages/home/wallet.dart';
import 'package:dev3_wallet/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class VerifyMnemonic extends StatefulWidget {
  final String mnemonic;
  const VerifyMnemonic({super.key, required this.mnemonic});

  @override
  State<VerifyMnemonic> createState() => _VerifyMnemonicState();
}

class _VerifyMnemonicState extends State<VerifyMnemonic> {
  bool isVerified = false;
  String verificationText = '';

  void verifyMnemonic() {
    // if (verificationText.trim() == widget.mnemonic.trim()) {
    //   WalletService.generatePrivateKey();
    //   setState(() {
    //     isVerified = true;
    //   });
    // }
  }

  void navigateToWalletPage() {
    Get.to(WalletPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Mnemonic and Create'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please verify your mnemonic phrase:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  verificationText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter mnemonic phrase',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                verifyMnemonic();
              },
              child: const Text('Verify'),
            ),
            const SizedBox(height: 14.0),
            ElevatedButton(
              onPressed: isVerified ? navigateToWalletPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
