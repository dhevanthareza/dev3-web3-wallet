import 'package:dev3_wallet/controller/wallet_controller.dart';
import 'package:dev3_wallet/data/repository/account_repository.dart';
import 'package:dev3_wallet/entity/token_entity.dart';
import 'package:dev3_wallet/pages/home/components/add_custom_token.dart';
import 'package:dev3_wallet/pages/home/components/send_token.dart';
import 'package:dev3_wallet/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      init: WalletController(),
      builder: (state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: state.isInitializing
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${state.wallets[state.currentActiveWalletIndex].name!}",
                                    style: const TextStyle(
                                      color: Color(0xFF141414),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    AccountRepository.removeWallet();
                                    Get.offAll(LoginPage());
                                  },
                                  child: Icon(
                                    Icons.logout,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            _buildIdentityCard(state),
                            const SizedBox(
                              height: 18,
                            ),
                            _buildActionButton(state),
                            const SizedBox(
                              height: 28,
                            ),
                            _buildAssetSection(state)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildActionButton(WalletController state) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Get.bottomSheet(SendToken());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF141414).withOpacity(0.1),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: Color(0xFF141414),
                    size: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Send",
                    style: TextStyle(
                      color: Color(0xFF141414),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 2,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF141414).withOpacity(0.1),
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.arrow_downward,
                  color: Color(0xFF141414),
                  size: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Deposit",
                  style: TextStyle(
                      color: Color(0xFF141414), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildIdentityCard(WalletController state) {
    Widget _buildChainBottomSheet() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: state.wallets[state.currentActiveWalletIndex].chains
                .map(
                  (e) => InkWell(
                    onTap: () {
                      state.handleSelectNetwork(e);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: e.chainId == state.currentActiveChain.chainId
                              ? const Color(0xFF141414).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 25),
                      child: Text(
                        "${e.name!}",
                        style: const TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.bottomSheet(_buildChainBottomSheet());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${state.currentActiveChain.name} Chain",
                        style: TextStyle(color: Color(0xFF141414)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF141414),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  state.fetchBalanceFromChain();
                },
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            "${state.currentActiveWallet.publicAddress}",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "${state.currentActiveChain.symbol} ${state.nativeBalance}",
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetSection(WalletController state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Asset",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF141414),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${state.currentActiveChain.symbol}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                width: 150,
              ),
              Expanded(
                child: Text(
                  state.nativeBalance.toString().length > 10
                      ? state.nativeBalance.toString().substring(0, 10)
                      : state.nativeBalance.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ...state.wallets[state.currentActiveWalletIndex]
            .chains[state.currentActiveChainIndex].tokens
            .map((TokenEntity token) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF141414).withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${token.symbol}",
                  style:
                      const TextStyle(color: Color(0xFF141414), fontSize: 18),
                ),
                Text(
                  state.contractToBalance[token.contract!] != null
                      ? state.contractToBalance[token.contract!]!.length > 10
                          ? state.contractToBalance[token.contract!]!
                              .substring(0, 10)
                          : state.contractToBalance[token.contract!]!
                      : "0",
                  style:
                      const TextStyle(color: Color(0xFF141414), fontSize: 18),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          );
        }).toList(),
        InkWell(
          onTap: () {
            Get.bottomSheet(AddCustomToken());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF141414).withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Add Token",
                  style: TextStyle(
                      color: Color(0xFF141414),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 7,
                ),
                Icon(Icons.add_circle_outline)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
