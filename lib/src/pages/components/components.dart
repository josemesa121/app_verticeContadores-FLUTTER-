import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:vertice_contadores/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';

final _prefs = new PreferenciasUsuario();

log_out(context){
  Map info = dataProvider.log_out();
    
  if(info['ok']){
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}


Widget appBar(context){
  return AppBar(
    title: Image.asset('assets/logo2.png', fit: BoxFit.contain, height: 40.0),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    iconTheme: new IconThemeData(color: Colors.blue),
    actions: <Widget>[
      // action button
      IconButton(
        padding: EdgeInsets.only(right: 30.0),
        icon: Icon(Icons.arrow_back, size: 30.0),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ]
  );
}

Widget drawer(context){
  Map user = json.decode(_prefs.user);

  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/fondo.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: 45.0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: (){
                  Navigator.pushNamed(context, 'home');
                },
              ),
              ListTile(
                leading: Icon(Icons.card_travel),
                title: Text('Empresas'),
                onTap: (){
                  Navigator.pushNamed(context, 'empresas');
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Cambiar Clave'),
                onTap: (){
                  Navigator.pushNamed(context, 'cambio_clave');
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Salir'),
                onTap: (){

                  
                  log_out(context);
                  
                },
              ),
            ],
          )),
          Container(
            padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
            child: Text(user['email'], style: TextStyle(fontWeight: FontWeight.bold ))
          )

        ],
      )
    ),
  );
}