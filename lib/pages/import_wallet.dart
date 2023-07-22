import 'package:dev3_wallet/pages/home/wallet.dart';
import 'package:dev3_wallet/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  bool isVerified = false;
  String mnemonic = '';
  String walletName = '';

  void navigateToWalletPage() {
    Get.to(WalletPage());
  }

  @override
  Widget build(BuildContext context) {
    void verifyMnemonic() async {
      await WalletService.addWallet(mnemonic, walletName);
      navigateToWalletPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from Seed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please Enter your mnemonic phrase and name your wallet:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  mnemonic = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter mnemonic phrase',
              ),
            ),
            const SizedBox(height: 11.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  walletName = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Wallet Name',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: verifyMnemonic,
              child: const Text('Import'),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
