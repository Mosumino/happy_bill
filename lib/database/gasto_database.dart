import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:happy_bill/models/gasto.dart';

class GastoDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Gasto> _todoslosgastos = [];

  // Inicializando la base de datos
  static Future<void> Inicializar() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([GastoSchema], directory: dir.path);
  }

  // Creamos un getter para acceder a nuestra lista, ya que es privada
  List<Gasto> get todoslosgastos => _todoslosgastos;

  // OPERACIONES:

  // CREAR GASTO
  Future<void> crearGastoNuevo(Gasto nuevoGasto) async {
    // Añadir a la base de datos
    await isar.writeTxn(() => isar.gastos.put(nuevoGasto));

    // Leer de nuevo el gasto
    await leerGastos();
  }

  // LEER GASTO
  Future<void> leerGastos() async {
    // Para obtener nuestros datos ya existentes
    List<Gasto> fetchedGastos = await isar.gastos.where().findAll();

    // Añadir a la lista de gastos
    _todoslosgastos.clear();
    _todoslosgastos.addAll(fetchedGastos);

    // Modificar la interfaz gráfica
    notifyListeners();
  }

  // ACTUALIZAR GASTO
  Future<void> actualizarGasto(int id, Gasto actualizarGasto) async {
    // Ver si el nuevo gasto tiene el mismo id que el existente
    actualizarGasto.id = id;

    // Actualizar en la base de datos
    await isar.writeTxn(() => isar.gastos.put(actualizarGasto));

    // Leerlo otra vez
    await leerGastos();
  }

  // ELIMINAR GASTO
  Future<void> eliminarGasto(int id) async {
    // Borrarlo de la base de datos
    await isar.writeTxn(() => isar.gastos.delete(id));

    // Leerlo de la base de datos
    await leerGastos();
  }
}
