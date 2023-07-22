import 'package:dev3_wallet/entity/token_entity.dart';

class ChainEntity {
  String? name;
  String? rpcUrl;
  String? chainId;
  String? symbol;
  double balance = 0;
  List<TokenEntity> tokens = [];

  ChainEntity({
    this.name,
    this.rpcUrl,
    this.chainId,
    this.symbol,
    this.balance = 0,
    this.tokens = const [],
  });

  ChainEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rpcUrl = json['rpcUrl'];
    chainId = json['chainId'];
    symbol = json['symbol'];
    balance = json['balance'] ?? 0;
    if (json['tokens'] != null) {
      tokens = <TokenEntity>[];
      json['tokens'].forEach((v) {
        tokens.add(TokenEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['rpcUrl'] = this.rpcUrl;
    data['chainId'] = this.chainId;
    data['balance'] = this.balance;
    data['symbol'] = this.symbol;
    data['tokens'] = this
        .tokens
        .map(
          (e) => e.toJson(),
        )
        .toList();
    return data;
  }
}
