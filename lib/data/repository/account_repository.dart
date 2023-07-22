import 'dart:convert';

import 'package:dev3_wallet/data/constant/default_asset.dart';
import 'package:dev3_wallet/entity/wallet_entity.dart';
import 'package:get_storage/get_storage.dart';

class AccountRepository {
  static List<WalletEntity> fetchWallet() {
    GetStorage storage = GetStorage();
    dynamic accountsJsonString = storage.read("accounts");
    if (accountsJsonString == null) {
      return [];
    }
    print(accountsJsonString);
    List<dynamic> accountsMap = jsonDecode(accountsJsonString);
    List<WalletEntity> accounts = accountsMap
        .map(
          (e) => WalletEntity.fromJson(e),
        )
        .toList();
    return accounts;
  }

  static void saveWallet({
    name,
    publicAddress,
    mnemonic,
    privateKey,
  }) {
    List<WalletEntity> accounts = AccountRepository.fetchWallet();
    accounts.insert(
      0,
      WalletEntity(
        name: name,
        publicAddress: publicAddress,
        mnemonic: mnemonic,
        privateKey: privateKey,
        chains: DEFAULT_CHAINS,
      ),
    );
    List<Map<String, dynamic>> accountsJson =
        accounts.map((e) => e.toJson()).toList();
    GetStorage storage = GetStorage();
    storage.write("accounts", jsonEncode(accountsJson));
  }

  static void updateWholeWallet(List<WalletEntity> wallets) {
    GetStorage storage = GetStorage();
    storage.remove("accounts");
    List<Map<String, dynamic>> accountsJson =
        wallets.map((e) => e.toJson()).toList();

    storage.write("accounts", jsonEncode(accountsJson));
  }

  static void removeWallet() {
    GetStorage storage = GetStorage();
    storage.erase();
  }
}
