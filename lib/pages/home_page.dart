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
  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurarnos de que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GastoDatabase>(context, listen: false).leerGastos();
    });
  }

  void abrirNuevoGasto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nuevo gasto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input del nombre del gasto
            TextField(
              controller: controladorNombre,
              decoration: const InputDecoration(hintText: "Nombre"),
            ),
            // Input del valor
            TextField(
              controller: controladorValor,
              decoration: const InputDecoration(hintText: "Valor"),
            ),
          ],
        ),
        actions: [
          // Cancelar
          _botonCancelar(),
          // Guardar
          _botonGuardar(),
        ],
      ),
    );
  }

  // Controladores de texto
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GastoDatabase>(
      builder: (context, value, child) => Scaffold(
        // Botón flotante en el centro para tratar de emular mejor el mockup
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0), // Para evitar que el botón quede muy abajo
          child: FloatingActionButton(
            onPressed: abrirNuevoGasto,
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
        body: ListView.builder(
          itemCount: value.todoslosgastos.length,
          itemBuilder: (context, index) {
            // Conseguir el gasto individual
            Gasto gastoIndividual = value.todoslosgastos[index];
            return ListTile(
              title: Text(gastoIndividual.nombre),
              trailing: Text(gastoIndividual.valor.toString()),
            );
          },
        ),
      ),
    );
  }

  // Cancelar 
  Widget _botonCancelar() {
    return MaterialButton(
      onPressed: () {
        // Cerrar
        Navigator.pop(context);
        // Restablecer el estado de los controladores
        controladorNombre.clear();
        controladorValor.clear();
      },
      child: const Text("Cancelar"),
    );
  }

  // Guardar
  Widget _botonGuardar() {
    return MaterialButton(
      onPressed: () async {
        // Solo guarda si hay algo en el TextField
        if (controladorNombre.text.isNotEmpty && controladorValor.text.isNotEmpty) {
          // Cerrar
          Navigator.pop(context);
          // Crear nuevo gasto
          Gasto nuevoGasto = Gasto(
            nombre: controladorNombre.text,
            valor: convertirStringaDouble(controladorValor.text),
            fecha: DateTime.now(),
          );
          // Guardarlo en la base de datos
          await context.read<GastoDatabase>().crearGastoNuevo(nuevoGasto);
          // Restablecer controladores
          controladorNombre.clear();
          controladorValor.clear();
        }
      },
      child: const Text("Guardar"),
    );
  }
}
