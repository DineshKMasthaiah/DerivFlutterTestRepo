import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/common/base_screen.dart';
import 'package:price_tracker/data/api/responses/active_symbol_response.dart';
import 'package:price_tracker/data/price_cubit.dart';
import 'package:price_tracker/utils/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  var myMap = <String, Set<String>>{
    "none": <String>{"none"}
  };
  WebSocketChannel? _channel;
  bool subscribed = false;
  String selectedMarket = '';
  String selectedSymbol = '';
  bool fetchingSymbols = false;
  bool fetchingPrice = false;
  String lastPrice = '0';

  //late PTPriceCubit priceCubit;
  @override
  void initState() {
    fetchingSymbols = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PTPriceCubit>().getSymbols().then((data) {
        fetchingSymbols = false;
        _extractSymbols(data);
        selectedMarket = myMap.keys.first;
        selectedSymbol = myMap[selectedMarket]?.first ?? "";

        fetchingPrice = true;
        PTLogger.showSnackBar(
            "fetching price for $selectedSymbol symbol of $selectedMarket market");
        context.read<PTPriceCubit>().onSymbolChange(selectedSymbol);
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: fetchingSymbols
          ? buildCircularProgressIndicator(
              leftPadding:screenSize(context).width / 2,
              topPadding:screenSize(context).height / 2,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildDropdownButton(context, selectedMarket, myMap.keys,
                    (selected) {
                  setState(() {
                    selectedMarket = selected;
                    selectedSymbol = myMap[selectedMarket]?.first ?? "";
                    fetchingPrice = true;
                    PTLogger.showSnackBar(
                        "fetching price for $selectedSymbol symbol of $selectedMarket market");
                    context.read<PTPriceCubit>().onSymbolChange(selectedSymbol);
                  });
                  PTLogger.showSnackBar(
                      "selected:$selectedMarket market with $selectedSymbol");
                }),
                _buildDropdownButton(
                    context, selectedSymbol, myMap[selectedMarket], (selected) {
                  lastPrice = '0';

                  setState(() {
                    selectedSymbol = selected;
                  });
                  PTLogger.showSnackBar(
                      "selected:$selectedSymbol symbol for $selectedMarket market");
                  fetchingPrice = true;
                  PTLogger.showSnackBar(
                      "fetching price for $selected symbol of $selectedMarket market");
                  context.read<PTPriceCubit>().onSymbolChange(selectedSymbol);
                }),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenSize(context).height / 2,
                      left: screenSize(context).width / 2),
                  child: BlocBuilder<PTPriceCubit, String>(
                      builder: (context, price) {
                    //PTLogger.showSnackBar("got price update for $selectedSymbol symbol of $selectedMarket market");
                    fetchingPrice = false;
                    return SizedBox(width: 100,
                      child: Text(
                        'price:$price',
                        style: TextStyle(color: _getColor(price)),
                      ),
                    );
                  }),
                )
              ],
            ),
    ); // This trailing comma makes auto-formatting nicer for build methods
  }

  Color _getColor(String currentPrice) {
    try {
      if (double.parse(currentPrice) > double.parse(lastPrice)) {
        lastPrice = currentPrice;
        return Colors.green;
      }
      if (double.parse(currentPrice) < double.parse(lastPrice)) {
        lastPrice = currentPrice;
        return Colors.red;
      }
    } catch (exception) {}
    lastPrice = currentPrice;
    return Colors.grey;
  }

  Widget buildCircularProgressIndicator({double leftPadding=0, double topPadding=0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding),
      child: const CircularProgressIndicator(),
    );
  }

  DropdownButton<String> _buildDropdownButton(
      BuildContext context, String selected, var list, var onSelected) {
    return DropdownButton<String>(
      value: selected,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
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

  void _extractSymbols(dynamic data) {
    ActiveSymbolResponse model =
        ActiveSymbolResponse.fromJson(jsonDecode(data));
    myMap.clear();
    for (ActiveSymbols activeSymbol in model.markets ?? []) {
      if (myMap[activeSymbol.market ?? ""]?.isEmpty ?? true) {
        myMap[activeSymbol.market ?? ""] = <String>{};
      }
      myMap[activeSymbol.market ?? ""]?.add(activeSymbol.symbol ?? "");
    }
  }

  @override
  void dispose() {
    context.read<PTPriceCubit>().unsubscribe();
    super.dispose();
  }
}
