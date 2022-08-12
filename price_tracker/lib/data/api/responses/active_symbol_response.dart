class ActiveSymbolResponse {
  List<ActiveSymbols>? markets;
  EchoReq? echoReq;
  String? msgType;

  ActiveSymbolResponse({this.markets, this.echoReq, this.msgType});

  ActiveSymbolResponse.fromJson(Map<String, dynamic> json) {
    if (json['active_symbols'] != null) {
      markets = <ActiveSymbols>[];
      json['active_symbols'].forEach((v) {
        markets!.add(ActiveSymbols.fromJson(v));
      });
    }
    echoReq = json['echo_req'] != null
        ? EchoReq.fromJson(json['echo_req'])
        : null;
    msgType = json['msg_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (markets != null) {
      data['active_symbols'] =
          markets!.map((v) => v.toJson()).toList();
    }
    if (echoReq != null) {
      data['echo_req'] = this.echoReq!.toJson();
    }
    data['msg_type'] = this.msgType;
    return data;
  }
}

class ActiveSymbols {
  int? allowForwardStarting;
  String? displayName;
  int? exchangeIsOpen;
  int? isTradingSuspended;
  String? market;
  String? marketDisplayName;
  double? pip;
  String? submarket;
  String? submarketDisplayName;
  String? symbol;
  String? symbolType;

  ActiveSymbols(
      {this.allowForwardStarting,
        this.displayName,
        this.exchangeIsOpen,
        this.isTradingSuspended,
        this.market,
        this.marketDisplayName,
        this.pip,
        this.submarket,
        this.submarketDisplayName,
        this.symbol,
        this.symbolType});

  ActiveSymbols.fromJson(Map<String, dynamic> json) {
    allowForwardStarting = json['allow_forward_starting'];
    displayName = json['display_name'];
    exchangeIsOpen = json['exchange_is_open'];
    isTradingSuspended = json['is_trading_suspended'];
    market = json['market'];
    marketDisplayName = json['market_display_name'];
    pip = json['pip'];
    submarket = json['submarket'];
    submarketDisplayName = json['submarket_display_name'];
    symbol = json['symbol'];
    symbolType = json['symbol_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allow_forward_starting'] = allowForwardStarting;
    data['display_name'] = displayName;
    data['exchange_is_open'] = exchangeIsOpen;
    data['is_trading_suspended'] = isTradingSuspended;
    data['market'] = market;
    data['market_display_name'] = marketDisplayName;
    data['pip'] = pip;
    data['submarket'] = submarket;
    data['submarket_display_name'] = submarketDisplayName;
    data['symbol'] = symbol;
    data['symbol_type'] = symbolType;
    return data;
  }
}

class EchoReq {
  String? activeSymbols;
  String? productType;

  EchoReq({this.activeSymbols, this.productType});

  EchoReq.fromJson(Map<String, dynamic> json) {
    activeSymbols = json['active_symbols'];
    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active_symbols'] = activeSymbols;
    data['product_type'] = productType;
    return data;
  }
}
