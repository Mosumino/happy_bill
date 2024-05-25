//ayuda

//string a double
import 'package:intl/intl.dart';

double convertirStringaDouble(String string){
  double? valor = double.tryParse(string);

  return valor ?? 0;
}


//formato del valor



String formatoValor(double valor) {
  final formato = NumberFormat.currency(locale: 'en_US', symbol: "\$", decimalDigits: 2);
  return formato.format(valor);
}
