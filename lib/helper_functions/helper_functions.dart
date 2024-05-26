//ayuda

//string a double

import 'package:intl/intl.dart';

double convertirStringaDouble(String string) {
  double? valor = double.tryParse(string);

  return valor ?? 0;
}

//double gasto a pesos y centavos
String formatAmount(double amount) {
  final format =
      NumberFormat.currency(locale: "en_Pesos", symbol: "\$", decimalDigits: 1);
  return format.format(amount);
}
