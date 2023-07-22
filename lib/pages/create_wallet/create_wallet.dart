import 'package:dev3_wallet/pages/create_wallet/create_wallet.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateWallet extends StatelessWidget {
  const CreateWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Mnemonic'),
      ),
      body: GetBuilder<CreateWalletController>(
          init: CreateWalletController(),
          builder: (state) {
            List<String> mnemonicWords = state.mnemonic.split(" ");
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please store this mnemonic phrase safely:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 24.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      mnemonicWords.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '${index + 1}. ${mnemonicWords[index]}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      state.handleCopyToClipboardClick();
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy to Clipboard'),
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
