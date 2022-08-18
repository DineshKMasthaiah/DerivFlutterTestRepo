import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/symbol/symbol_cubit.dart';
import 'package:price_tracker/ui/base_screen.dart';
import 'package:price_tracker/data/price/price_cubit.dart';
import 'package:price_tracker/utils/logger.dart';

class PTHomeScreen extends StatefulWidget {
  const PTHomeScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<PTHomeScreen> createState() => _PTHomeScreenState();
}

class _PTHomeScreenState extends State<PTHomeScreen> with PTBaseScreen {
  bool subscribed = false;
  String selectedMarket = '';
  String selectedSymbol = '';
  bool fetchingSymbols = false;
  bool fetchingPrice = false;
  num lastPrice = 0.00;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ///Assuming that the initial values are "brief", "basic"
      context.read<PTSymbolCubit>().getSymbols("brief", "basic");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<PTSymbolCubit, Map<String, Set<String>>>(
          builder: (context, myMap) {
        selectedMarket = myMap.keys.first;
        selectedSymbol = myMap[selectedMarket]?.first ?? "";
        context.read<PTPriceCubit>().onSymbolChange(selectedSymbol);
        return myMap.keys.first == "none"
            ? _buildCircularProgressIndicator(
                leftPadding: screenSize(context).width / 2,
                topPadding: screenSize(context).height / 2,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatefulBuilder(
                    builder: (context, prevState) {
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            _buildDropdownButton(selectedMarket, myMap.keys,
                                (selected) {
                              prevState(() {
                                selectedMarket = selected;
                                selectedSymbol =
                                    myMap[selectedMarket]?.first ?? "";
                                fetchingPrice = true;
                              });
                              context
                                  .read<PTPriceCubit>()
                                  .onSymbolChange(selectedSymbol);
                            }),
                            _buildDropdownButton(
                                selectedSymbol, myMap[selectedMarket],
                                (selected) {
                              lastPrice = 0.00;
                              prevState(() {
                                selectedSymbol = selected;
                                fetchingPrice = true;
                              });
                              context
                                  .read<PTPriceCubit>()
                                  .onSymbolChange(selectedSymbol);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                  BlocBuilder<PTPriceCubit, num>(
                      buildWhen: (s1, s2) => true,
                      builder: (context, price) {
                        //PTLogger.showSnackBar("got price update for $selectedSymbol symbol of $selectedMarket market");
                        fetchingPrice = false;
                        return Center(
                          child: Text(
                            'Price:$price',
                            style: TextStyle(color: _getColor(price),fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        );
                      })
                ],
              );
      }),
    ); // This trailing comma makes auto-formatting nicer for build methods
  }

  Color _getColor(num currentPrice) {
    try {
      if (currentPrice > lastPrice) {
        lastPrice = currentPrice;
        return Colors.green;
      }
      if (currentPrice < lastPrice) {
        lastPrice = currentPrice;
        return Colors.red;
      }
    } catch (exception) {
      ///
    }
    lastPrice = currentPrice;
    return Colors.grey;
  }

  Widget _buildCircularProgressIndicator(
      {double leftPadding = 0, double topPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding),
      child: const CircularProgressIndicator(),
    );
  }

  DropdownButton<String> _buildDropdownButton(
      String selected, var list, var onSelected) {
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(2.0),
      focusColor: Colors.green,
      iconSize: 40,
      isExpanded: true,
      value: selected,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      elevation: 16,
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (String? newValue) {
        onSelected(newValue);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    context.read<PTPriceCubit>().close();
    super.dispose();
  }
}
