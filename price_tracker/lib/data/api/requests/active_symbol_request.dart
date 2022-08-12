class ActiveSymbolRequest {
  String? activeSymbols;
  String? productType;

  ActiveSymbolRequest({this.activeSymbols, this.productType});

  ActiveSymbolRequest.fromJson(Map<String, dynamic> json) {
    activeSymbols = json['active_symbols'];
    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['active_symbols'] = activeSymbols;
    data['product_type'] = productType;
    return data;
  }
}
