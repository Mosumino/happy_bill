import 'package:flutter/material.dart';
import 'package:happy_bill/database/gasto_database.dart';
import 'package:happy_bill/helper_functions/helper_functions.dart';
import 'package:happy_bill/models/gasto.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void abrirNuevoGasto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nuevo gasto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //input del nombre del gasto
            TextField(
              controller: controladorNombre,
              decoration: const InputDecoration(hintText: "Nombre"),
            ),

            //input del valor
            TextField(
              controller: controladorValor,
              decoration: const InputDecoration(hintText: "Valor"),
            ),
          ],
        ),
        actions: [
          //cancelar
          _botonCancelar(),

          //guardar
          _botonGuardar(),
        ],
      ),
    );
  }

  //controladores de texto
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //boton flotante en el centro para tratar de emular mejor el mockup
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Para evitar que el boton quede muy abajo
        child: FloatingActionButton(
          onPressed: abrirNuevoGasto,
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  //cancelar 
  Widget _botonCancelar() {
    return MaterialButton(
      onPressed: () {
        //cerrar
        Navigator.pop(context);

        //restablecer el estado de los controladores
        controladorNombre.clear();
        controladorValor.clear();
      },
      child: const Text("Cancelar"),
    );
  }

  //guardar
  Widget _botonGuardar() {
    return MaterialButton(
      onPressed: () async{
        //solo guarda si hay algo en el textfield
        if (controladorNombre.text.isNotEmpty && controladorValor.text.isNotEmpty) {
          //cerrar
          Navigator.pop(context);

          //crear nuevo gasto
          Gasto nuevoGasto = Gasto(
            nombre: controladorNombre.text,
            valor: convertirStringaDouble(controladorValor.text),
            fecha: DateTime.now(),
          );
          
          //guardarlo en la base de datos

          await context.read<GastoDatabase>().crearGastoNuevo(nuevoGasto);

          //restablecer controladores
          controladorNombre.clear();
          controladorValor.clear();
        }
      },
      child: Text("Guardar"),
    );
  }
}
