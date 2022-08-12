import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/price_cubit.dart';
import 'package:price_tracker/screens/home_screen.dart';
import 'package:price_tracker/utils/global_key.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: PTAppGlobalKey.globalKey,
      home: BlocProvider(
        create: (_)=> PTPriceCubit(),
          child: const PTHomeScreen(title: 'Flutter Demo Home Page')),
    );
  }
}


