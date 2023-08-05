import 'dart:math';

import 'package:dev3_wallet/controller/wallet_controller.dart';
import 'package:dev3_wallet/data/repository/chain_repository.dart';
import 'package:dev3_wallet/entity/token_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class SendToken extends StatefulWidget {
  const SendToken({super.key});

  @override
  State<SendToken> createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  final textFieldDecoration = const InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFF141414),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFF141414),
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFF141414),
      ),
    ),
    isDense: true,
  );
  TextEditingController destinationTextController = TextEditingController();
  TextEditingController amountTextController = TextEditingController();

  String selectedTokenContract = "NATIVE";
  String gasFee = "";

  bool isFetchingGasFee = false;
  bool isSubmittingTransaction = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fetchGasFee() async {
    setState(() {
      isFetchingGasFee = true;
      gasFee = "";
    });

    // Transaction Desc
    String destinationAddress = destinationTextController.text;
    EtherAmount? amount = EtherAmount.fromBigInt(
      EtherUnit.wei,
      BigInt.from(
        double.parse(
              amountTextController.text == "" ? "0" : amountTextController.text,
            ) *
            pow(10, 18),
      ),
    );

    // Fetch Gas Fee
    EtherAmount gasEstimation = selectedTokenContract == "NATIVE"
        ? await ChainRepository.fetchEstimateGasFee(
            receipentPublicAddress: destinationAddress,
            chain: WalletController.to.currentActiveChain,
          )
        : await ChainRepository.fetchEstimateTokenTransferGasFee(
            senderPublicAddress:
                WalletController.to.currentActiveWallet.publicAddress!,
            receipentPublicAddress: destinationAddress,
            contractAddress: selectedTokenContract,
            chain: WalletController.to.currentActiveChain,
            value: amount,
          );

    setState(() {
      isFetchingGasFee = false;
      gasFee = gasEstimation
          .getValueInUnit(EtherUnit.ether)
          .toStringAsFixed(10)
          .toString();
    });
  }

  void sendTransaction() async {
    setState(() {
      isSubmittingTransaction = true;
    });
    try {
      // Setup Transaction Desc
      EtherAmount amount = EtherAmount.fromBigInt(
        EtherUnit.wei,
        BigInt.from(
          double.parse(amountTextController.text) * pow(10, 18),
        ),
      );
      String destinationAddress = destinationTextController.text;

      // Send Transaction
      String transactionAddress = selectedTokenContract == "NATIVE"
          ? await ChainRepository.sendTransaction(
              WalletController.to.currentActiveWallet.privateKey!,
              destinationAddress,
              WalletController.to.currentActiveChain,
              amount,
            )
          : await ChainRepository.transferToken(
              receipentPublicAddress: destinationAddress,
              chain: WalletController.to.currentActiveChain,
              contractAddressHex: selectedTokenContract,
              amount: amount,
            );

      // Getting Done Transaction

      reset();
      Get.showSnackbar(GetSnackBar(
        title: "Transaction Success",
        message: "${transactionAddress}",
      ));
    } on Exception catch (err) {
      Get.showSnackbar(GetSnackBar(
        title: "Transaction Failed",
        message: err.toString(),
      ));
      print(err);
    }
    setState(() {
      isSubmittingTransaction = false;
    });
  }

  bool isCanSubmit() {
    if (gasFee == "") {
      return false;
    }
    if (amountTextController.text == "" ||
        destinationTextController.text == "") {
      return false;
    }
    return true;
  }

  void reset() {
    destinationTextController.text = "";
    amountTextController.text = "";
    gasFee = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Send Asset",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF141414),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: destinationTextController,
                    decoration: textFieldDecoration.copyWith(
                      label: Text("Receipent"),
                    ),
                    onChanged: (val) {
                      fetchGasFee();
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 100, child: _buildTokenSelect()),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: amountTextController,
                          keyboardType: TextInputType.number,
                          decoration: textFieldDecoration.copyWith(
                            label: Text("Amount"),
                          ),
                          onChanged: (val) {
                            fetchGasFee();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      _buildMaxButton()
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gas Fees (${WalletController.to.currentActiveChain.symbol})",
                        style: TextStyle(
                          color: Color(0xFF141414).withOpacity(0.4),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      isFetchingGasFee
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator())
                          : Text(
                              gasFee,
                              style: const TextStyle(
                                color: Color(0xFF141414),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ],
                  )
                ],
              ),
            ),
          ),
          _buildSubmitButton()
        ],
      ),
    );
  }

  Widget _buildMaxButton() {
    return InkWell(
      onTap: () {
        if (selectedTokenContract == "NATIVE") {
          amountTextController.text =
              WalletController.to.nativeBalance.toString();
        } else {
          amountTextController.text =
              WalletController.to.contractToBalance[selectedTokenContract]!;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
            color: Color(0xFF141414).withOpacity(0.1),
            borderRadius: BorderRadius.circular(13)),
        child: const Text(
          "MAX",
          style: TextStyle(
            color: Color(0xFF141414),
          ),
        ),
      ),
    );
  }

  Widget _buildTokenSelect() {
    return DropdownButtonFormField<String>(
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: Color(0xFF141414),
      ),
      isDense: true,
      decoration: textFieldDecoration.copyWith(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 8,
        ),
      ),
      value: selectedTokenContract,
      items: [
        DropdownMenuItem(
          value: "NATIVE",
          child: Text(
            WalletController
                .to
                .wallets[WalletController.to.currentActiveWalletIndex]
                .chains[WalletController.to.currentActiveChainIndex]
                .symbol!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        ...WalletController
            .to
            .wallets[WalletController.to.currentActiveWalletIndex]
            .chains[WalletController.to.currentActiveChainIndex]
            .tokens
            .map((TokenEntity token) => DropdownMenuItem(
                  value: token.contract,
                  child: Text(
                    token.symbol!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ))
            .toList()
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() {
            selectedTokenContract = val;
            amountTextController.text = "";
          });
          fetchGasFee();
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return isSubmittingTransaction
        ? const SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          )
        : InkWell(
            onTap: () {
              if (isCanSubmit() == false) {
                return;
              }
              sendTransaction();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: const Color(0xFF141414)
                      .withOpacity(isCanSubmit() ? 1 : 0.3),
                  borderRadius: BorderRadius.circular(15)),
              child: const Center(
                child: Text(
                  "Submit Transaction",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
  }
}
