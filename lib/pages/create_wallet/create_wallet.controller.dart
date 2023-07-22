import 'package:dev3_wallet/pages/verify_mnemonic/verify_mnemonic.dart';
import 'package:dev3_wallet/services/wallet_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreateWalletController extends GetxController {
  final String mnemonic = WalletService.generateMnemonic();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void handleCopyToClipboardClick() {
    Clipboard.setData(ClipboardData(text: mnemonic));
    Get.snackbar(
      "Success",
      "Mnemonic copied to Clipboard",
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.to(VerifyMnemonic(mnemonic: mnemonic));
  }
}
