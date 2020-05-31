import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';

final _prefs = new PreferenciasUsuario();

class CambioClavePage extends StatefulWidget {
  @override
  _CambioClavePageState createState() => _CambioClavePageState();
}

class _CambioClavePageState extends State<CambioClavePage> {

  Map user = json.decode(_prefs.user);

  String _claveActual = '';
  String _claveNueva = '';

  _updatePassword() async{
    Map info = await dataProvider.updatePassword(_claveActual, {'id': user['id'], 'password': _claveNueva});
    if(info['ok']){
      Navigator.pushReplacementNamed(context, 'home');
      showToast(context, info['msg']);
    }else{
      Navigator.of(context).pop();
      showToast(context, info['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
      child: ListView(
        padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 60.0),
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue[900]),
            onPressed: () => Navigator.of(context).pop(),
            alignment: Alignment(0.85, 1.0),
            iconSize: 30.0,
          ),
          SizedBox(height: 30.0),
          Image.asset('assets/logo2.png', height: 60.0),
          SizedBox(height: 50.0),
          Text('Cambio De Contraseña', textAlign: TextAlign.center, style: TextStyle(
            color: Colors.blue, 
            fontSize: 25.0, 
            fontWeight: FontWeight.bold, 
            )
          ),
          SizedBox(height: 10.0),
          _card(),
        ],
      ),
      )
    );
  }



  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("ACTUALIZAR", style: TextStyle(color: Colors.white)),
      color: Colors.lightBlueAccent,

      onPressed: () {
        _updatePassword();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("NO", style: TextStyle(color: Colors.white)),
      color: Colors.grey[300],
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.warning, color: Colors.red[200], size: 100.0),
          Text("Estas Seguro", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.grey[500])),
          Text("De Cambiar La Contraseña", style: TextStyle(color: Colors.grey[500])),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              cancelButton,
              okButton,
            ]
          )
        ],
      ),
      
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }





  Widget _card() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
      padding: EdgeInsets.all(20.0),
      child: Column(children: <Widget>[
        _crearInputClaveActual(),
        _crearInputClaveNueva(),
        Container(padding: EdgeInsets.only(bottom: 20.0)),
        RaisedButton(
          onPressed: () {
            showAlertDialog(context);
          },
          color: Colors.lightBlueAccent,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 55.0),
          child: Text('ACTUALIZAR', style: TextStyle(fontSize: 17, color: Colors.white))
        ),
      ],
      )
    ),
    );
  }


  Widget _crearInputClaveActual(){
    return TextField(
      obscureText: true,
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Clave Actual',
      ),
      onChanged: (valor){
        setState(() => _claveActual = valor);
      },
    );
  }

  Widget _crearInputClaveNueva() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Nueva Clave',
      ),
      onChanged: (valor){
        setState(() => _claveNueva = valor);
      },
    );
  }



}