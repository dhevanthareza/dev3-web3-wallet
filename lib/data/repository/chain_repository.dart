import 'package:dev3_wallet/controller/wallet_controller.dart';
import 'package:dev3_wallet/entity/chain_entity.dart';
import 'package:dev3_wallet/entity/token_entity.dart';
import 'package:get_storage/get_storage.dart';
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

  static Future<EtherAmount> fetchGasFee(
      String privateAddress, ChainEntity chain) async {
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    EtherAmount gasPrice = await ethClient.getGasPrice();
    return gasPrice;
  }

  static Future<EtherAmount> fetchEstimateGasFee({
    required String receipentPublicAddress,
    required chain,
  }) async {
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Gas Amount
    BigInt estimatedGasAmount = await ethClient.estimateGas(
      sender:
          EthereumAddress.fromHex("0xdf6D20811774aE01AaA4C13c32EebdD4290cA7fd"),
      to: EthereumAddress.fromHex(receipentPublicAddress),
    );

    // Gas Price
    EtherAmount gasPrice = await ethClient.getGasPrice();

    // Gas Fee
    EtherAmount estimatedGasFee = EtherAmount.inWei(
      BigInt.from(gasPrice.getValueInUnit(EtherUnit.wei)) * estimatedGasAmount,
    );

    return estimatedGasFee;
  }

  static Future<EtherAmount> fetchEstimateTokenTransferGasFee({
    required String receipentPublicAddress,
    required String senderPublicAddress,
    required String contractAddress,
    required ChainEntity chain,
    required EtherAmount value,
  }) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Contract Data
    final transferFunction = ContractFunction(
      'transfer',
      [
        FunctionParameter("_to", parseAbiType("address")),
        FunctionParameter("_value", parseAbiType("uint256")),
      ],
    );
    final data = transferFunction.encodeCall([
      EthereumAddress.fromHex(receipentPublicAddress),
      value.getInWei,
    ]);

    // Gas Amount
    BigInt estimatedGasAmount = await ethClient.estimateGas(
      sender: EthereumAddress.fromHex(senderPublicAddress),
      to: EthereumAddress.fromHex(contractAddress),
      data: data,
    );

    // Gas Price
    EtherAmount gasPrice = await ethClient.getGasPrice();

    // Gas Fee
    EtherAmount estimatedGasFee = EtherAmount.inWei(
      BigInt.from(gasPrice.getValueInUnit(EtherUnit.wei)) * estimatedGasAmount,
    );

    return estimatedGasFee;
  }

  static Future<String> sendTransaction(
      String privateKey,
      String receipentPublicAddress,
      ChainEntity chain,
      EtherAmount value) async {
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);
    print(privateKey);
    print(value.getValueInUnit(EtherUnit.wei));
    EtherAmount gasPrice = await ethClient.getGasPrice();
    String transaction = await ethClient.sendTransaction(
        EthPrivateKey.fromHex("0x$privateKey"),
        Transaction(
          to: EthereumAddress.fromHex(receipentPublicAddress),
          value: value,
          gasPrice: gasPrice,
        ),
        chainId: int.parse(chain.chainId!));
    print(transaction);
    return transaction;
  }

  static Future<String> transferToken({
    required String receipentPublicAddress,
    required ChainEntity chain,
    required String contractAddressHex,
    required EtherAmount amount,
  }) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Setup Credential
    final EthereumAddress contractAddress =
        EthereumAddress.fromHex(contractAddressHex);
    final EthereumAddress recipentAddress =
        EthereumAddress.fromHex(receipentPublicAddress);
    final EthereumAddress senderAddress = EthereumAddress.fromHex(
        WalletController.to.currentActiveWallet.publicAddress!);
    EthPrivateKey privateKey = EthPrivateKey.fromHex(
      '0x${WalletController.to.currentActiveWallet.privateKey}',
    );

    // Contract Data
    final transferFunction = ContractFunction(
      'transfer',
      [
        FunctionParameter("_to", parseAbiType("address")),
        FunctionParameter("_value", parseAbiType("uint256")),
      ],
    );
    final data = transferFunction.encodeCall([
      recipentAddress,
      amount.getInWei,
    ]);

    final transaction = Transaction(
      from: senderAddress,
      to: contractAddress,
      value: EtherAmount.zero(), // For token transfers, the value is zero
      data: data,
    );

    String result = await ethClient.sendTransaction(
      privateKey,
      transaction,
      chainId: int.parse(WalletController.to.currentActiveChain.chainId!),
    );

    return result;
  }
}
