import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _nombre = '';
  String _apellidos = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  _register() async{
   
    Map info = await dataProvider.register(_nombre, _apellidos, _email, _password, _confirmPassword);
    if(info['ok']){
      _clearForm();
      Navigator.pushNamed(context, '/');
      showAlertDialog(context);
    }else{
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
        padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 80.0),
        children: <Widget>[
          Image.asset('assets/logo1.png', height: 120.0),
          Image.asset('assets/logo2.png', height: 60.0),
          Container(padding: EdgeInsets.only(bottom: 20.0)),
          Text('Registrate', textAlign: TextAlign.center, style: TextStyle(
            color: Colors.blue, 
            fontSize: 25.0, 
            fontWeight: FontWeight.bold, 
            )
          ),
          Container(padding: EdgeInsets.only(bottom: 10.0)),
          _card(),
          FlatButton(
           child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: '¿Ya tienes un usuario?', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 13.0)),
                TextSpan(text: ' Iniciar Sesión', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/');
          },
          )
        ],
      ),
      )
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
        _crearInputEmail(),
        _crearInputNombre(),
        _crearInputApellido(),
        _crearInputPassword(),
        _crearInputConfirmPassword(),
        Container(padding: EdgeInsets.only(bottom: 20.0)),
        RaisedButton(
          onPressed: () {
            _register();
          },
          color: Colors.lightBlueAccent,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 55.0),
          child: Text('REGISTRAR', style: TextStyle(fontSize: 17, color: Colors.white))
        ),
      ],
      )
    ),
    );
  }


  Widget _crearInputEmail(){
    return TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Correo',
        suffixIcon: Icon(Icons.email),
      ),
      onChanged: (valor){
        setState(() => _email = valor);
      },
    );
  }

  Widget _crearInputNombre() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
        suffixIcon: Icon(Icons.person_outline),
      ),
      onChanged: (valor){
        setState(() => _nombre = valor);
      },
    );
  }

  Widget _crearInputApellido() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Apellidos',
      ),
      onChanged: (valor){
        setState(() => _apellidos = valor);
      },
    );
  }

  Widget _crearInputPassword() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        suffixIcon: Icon(Icons.lock_outline),
      ),
      onChanged: (valor){
        setState(() => _password = valor);
      },
    );
  }

  Widget _crearInputConfirmPassword() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Repetir contraseña',
      ),
      onChanged: (valor){
        setState(() => _confirmPassword = valor);
      },
    );
  }

  void _clearForm(){
    _nombre='';
    _apellidos='';
    _password='';
    _email='';
    _confirmPassword='';
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Registro Completado"),
      content: Text("Ahora puedes iniciar sesión."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
