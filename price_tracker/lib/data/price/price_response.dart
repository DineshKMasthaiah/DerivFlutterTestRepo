class PriceDataModel {
  EchoReq? echoReq;
  String? msgType;
  Subscription? subscription;
  Tick? tick;

  PriceDataModel({this.echoReq, this.msgType, this.subscription, this.tick});

  PriceDataModel.fromJson(Map<String, dynamic> json) {
    echoReq = json['echo_req'] != null
        ? new EchoReq.fromJson(json['echo_req'])
        : null;
    msgType = json['msg_type'];
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
    tick = json['tick'] != null ? new Tick.fromJson(json['tick']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.echoReq != null) {
      data['echo_req'] = this.echoReq!.toJson();
    }
    data['msg_type'] = this.msgType;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    if (this.tick != null) {
      data['tick'] = this.tick!.toJson();
    }
    return data;
  }
}

class EchoReq {
  int? subscribe;
  String? ticks;

  EchoReq({this.subscribe, this.ticks});

  EchoReq.fromJson(Map<String, dynamic> json) {
    subscribe = json['subscribe'];
    ticks = json['ticks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscribe'] = this.subscribe;
    data['ticks'] = this.ticks;
    return data;
  }
}

class Subscription {
  String? id;

  Subscription({this.id});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Tick {
  double? ask;
  double? bid;
  int? epoch;
  String? id;
  int? pipSize;
  double? quote;
  String? symbol;

  Tick(
      {this.ask,
        this.bid,
        this.epoch,
        this.id,
        this.pipSize,
        this.quote,
        this.symbol});

  Tick.fromJson(Map<String, dynamic> json) {
    ask = json['ask'];
    bid = json['bid'];
    epoch = json['epoch'];
    id = json['id'];
    pipSize = json['pip_size'];
    quote = json['quote'] as double;
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ask'] = this.ask;
    data['bid'] = this.bid;
    data['epoch'] = this.epoch;
    data['id'] = this.id;
    data['pip_size'] = this.pipSize;
    data['quote'] = this.quote;
    data['symbol'] = this.symbol;
    return data;
  }
}
