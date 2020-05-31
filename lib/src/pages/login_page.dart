import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = '';
  String _password = '';

  _login() async{
    Map info = await dataProvider.login(_email, _password);
    if(info['ok']){
      Navigator.pushReplacementNamed(context, 'home');
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
          _card(),
          FlatButton(
           child: Text('¿Olvidaste tu contraseña?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
            onPressed: (){
              Navigator.pushNamed(context, 'forgot_password');
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
        _crearInputPassword(),
        Container(padding: EdgeInsets.only(bottom: 20.0)),
        RaisedButton(
          onPressed: () {
            _login();
          },
          color: Colors.lightBlueAccent,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 55.0),
          child: Text('INICIAR SESION', style: TextStyle(fontSize: 17, color: Colors.white))
        ),
        FlatButton(
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: '¿Todavia no tienes cuenta?', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 13.0)),
                TextSpan(text: ' Registrate', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'register');
          },
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
        labelText: 'Usuario',
        suffixIcon: Icon(Icons.perm_identity),
      ),
      onChanged: (valor){
        setState(() => _email = valor);
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
}