import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/routes/routes.dart';
import 'package:vertice_contadores/src/pages/login_page.dart';
import 'package:vertice_contadores/src/preferencias_usuario/preferencias_usuario.dart';

void main() async{
  

  runApp(MyApp());
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Vertice Contadores',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginPage()
        );
      },
      
    );
  }
}

