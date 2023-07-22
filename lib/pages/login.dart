import 'package:dev3_wallet/pages/create_wallet/create_wallet.dart';
import 'package:dev3_wallet/pages/import_wallet.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Dev3 Wallet',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const SizedBox(height: 24.0),

            // // Logo
            // Container(
            //   width: double.infinity,
            //   alignment: Alignment.center,
            //   child: SizedBox(
            //     width: 150,
            //     height: 200,
            //     child: Image.asset(
            //       'assets/images/logo.png',
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 50.0),

            // Login button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateWallet(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF141414), // Customize button background color
                foregroundColor: Colors.white, // Customize button text color
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Create Wallet',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Register button
            ElevatedButton(
              onPressed: () {
                // Add your register logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImportWallet(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white, // Customize button background color
                foregroundColor: Colors.black, // Customize button text color
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Import from Seed',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Footer
            Container(
              alignment: Alignment.center,
              child: const Text(
                '© 2023 Dhevanthareza. All rights reserved.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
