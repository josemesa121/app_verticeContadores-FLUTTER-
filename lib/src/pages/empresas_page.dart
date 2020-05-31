import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/pages/components/components.dart';
import 'package:vertice_contadores/src/pages/manage_empresa_page.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';

class EmpresasPage extends StatefulWidget {
  @override
  _EmpresasPageState createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {

  List _list = new List();

  @override
  void initState() {
    super.initState();

    getEmpresas();
  }

  getEmpresas() async{
    Map info = await dataProvider.getEmpresas();

    if(info['ok']){
      _list = info['data'];
    }

    setState(() {});
  }


  _deleteEmpresa(id) async{
   
    Map info = await dataProvider.deleteEmpresa(id);

    if(info['ok']){
      getEmpresas();
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      drawer: drawer(context),
      body: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[

            SizedBox(height: 5.0),

            Expanded(child: crearLista()),

            crearFooterBottom(),
            

          ],
        )
        
      )
    );
  }

  crearLista(){
    return ListView.builder(
      itemCount: _list.length + 1,
      itemBuilder: (BuildContext context, int index){

        // HEADER LIST
        if (index == 0) { 
          return Container(
            child: Column( 
              children: <Widget>[ 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Empresa', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text('Nit', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text(''),
                  ],
                ),

                Divider(thickness: 1.0, color: Colors.black),
              ]
            )
          );
        }
        index -= 1;

        // BODY HEADER
        var row = Column(
          children: <Widget>[
            GestureDetector(
              onTap: ()=> {
                Navigator.pushNamed(context, 'empresa_detalles', arguments: _list[index])
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      child: Text(_list[index]['nombre'])
                    ),
                    Container(
                      width: 75.0,
                      child: Text(_list[index]['nit']),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue[900],
                            onPressed: () {

                              Navigator.pushNamed(context, 'manage_empresa', arguments: _list[index]);

                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_forever),
                            color: Colors.red,
                            onPressed: () {
                              showAlertDialog(context, _list[index]['id']);
                            },
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        );
        return row;
        
      }, 
    );
  }

  crearFooterBottom(){
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
      width: 150.0,
      height: 45.0,
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.blue[900],
        borderSide: BorderSide(color: Colors.blue[900]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.work, size: 17.0, color: Colors.blue),
            Text("Nueva Empresa", style: TextStyle(color: Colors.blue)),
          ]
        ),
        onPressed: (){
          Navigator.pushNamed(context, 'manage_empresa');
        },
      ),
      
    );
  }

  showAlertDialog(BuildContext context, id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Si"),
      onPressed: () {
        _deleteEmpresa(id);
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar Empresa"),
      content: Text("¿Estas seguro?"),
      actions: [
        cancelButton,
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