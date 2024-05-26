import 'package:flutter/material.dart';
import 'package:happy_bill/Componentes/Titulo_Lista.dart';
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
        title: const Text("Nuevo gasto"),
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

//Abrir editar gasto
  void abrirEditarGasto(Gasto gasto) {
    String nombreExistente = gasto.nombre;
    String valorExistente = gasto.valor.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar gasto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //input del nombre del gasto
            TextField(
              controller: controladorNombre,
              decoration: InputDecoration(hintText: nombreExistente),
            ),

            //input del valor
            TextField(
              controller: controladorValor,
              decoration: InputDecoration(hintText: valorExistente),
            ),
          ],
        ),
        actions: [
          //cancelar
          _botonCancelar(),

          //guardar
          _EditarGastoExistente(gasto),
        ],
      ),
    );
  }

//Abrir borrar gasto
  void abrirBorrarGasto(Gasto gasto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Borrar gasto?"),
        actions: [
          //cancelar
          _botonCancelar(),

          //borrar
          _botonBorrar(gasto.id),
        ],
      ),
    );
  }

  //controladores de texto
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GastoDatabase>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: abrirNuevoGasto,
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.todoslosgastos.length,
          itemBuilder: (context, index) {
            Gasto individualExpense = value.todoslosgastos[index];

            return TituloLista(
              title: individualExpense.nombre,
              trailing: formatAmount(individualExpense.valor),
              onEditPressed: (context) => abrirEditarGasto(individualExpense),
              onDeletePressed: (context) => abrirBorrarGasto(individualExpense),
            );
          },
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
      onPressed: () async {
        //solo guarda si hay algo en el textfield
        if (controladorNombre.text.isNotEmpty &&
            controladorValor.text.isNotEmpty) {
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
      child: const Text("Guardar"),
    );
  }

  //Guardar -> Edicion gasto existente
  Widget _EditarGastoExistente(Gasto gasto) {
    return MaterialButton(
      onPressed: () async {
        // Guardar si el campo esta lleno
        if (controladorNombre.text.isNotEmpty ||
            controladorValor.text.isNotEmpty) {
          Navigator.pop(context);
          //Crear un nuevo gasto
          Gasto gastoActualizado = Gasto(
            nombre: controladorNombre.text.isNotEmpty
                ? controladorNombre.text
                : gasto.nombre,
            valor: controladorValor.text.isNotEmpty
                ? convertirStringaDouble(controladorValor.text)
                : gasto.valor,
            fecha: DateTime.now(),
          );

          // Id anterior
          int idActual = gasto.id;

          //Guardarlo en DB
          await context
              .read<GastoDatabase>()
              .actualizarGasto(idActual, gastoActualizado);
        }
      },
      child: const Text("Guardar"),
    );
  }

  //Boton Borrar
  Widget _botonBorrar(int id) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);

        await context.read<GastoDatabase>().eliminarGasto(id);
      },
      child: const Text("Borrar"),
    );
  }
}
