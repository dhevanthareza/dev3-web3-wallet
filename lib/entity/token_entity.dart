class TokenEntity {
  String? name;
  String? contract;
  String? symbol;
  String? decimal;

  TokenEntity({this.name, this.contract, this.symbol, this.decimal});

  TokenEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contract = json['contract'];
    symbol = json['symbol'];
    decimal = json['decimal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contract'] = this.contract;
    data['symbol'] = this.symbol;
    data['decimal'] = this.decimal;
    return data;
  }
}
