import 'dart:math';

import 'package:dev3_wallet/data/repository/account_repository.dart';
import 'package:dev3_wallet/entity/chain_entity.dart';
import 'package:dev3_wallet/entity/token_entity.dart';
import 'package:dev3_wallet/entity/wallet_entity.dart';
import 'package:get/get.dart';

import '../data/repository/chain_repository.dart';

class WalletController extends GetxController {
  static WalletController get to => Get.find();

  bool isInitializing = true;
  List<WalletEntity> wallets = [];
  int currentActiveWalletIndex = 0;
  int currentActiveChainIndex = 0;

  WalletEntity get currentActiveWallet => wallets[currentActiveWalletIndex];
  ChainEntity get currentActiveChain =>
      wallets[currentActiveWalletIndex].chains[currentActiveChainIndex];

  double nativeBalance = 0;
  String message = "";

  Map<String, String> contractToBalance = {};

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    wallets = [];
    currentActiveChainIndex = 0;
    currentActiveWalletIndex = 0;
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
    currentActiveWalletIndex = 0;
    currentActiveChainIndex = 0;
    update();
    fetchBalanceFromChain();
  }

  Future<void> fetchBalanceFromChain() async {
    print("FETCHING BALANCE");
    // Getting Native Balance
    nativeBalance = await ChainRepository.fetchBalanceFromChain(
        wallets[currentActiveWalletIndex].privateKey!,
        wallets[currentActiveWalletIndex].chains[currentActiveChainIndex]);

    // Getting Another Token
    wallets[currentActiveWalletIndex]
        .chains[currentActiveChainIndex]
        .tokens
        .forEach((TokenEntity token) => fetchBalanceOfToken(
              wallets[currentActiveWalletIndex].publicAddress!,
              token,
              wallets[currentActiveWalletIndex].chains[currentActiveChainIndex],
            ));
    update();
    print("FETCHING BALAANCE DONE");
  }

  Future<void> handleSelectNetwork(ChainEntity chain) async {
    Get.back();
    int index = wallets[currentActiveWalletIndex].chains.indexWhere(
          (ChainEntity item) => item.chainId == chain.chainId,
        );
    currentActiveChainIndex = index;
    nativeBalance = 0;
    update();
    fetchBalanceFromChain();
  }

  Future<void> addTokenToChain(TokenEntity token) async {
    wallets[currentActiveWalletIndex]
        .chains[currentActiveChainIndex]
        .tokens
        .add(token);
    AccountRepository.updateWholeWallet(wallets);
    update();

    fetchBalanceOfToken(
      wallets[currentActiveWalletIndex].publicAddress!,
      token,
      wallets[currentActiveWalletIndex].chains[currentActiveChainIndex],
    );
  }

  Future<void> fetchBalanceOfToken(
    String publicAddress,
    TokenEntity token,
    ChainEntity chain,
  ) async {
    print("Fetching Balance Of ${token.name}");
    String balance = await ChainRepository.fetchBalanceOfToken(
      publicAddress,
      token.contract!,
      chain,
    );
    contractToBalance[token.contract!] = (BigInt.parse(balance) /
            BigInt.from(
              pow(
                10,
                int.parse(token.decimal!),
              ),
            ))
        .toString();
    print("${token.name} balance is ${contractToBalance[token.contract!]}");
    update();
  }
}
