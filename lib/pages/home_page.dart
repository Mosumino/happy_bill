import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_bill/Componentes/Titulo_Lista.dart';
import 'package:happy_bill/database/gasto_database.dart';
import 'package:happy_bill/helper_functions/helper_functions.dart';
import 'package:happy_bill/main.dart';
import 'package:happy_bill/models/gasto.dart';
import 'package:happy_bill/pages/estadisticas.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var listaWidgets = [
    MyApp(),
    Estadisticas()
  ];

  int indice = 0;


  void abrirNuevoGasto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuevo gasto", style: TextStyle(fontWeight: FontWeight.bold)),
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

  // Abrir editar gasto
  void abrirEditarGasto(Gasto gasto) {
    String nombreExistente = gasto.nombre;
    String valorExistente = gasto.valor.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar gasto", style: TextStyle(fontWeight: FontWeight.bold),),
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

  // Abrir borrar gasto
  void abrirBorrarGasto(Gasto gasto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Borrar gasto?", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          //cancelar
          _botonCancelar(),

          //borrar
          _botonBorrar(gasto.id),
        ],
      ),
    );
  }

  // Controladores de texto
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorValor = TextEditingController();

  double calcularBalanceTotal(List<Gasto> gastos) {
    return gastos.fold(0, (sum, item) => sum + item.valor);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GastoDatabase>(
      builder: (context, value, child) {
        // Ordenar los gastos por fecha en orden descendente (gastos más recientes primero)
        List<Gasto> gastosOrdenados = List.from(value.todoslosgastos)
          ..sort((a, b) => b.fecha.compareTo(a.fecha));

        double balanceTotal = calcularBalanceTotal(gastosOrdenados);
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
          
            },
            backgroundColor: Colors.grey[300],
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: "Inicio",
                ),
                BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.graph_circle),
                label: "Estadisticas",
                )
            ],
            ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: abrirNuevoGasto,
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Container(
  margin: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 8.0),
  padding: const EdgeInsets.all(16.0),
  height: MediaQuery.of(context).size.height / 4,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [Colors.blue, Color.fromARGB(255, 56, 133, 196), Color.fromARGB(255, 117, 173, 219)], // Puedes ajustar los colores aquí
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Center(
    child: Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        'Balance Total',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 25,),
      Text(
        '\$${balanceTotal.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),
  ),
),

const SizedBox(height: 10),
const Padding(
  padding: EdgeInsets.fromLTRB(16.0, 5.0, 10.0, 8.0), // Ajusta estos valores según sea necesario
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      "Transacciones",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
),
              Expanded(
                child: ListView.builder(
                  itemCount: gastosOrdenados.length,
                  itemBuilder: (context, index) {
                    Gasto individualExpense = gastosOrdenados[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          individualExpense.nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          formatAmount(individualExpense.valor),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () => abrirEditarGasto(individualExpense),
                        onLongPress: () => abrirBorrarGasto(individualExpense),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // cancelar
Widget _botonCancelar() {
  return MaterialButton(
    onPressed: () {
      // cerrar
      Navigator.pop(context);

      // restablecer el estado de los controladores
      controladorNombre.clear();
      controladorValor.clear();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.grey, // Fondo rojo
        borderRadius: BorderRadius.circular(20.0), // Bordes circulares
      ),
      child: const Text(
        "Cancelar",
        style: TextStyle(
          color: Colors.white, // Texto blanco
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
  // guardar
Widget _botonGuardar() {
  return MaterialButton(
    onPressed: () async {
      // solo guarda si hay algo en el textfield
      if (controladorNombre.text.isNotEmpty && controladorValor.text.isNotEmpty) {
        // cerrar
        Navigator.pop(context);

        // crear nuevo gasto
        Gasto nuevoGasto = Gasto(
          nombre: controladorNombre.text,
          valor: convertirStringaDouble(controladorValor.text),
          fecha: DateTime.now(),
        );

        // guardarlo en la base de datos
        await context.read<GastoDatabase>().crearGastoNuevo(nuevoGasto);

        // restablecer controladores
        controladorNombre.clear();
        controladorValor.clear();
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: const Text(
        "Guardar",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

  // Guardar -> Edicion gasto existente
Widget _EditarGastoExistente(Gasto gasto) {
  return MaterialButton(
    onPressed: () async {
      // Guardar si el campo esta lleno
      if (controladorNombre.text.isNotEmpty || controladorValor.text.isNotEmpty) {
        Navigator.pop(context);
        // Crear un nuevo gasto
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

        // Guardarlo en DB
        await context
            .read<GastoDatabase>()
            .actualizarGasto(idActual, gastoActualizado);
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.blue, // Fondo azul
        borderRadius: BorderRadius.circular(20.0), // Bordes circulares
      ),
      child: const Text(
        "Guardar",
        style: TextStyle(
          color: Colors.white, // Texto blanco
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}


Widget _botonBorrar(int id) {
  return MaterialButton(
    onPressed: () async {
      Navigator.pop(context);

      await context.read<GastoDatabase>().eliminarGasto(id);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.red, // Fondo rojo
        borderRadius: BorderRadius.circular(20.0), // Bordes circulares
      ),
      child: const Text(
        "Borrar",
        style: TextStyle(
          color: Colors.white, // Texto blanco
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

}
