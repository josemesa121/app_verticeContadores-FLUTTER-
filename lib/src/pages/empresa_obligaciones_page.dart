import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/pages/components/components.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';

class EmpresaObligacionesPage extends StatefulWidget {
  @override
  _EmpresaObligacionesPageState createState() => _EmpresaObligacionesPageState();
}

class _EmpresaObligacionesPageState extends State<EmpresaObligacionesPage> {
  
  List _list = new List();
  bool _loadData = false;


  String _nota = '';
  final _notaController = TextEditingController();

  Map _paramData;

  Map _empresa = {
    'id' : null,
    'nombre': '',
    'nit': ''
  };
  bool _loadEmpresa = false;

  Map _obligacion = {
    'id': null,
    'nombre': ''
  };
  bool _loadObligacion = false;




  getEmpresa(id) async{
    Map info = await dataProvider.getEmpresa(id);

    if(info['ok']){
      _empresa = info['data'];
      _loadEmpresa = true;
    }

    setState(() {});
  }

  getObligacion(id) async{
    Map info = await dataProvider.getObligacion(id);

    if(info['ok']){
      _obligacion = info['data'];
      _loadObligacion = true;
    }

    setState(() {});
  }

  getEmpresaObligaciones(empresaId, obligacionId) async{
    Map info = await dataProvider.getEmpresaObligaciones(empresaId, obligacionId);

    if(info['ok']){
      _list = info['data'];
      _loadData = true;
    }

    setState(() {});
  }


  _updateEmpresaObligacionNota(id) async{
   
    Map info = await dataProvider.updateEmpresaObligacionNota(
      id,
      _nota
    );

    if(info['ok']){
      getEmpresaObligaciones(_empresa['id'], _obligacion['id']);
      Navigator.of(context).pop();
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }

  _updateEmpresaObligacionStatus(id, status) async{
    int sendStatus;

    if(status){
      sendStatus = 1;
    }else{
      sendStatus = 0;
    }

   
    Map info = await dataProvider.updateEmpresaObligacionStatus(
      id,
      sendStatus
    );

    if(info['ok']){
      getEmpresaObligaciones(_empresa['id'], _obligacion['id']);
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }


  @override
  Widget build(BuildContext context) {

    _paramData = ModalRoute.of(context).settings.arguments as Map;
    
    
    if(_loadEmpresa == false){
      getEmpresa(_paramData['empresaId']);
    }
    if(_loadObligacion == false){
      getObligacion(_paramData['obligacionId']);
    }
    if(_loadData == false){
      getEmpresaObligaciones(_paramData['empresaId'], _paramData['obligacionId']);
    }

    return Scaffold(
      appBar: appBar(context),
      drawer: drawer(context),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[

            Expanded(
              child: crearLista()
            ),

            crearFooterBottom(),

          ],
        )
        
      )
    );
  }




  crearLista(){
    var size = MediaQuery.of(context).size;
    
    var headerList = Column(
      children: <Widget>[
        SizedBox(height: 5.0),
        Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(_empresa['nombre'], style: TextStyle(fontSize: 25.0, color: Colors.blue, fontWeight: FontWeight.bold) ),
          )
        ),

        Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text('Nit: ${_empresa['nit']}', style: TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.bold)),
          )
        ),
        SizedBox(height: 15.0),
      ],
    );

    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index){
        

        var fecha = _list[index]['fecha'].split('T');
        fecha = fecha[0];

        // BODY HEADER
        var row = Column(
          children: <Widget>[
            (index==0)? headerList: SizedBox(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: size.width * .30,
                    child: Text(_obligacion['nombre'])
                  ),
                  Container(
                    width: size.width * .20,
                    child: Text(fecha),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        (_list[index]['status']==0) ? Icon(Icons.access_time, color: Colors.red)
                        : Icon(Icons.check, color: Colors.blue[900]),

                        IconButton(
                          icon: Icon(Icons.mode_comment),
                          color: Colors.blue,
                          onPressed: () {

                            setState(() {
                              _nota = '';
                              _notaController.text = '';

                              _notaController.text = _list[index]['nota'];
                              _nota = _list[index]['nota'];
                            });
                            showAlertDialog(context, _list[index]['id']);

                          },
                        ),
                        Switch(
                          value: (_list[index]['status']==1)? true : false,
                          onChanged: (value){
                            _updateEmpresaObligacionStatus(_list[index]['id'], value);
                          },
                          activeTrackColor: Colors.grey[350],
                          activeColor: Colors.blue[900],
                        )
                        
                        
                      ],
                    )
                  ),
                ],
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
      width: 105.0,
      height: 35.0,
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.blue[900],
        borderSide: BorderSide(color: Colors.blue[900]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.file_download, size: 14.0, color: Colors.blue[900],),
            Text("Exportar", style: TextStyle(fontSize: 12.0, color: Colors.blue[900])),
          ]
        ),
        onPressed: (){
          
        },
      ),
      
    );
  }




  showAlertDialog(BuildContext context, id) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[ 

            Text('Nota', style: TextStyle(color: Colors.blueGrey)),

            _crearInputNota(),

            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
              padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
              width: 105.0,
              height: 35.0,
              child: OutlineButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                color: Colors.blue[900],
                borderSide: BorderSide(color: Colors.blue[900]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Icon(Icons.add_comment, size: 14.0, color: Colors.blue[900],),
                    Text("Guardar", style: TextStyle(fontSize: 12.0, color: Colors.blue[900])),

                  ]
                ),
                onPressed: (){
                  _updateEmpresaObligacionNota(id);
                },
              ),
              
            )

          ],
        ),
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


  Widget _crearInputNota() {
    return TextField(
      controller: _notaController,
      maxLines: 7,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (valor){
        setState(() => _nota = valor);
      },
    );
  }



}