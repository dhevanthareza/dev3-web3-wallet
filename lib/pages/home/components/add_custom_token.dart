import 'package:dev3_wallet/controller/wallet_controller.dart';
import 'package:dev3_wallet/data/repository/chain_repository.dart';
import 'package:dev3_wallet/entity/token_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomToken extends StatefulWidget {
  const AddCustomToken({super.key});

  @override
  State<AddCustomToken> createState() => _AddCustomTokenState();
}

class _AddCustomTokenState extends State<AddCustomToken> {
  final TextStyle propertyStyle = const TextStyle(
    fontSize: 18,
    color: Colors.grey,
  );
  final TextStyle valueStyle = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  TextEditingController contractTextController = TextEditingController();
  String tokenName = "-";
  String symbol = "-";
  String decimal = "-";
  bool isFetchingTokenInfo = false;
  bool isTokenAvailable = false;
  TokenEntity? token;

  checkTokenInfo() async {
    setState(() {
      isTokenAvailable = false;
      isFetchingTokenInfo = true;
    });

    int currentActiveWalletIndex = WalletController.to.currentActiveWalletIndex;
    int currentActiveChainIndex = WalletController.to.currentActiveChainIndex;
    TokenEntity token = await ChainRepository.fetchTokenInfo(
      WalletController.to.wallets[currentActiveWalletIndex].publicAddress!,
      contractTextController.text,
      WalletController
          .to.wallets[currentActiveWalletIndex].chains[currentActiveChainIndex],
    );
    setState(() {
      isTokenAvailable = true;
      tokenName = token.name!;
      symbol = token.symbol!;
      decimal = token.decimal!;
      this.token = token;
      isFetchingTokenInfo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              TextFormField(
                controller: contractTextController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    borderSide: BorderSide(
                      color: Color(0xFF141414),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    borderSide: BorderSide(
                      color: Color(0xFF141414),
                    ),
                  ),
                  isDense: true,
                  label: Text(
                    "Contract Address",
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Name",
                    style: propertyStyle,
                  ),
                  Text(
                    tokenName,
                    style: valueStyle,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Symbol",
                    style: propertyStyle,
                  ),
                  Text(
                    symbol,
                    style: valueStyle,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Decimal",
                    style: propertyStyle,
                  ),
                  Text(
                    decimal,
                    style: valueStyle,
                  )
                ],
              )
            ],
          ),
          isFetchingTokenInfo
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF141414),
                  ),
                )
              : !isTokenAvailable
                  ? InkWell(
                      onTap: () {
                        checkTokenInfo();
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFF141414),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Check Token",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        WalletController.to.addTokenToChain(token!);
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFF141414),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Save Token",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
        ],
      ),
    );
  }
}
