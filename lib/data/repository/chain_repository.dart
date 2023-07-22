import 'package:dev3_wallet/entity/chain_entity.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ChainRepository {
  static Future<double> fetchBalanceFromChain(
      String address, ChainEntity chain) async {
    print(
        "Getting ${chain.symbol} Balance FROM ${address} on ${chain.name} CHAIN (${chain.rpcUrl})");
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    var privateKey = EthPrivateKey.fromHex(address);
    EtherAmount balance = await ethClient.getBalance(privateKey.address);
    print(balance.getValueInUnit(EtherUnit.ether));
    return balance.getValueInUnit(EtherUnit.ether);
  }
}
