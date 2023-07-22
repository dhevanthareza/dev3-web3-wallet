import 'package:dev3_wallet/data/repository/account_repository.dart';
import 'package:dev3_wallet/entity/chain_entity.dart';
import 'package:dev3_wallet/entity/wallet_entity.dart';
import 'package:get/get.dart';

import '../data/repository/chain_repository.dart';

class WalletController extends GetxController {
  bool isInitializing = true;
  List<WalletEntity> wallets = [];
  WalletEntity? currentActiveWallet;
  ChainEntity? currentActiveChain;
  double nativeBalance = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    wallets = [];
    currentActiveChain = null;
    currentActiveWallet = null;
    initialize();
  }

  Future<void> initialize() async {
    await fetchWallets();
    isInitializing = false;
    update();
  }

  Future<void> fetchWallets() async {
    List<WalletEntity> accounts = AccountRepository.fetchWallet();
    wallets = accounts;
    currentActiveWallet = wallets[0];
    currentActiveChain = currentActiveWallet!.chains[0];
    update();
    fetchBalanceFromChain();
  }

  Future<void> fetchBalanceFromChain() async {
    nativeBalance = await ChainRepository.fetchBalanceFromChain(
        currentActiveWallet!.privateKey!, currentActiveChain!);
    update();
  }

  Future<void> handleSelectNetwork(ChainEntity chain) async {
    Get.back();
    currentActiveChain = chain;
    nativeBalance = 0;
    update();
    fetchBalanceFromChain();
  }
}
