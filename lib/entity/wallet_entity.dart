import 'package:dev3_wallet/entity/chain_entity.dart';

class WalletEntity {
  String? name;
  String? publicAddress;
  String? mnemonic;
  String? privateKey;
  List<ChainEntity> chains = [];

  WalletEntity({
    this.name,
    this.publicAddress,
    this.mnemonic,
    this.privateKey,
    this.chains = const [],
  });

  WalletEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    publicAddress = json['publicAddress'];
    mnemonic = json['mnemonic'];
    privateKey = json['privateKey'];
    chains = [];
    if (json['chains'] != null) {
      chains = <ChainEntity>[];
      json['chains'].forEach((v) {
        chains.add(ChainEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['publicAddress'] = this.publicAddress;
    data['mnemonic'] = this.mnemonic;
    data['privateKey'] = this.privateKey;
    data['chains'] = this.chains.map((e) => e.toJson()).toList();
    return data;
  }
}
