import 'package:price_tracker/data/api/generic_response.dart';
import 'package:price_tracker/data/symbol/active_symbol_response.dart';
import 'package:price_tracker/data/symbol/symbol_service.dart';

class PTSymbolRepository{
  PTSymbolService symbolService;
  PTSymbolRepository(this.symbolService);
  var myMap = <String, Set<String>>{"none":{"none"}};

void sendMessage(String activeSymbols,String productType, Function(PTGenericResponse) callback){
  symbolService.sendMessage(activeSymbols,  productType, (genericResponse){
    if(genericResponse.isSuccessful) {
      var myMap = <String, Set<String>>{};
      ActiveSymbolResponse model = genericResponse.data;
      for (ActiveSymbols activeSymbol in model.markets ?? []) {
        if (myMap[activeSymbol.market ?? ""]?.isEmpty ?? true) {
          myMap[activeSymbol.market ?? ""] = <String>{};
        }
        myMap[activeSymbol.market ?? ""]?.add(activeSymbol.symbol ?? "");
      }
      genericResponse.data = myMap;
    }
    callback(genericResponse);
  });
}

}