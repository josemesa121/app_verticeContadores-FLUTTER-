import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  String _email = '';

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
          Container(padding: EdgeInsets.only(bottom: 30.0)),
          Image.asset('assets/logo2.png', height: 60.0),
          Container(padding: EdgeInsets.only(bottom: 50.0)),
          Text('Reestablecer Contraseña', textAlign: TextAlign.center, style: TextStyle(
            color: Colors.blue, 
            fontSize: 25.0, 
            fontWeight: FontWeight.bold, 
            )
          ),
          Container(padding: EdgeInsets.only(bottom: 10.0)),
          _card(),
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
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Column(children: <Widget>[
        _crearInputEmail(),
        Container(padding: EdgeInsets.only(bottom: 20.0)),
        RaisedButton(
          onPressed: () {
            _recoverPassword();
          },
          color: Colors.lightBlueAccent,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 90.0),
          child: Text('ENVIAR', style: TextStyle(fontSize: 17, color: Colors.white))
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

  _recoverPassword() async{
    Map info = await dataProvider.recover_password(_email);
    if(info['ok']){
    
      showToast(context, info['msg']);

    }else{
      showToast(context, info['msg']);
    }
  }
}