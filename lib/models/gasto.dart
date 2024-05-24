import 'package:isar/isar.dart';
//para generar el isar file
part 'gasto.g.dart';

@Collection()
class Gasto {
  final String nombre;
  final double valor;
  final DateTime fecha;
  Id id = Isar.autoIncrement;

  Gasto({
    required this.nombre,
    required this.valor,
    required this.fecha,
  });

}