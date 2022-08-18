class PriceRequest {
  String? ticks;

  PriceRequest({this.ticks});

  PriceRequest.fromJson(Map<String, dynamic> json) {
    ticks = json['ticks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticks'] = ticks;
    return data;
  }
}
