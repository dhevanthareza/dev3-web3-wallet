import 'package:dev3_wallet/entity/chain_entity.dart';
import 'package:dev3_wallet/entity/token_entity.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:path/path.dart' show join, dirname;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

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

  static Future<TokenEntity> fetchTokenInfo(
    String publicAddress,
    String contractAddressHex,
    ChainEntity chain,
  ) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Setup Credential
    final EthereumAddress contractAddress =
        EthereumAddress.fromHex(contractAddressHex);
    final EthereumAddress address = EthereumAddress.fromHex(publicAddress);

    // Setup Contract
    String abiCode =
        await rootBundle.loadString('assets/abi/erc20tokenabi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'Erc20Token'),
      contractAddress,
    );
    final nameFunction = contract.function('name');
    final symbolFunction = contract.function('symbol');
    final decimalsFunction = contract.function('decimals');

    final name = await ethClient
        .call(contract: contract, function: nameFunction, params: []);
    final decimal = await ethClient
        .call(contract: contract, function: decimalsFunction, params: []);
    final symbol = await ethClient
        .call(contract: contract, function: symbolFunction, params: []);
    TokenEntity token = TokenEntity(
        name: name[0].toString(),
        contract: contractAddressHex,
        symbol: symbol[0].toString(),
        decimal: decimal[0].toString());
    return token;
  }

  static Future<String> fetchBalanceOfToken(
    String publicAddress,
    String contractAddressHex,
    ChainEntity chain,
  ) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Setup Credential
    final EthereumAddress contractAddress =
        EthereumAddress.fromHex(contractAddressHex);
    final EthereumAddress address = EthereumAddress.fromHex(publicAddress);

    // Setup Contract
    String abiCode =
        await rootBundle.loadString('assets/abi/erc20tokenabi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'Erc20Token'),
      contractAddress,
    );
    final balanceFunction = contract.function('balanceOf');

    final balance = await ethClient
        .call(contract: contract, function: balanceFunction, params: [address]);

    return balance[0].toString();
  }
}
