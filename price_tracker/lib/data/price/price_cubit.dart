import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/price/price_repository.dart';

import 'price_response.dart';

class PTPriceCubit extends Cubit<num> {
  PTPriceRepository priceRepository;

  PTPriceCubit(this.priceRepository) : super(0.0);


  void onSymbolChange(String symbol) {
    priceRepository.sendSymbol(symbol);
    listenForBroadCast();
  }

  void listenForBroadCast() {
    priceRepository.listenForBroadCast((genericResponse) {
      if (genericResponse.isSuccessful) {
        emit((genericResponse.data as PriceDataModel).tick?.quote ?? 0.0);
      } else {
        addError(genericResponse.errorResponse?.message ?? "error");
      }
    });
  }
}
