import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/symbol/symbol_repository.dart';

class PTSymbolCubit extends Cubit<Map<String, Set<String>>> {
  PTSymbolRepository symbolRepository;

  PTSymbolCubit(this.symbolRepository) : super(symbolRepository.myMap);

  /// Fetch symbols and markets. one time call. stream closes itself after receiving first event
  void getSymbols(String activeSymbols, String productType) {
    symbolRepository.sendMessage(activeSymbols, productType, (genericResponse) {
      if (genericResponse.isSuccessful) {
        emit(genericResponse.data);
      } else {
        addError(genericResponse.errorResponse?.message ?? "error");
      }
    });
  }
}
