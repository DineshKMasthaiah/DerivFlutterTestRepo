import 'package:price_tracker/data/api/generic_response.dart';
import 'package:price_tracker/data/price/price_service.dart';

class PTPriceRepository {
  PTPriceService priceService;
  double price = 0.0000;

  PTPriceRepository(this.priceService);

  Future<bool> sendSymbol(String symbol) async {
    return priceService.sendSymbol(symbol);
  }

  void listenForBroadCast(Function(PTGenericResponse) onEvent) {
    priceService.listenForBroadCast((genericResponse) {
      ///perform data operations such as sorting, filtering, truncating etc.
      onEvent(genericResponse);
    });
  }
}
