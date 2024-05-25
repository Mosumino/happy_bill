import'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:happy_bill/models/gasto.dart';
class GastoDatabase extends ChangeNotifier{
  static late Isar isar;
  List<Gasto>_todoslosgastos = [];

  //inicializando la base de datos
  static Future<void>Inicializar() async{
    final dir  = await getApplicationDocumentsDirectory();
    isar = await Isar.open([GastoSchema], directory: dir.path);
  }
  
 //creamos un getter para acceder a nuestra lista, ya que es privada
 List<Gasto> get todoslosgastos =>_todoslosgastos;


//OPERACIONES:

//CREAR GASTO
Future<void>crearGastoNuevo(Gasto nuevoGasto) async{
  //añadir a la base de datos
  await isar.writeTxn(() => isar.gastos.put(nuevoGasto));

  //leer de nuevo el gasto
  await leerGastos();


}

//LEER  GASTO

Future<void> leerGastos() async {
  //para obtener nuestros datos ya existentes
  List<Gasto> fetchedGastos =  await isar.gastos.where().findAll();

  //añadir a la lista de gastos
  _todoslosgastos.clear();
  _todoslosgastos.addAll(fetchedGastos);
  

  //modificar la interfaz gráfica
  notifyListeners();
}

//Actualizar gasto
Future<void>actualizarGasto(int id, Gasto actualizarGasto) async{
  //ver si el nuevo gasto tiene el mismo id que el existente
  actualizarGasto.id = id;

  //actualizar en la base de datos
  await isar.writeTxn(()=> isar.gastos.put(actualizarGasto));

  //leerlo otra vez

  await leerGastos();
}
  //eliminarlo 

Future<void> eliminarGasto(int id) async{
  //borrarlo de la base de datos 
  await isar.writeTxn(() => isar.gastos.delete(id));

  //leerlo de la base de datos 

  await leerGastos();


  }





}