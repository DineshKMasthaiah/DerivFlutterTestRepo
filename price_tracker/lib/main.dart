import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/price/price_cubit.dart';
import 'package:price_tracker/data/symbol/symbol_cubit.dart';
import 'package:price_tracker/ui/screens/home_screen.dart';
import 'package:price_tracker/utils/global_key.dart';

import 'data/api/web_socket_client.dart';
import 'data/price/price_repository.dart';
import 'data/price/price_service.dart';
import 'data/symbol/symbol_repository.dart';
import 'data/symbol/symbol_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: PTAppGlobalKey.globalKey,
      home: BlocProvider(
        create: (_) => PTSymbolCubit(
            PTSymbolRepository(PTSymbolService(PTWebSocketClient()))),
        child: BlocProvider(
            create: (_) => PTPriceCubit(
                PTPriceRepository(PTPriceService(PTWebSocketClient()))),
            child: const PTHomeScreen(title: 'Price Tracker')),
      ),
    );
  }
}
