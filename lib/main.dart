import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:happy_bill/database/gasto_database.dart';
import 'package:happy_bill/pages/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GastoDatabase.Inicializar();
  //iniciando la base de datos

  runApp(ChangeNotifierProvider(create:(context)=>GastoDatabase(),
  child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}