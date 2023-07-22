import 'package:dev3_wallet/controller/wallet_controller.dart';
import 'package:dev3_wallet/data/repository/account_repository.dart';
import 'package:dev3_wallet/pages/login.dart';
import 'package:dev3_wallet/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web3dart/web3dart.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    // EthereumAddress address = WalletService.generatePublicKey();
    // setState(() {
    //   walletAddress = address.hex;
    // });

    // EtherAmount amount = await WalletService.getBalance();

    // setState(() {
    //   balance = amount.getValueInUnit(EtherUnit.ether).toString();
    // });
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
              : Column(
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
                          Text(
                            "${state.currentActiveWallet!.name!}",
                            style: const TextStyle(
                              color: Color(0xFF141414),
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          _buildIdentityCard(state),
                          const SizedBox(
                            height: 18,
                          ),
                          _buildActionButton(state)
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            const TabBar(
                              labelColor: Colors.blue,
                              tabs: [
                                Tab(text: 'Assets'),
                                Tab(text: 'NFTs'),
                                Tab(text: 'Options'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // Assets Tab
                                  Column(
                                    children: [
                                      Card(
                                        margin: const EdgeInsets.all(16.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${state.currentActiveChain!.symbol!}",
                                                style: const TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                state.nativeBalance == 0
                                                    ? "0"
                                                    : "${state.nativeBalance}"
                                                        .substring(0, 10),
                                                style: const TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SingleChildScrollView(),
                                  SingleChildScrollView()
                                  // NFTs Tab
                                  // SingleChildScrollView(
                                  //     child: NFTListPage(
                                  //         address: walletAddress, chain: 'sepolia')),
                                  // Activities Tab
                                  // Center(
                                  //   child: ListTile(
                                  //     leading: const Icon(Icons.logout),
                                  //     title: const Text('Logout'),
                                  //     onTap: () async {
                                  //       SharedPreferences prefs =
                                  //           await SharedPreferences.getInstance();
                                  //       await prefs.remove('privateKey');
                                  //       // ignore: use_build_context_synchronously
                                  //       Navigator.pushAndRemoveUntil(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               const CreateOrImportPage(),
                                  //         ),
                                  //         (route) => false,
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildActionButton(WalletController state) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141414),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: const [
              Text(
                "Send",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.send,
                color: Colors.white,
                size: 15,
              )
            ],
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
            children: state.currentActiveWallet!.chains
                .map(
                  (e) => InkWell(
                    onTap: () {
                      state.handleSelectNetwork(e);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: e.chainId == state.currentActiveChain!.chainId
                              ? Color(0xFF141414).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                      child: Text(
                        "${e.name!}",
                        style:
                            TextStyle(color: Color(0xFF141414), fontSize: 20),
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
                    "${state.currentActiveChain!.name} Chain",
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
          const SizedBox(
            height: 18,
          ),
          Text(
            "${state.currentActiveWallet!.publicAddress}",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "${state.currentActiveChain!.symbol} ${state.nativeBalance}",
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
}
