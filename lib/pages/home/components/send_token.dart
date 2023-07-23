import 'package:dev3_wallet/controller/wallet_controller.dart';
import 'package:dev3_wallet/data/repository/chain_repository.dart';
import 'package:dev3_wallet/entity/token_entity.dart';
import 'package:flutter/material.dart';

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

  void handleReviewButtonClick() {
    ChainRepository.fetchGasFee(
      WalletController.to.currentActiveWallet.privateKey!,
      WalletController.to.currentActiveChain,
    );
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
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: DropdownButtonFormField<String>(
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Color(0xFF141414)),
                          isDense: true,
                          decoration: textFieldDecoration.copyWith(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 10,
                            ),
                          ),
                          value: selectedTokenContract,
                          items: [
                            DropdownMenuItem(
                              value: "NATIVE",
                              child: Text(
                                WalletController
                                    .to
                                    .wallets[WalletController
                                        .to.currentActiveWalletIndex]
                                    .chains[WalletController
                                        .to.currentActiveChainIndex]
                                    .symbol!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            ...WalletController
                                .to
                                .wallets[WalletController
                                    .to.currentActiveWalletIndex]
                                .chains[
                                    WalletController.to.currentActiveChainIndex]
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
                            }
                          },
                        ),
                      ),
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
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          if (selectedTokenContract == "NATIVE") {
                            amountTextController.text =
                                WalletController.to.nativeBalance.toString();
                          } else {
                            amountTextController.text = WalletController
                                .to.contractToBalance[selectedTokenContract]!;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
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
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              handleReviewButtonClick();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(15)),
              child: const Center(
                child: Text(
                  "REVIEW",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
