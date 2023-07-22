import 'package:dev3_wallet/data/repository/account_repository.dart';
import 'package:dev3_wallet/entity/wallet_entity.dart';
import 'package:dev3_wallet/pages/home/wallet.dart';
import 'package:dev3_wallet/pages/login.dart';
import 'package:dev3_wallet/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }

  @override
  Widget build(BuildContext context) {
    List<WalletEntity> accounts = AccountRepository.fetchWallet();
    print(accounts);
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: getMaterialColor(Color(0xFF141414)),
      ),
      home: accounts.isNotEmpty ? WalletPage() : LoginPage(),
    );
  }
}
