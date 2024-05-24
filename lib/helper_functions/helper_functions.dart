//ayuda

//string a double

double convertirStringaDouble(String string){
  double? valor = double.tryParse(string);

  return valor ?? 0;
}