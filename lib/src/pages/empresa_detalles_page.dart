import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/pages/components/components.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';

class EmpresaDetallesPage extends StatefulWidget {


  EmpresaDetallesPage({Key key, this.url}) : super(key: key);

  final String url;
  @override
  _EmpresaDetallesPageState createState() => _EmpresaDetallesPageState();
}

class _EmpresaDetallesPageState extends State<EmpresaDetallesPage> {



  List _list = new List();

  List _listDocumentos = new List();
  bool _loadDocumentos = false;

  List _listObligacionesConfig = new List();
  bool _loadObligacionesConfig = false;

  int _anioSeleccionado;

  Map _empresa;

  List _anios = new List();
  bool _loadAnios = false;


  String _nota = '';
  final _notaController = TextEditingController();

  String state = "";




  final _contactoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _emailController = TextEditingController();
  final _clave_dianController = TextEditingController();
  final _clave_firma_dianController = TextEditingController();
  final _place_iycController = TextEditingController();
  final _placa_reteicaController = TextEditingController();
  final _datos_contabilidadController = TextEditingController();

  _asignarDatosEmpresa(){
    _contactoController.text = _empresa['contacto'];
    _direccionController.text = _empresa['direccion'];
    _emailController.text = _empresa['email'];
    _clave_dianController.text = _empresa['clave_dian'];
    _clave_firma_dianController.text = _empresa['clave_firma_dian'];
    _place_iycController.text = _empresa['place_iyc'];
    _placa_reteicaController.text = _empresa['placa_reteica'];
    _datos_contabilidadController.text = _empresa['datos_contabilidad'];
  }

  getObligacionesAnios() async{
    Map info = await dataProvider.getObligacionesAnios();

    if(info['ok']){
      _anios = info['data'];
      _loadAnios = true;
      if(_anios.length>0){
        _anioSeleccionado = _anios[_anios.length - 1]['id'];
        getEmpresaObligacionesByAnio();
        getEmpresaObligacionesConfig();
      }
    }
    

    setState(() {});
  }

  getEmpresaObligacionesByAnio() async{
    Map info = await dataProvider.getEmpresaObligacionesByAnio(_empresa['id'], _anioSeleccionado);

    if(info['ok']){
      _list = info['data'];
    }

    setState(() {});
  }

  getEmpresaDocumentos() async{
    Map info = await dataProvider.getEmpresaDocumentos(_empresa['id']);

    if(info['ok']){
      _listDocumentos = info['data'];
      _loadDocumentos = true;
    }
  
    setState(() {});
  }


  getEmpresaObligacionesConfig() async{
    Map info = await dataProvider.getEmpresaObligacionesConfig(_empresa['id'], _anios[_anios.length - 1]['id']);

    if(info['ok']){
      _listObligacionesConfig = info['data'];
      _loadObligacionesConfig = true;
    }
  
    setState(() {});
  }

  updateOblogacionConfig(obligacionId) async{

    Map info = await dataProvider.updateOblogacionConfig(_empresa['id'], obligacionId);

    if(info['ok']){
      getEmpresaObligacionesConfig();
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }

  deleteOblogacionConfig(obligacionId) async{

    Map info = await dataProvider.deleteOblogacionConfig(_empresa['id'], obligacionId);

    if(info['ok']){
      getEmpresaObligacionesConfig();
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {

    _empresa = ModalRoute.of(context).settings.arguments as Map;

    _asignarDatosEmpresa();

    if(_loadAnios == false){
      getObligacionesAnios();
    }
    if(_loadDocumentos == false){
      getEmpresaDocumentos();
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
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: <Widget>[

              Expanded(
                child:TabBarView(
                children: [
                  _contentCalendario(),
                  _contentDetalles(),
                  _contentDocumentos(),
                  _contentObligacionesConfig()
                ],
              )),

              TabBar(
                labelColor: Colors.blue[900],
                labelStyle: TextStyle(fontSize: 9.0),
                indicatorColor: Colors.blue[900],
                unselectedLabelColor: Colors.grey[500],
                tabs: [
                  Tab(icon: Icon(Icons.date_range), text: 'Calendario'),
                  Tab(icon: Icon(Icons.list), text: 'Detalles'),
                  Tab(icon: Icon(Icons.content_copy), text: 'Documentos'),
                  Tab(icon: Icon(Icons.add_to_photos), text: 'Obligaciones'),
                ],
              ),
            ],
          )
                
          ),

        ),
    );
  }



  Widget _headerEmpresa(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(_empresa['nombre'], style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold) ),
                  )
                ),

                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Nit: ${_empresa['nit']}', style: TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.bold)),
                  )
                ),
                SizedBox(height: 15.0),
              ]
            ),
          ),


          DropdownButton<int>(
            value: _anioSeleccionado,
            items: _anios.map((value) {
              return new DropdownMenuItem<int>(
                value: value['id'],
                child: new Text(value['anio']),
              );
            }).toList(),
            onChanged: (opt) {

              setState(() {
                _anioSeleccionado = opt;
              });
              getEmpresaObligacionesByAnio();
            },
          )
          
        ],
      ),

    );
  }


  Widget _contentCalendario () {

    return ListView.builder(
      itemCount: _list.length +1,
      itemBuilder: (BuildContext context, int index){

        if (index == 0) { 
          return _headerEmpresa();
        }
        index -= 1;

        var row = Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Container(
                    width: 290.0,
                    child: Text(_list[index]['nombre'])
                  ),
                  Container(
                    child: (_list[index]['pendiente']==0) ? Icon(Icons.access_time, color: Colors.red)
                    : Icon(Icons.check, color: Colors.blue[900]),
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



  Widget crearInput({String title, myController}) {
    return TextField(
      readOnly: true,
      controller: myController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _contentDetalles() {
    
    return ListView(
      children: <Widget>[

        SizedBox(height: 5.0),
        Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(_empresa['nombre'], style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold) ),
          )
        ),

        Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text('Nit: ${_empresa['nit']}', style: TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.bold)),
          )
        ),
        SizedBox(height: 15.0),


        crearInput(
          title: 'Contacto:',
          myController: _contactoController
        ),
        crearInput(
          title: 'Dirección:',
          myController: _direccionController
        ),
        crearInput(
          title: 'Email:',
          myController: _emailController
        ),
        crearInput(
          title: 'Clave Ingreso DIAN:',
          myController: _clave_dianController
        ),
        crearInput(
          title: 'Clave Firma DIAN:',
          myController: _clave_firma_dianController
        ),
        crearInput(
          title: 'Placa Industria Y Comercio:',
          myController: _place_iycController
        ),
        crearInput(
          title: 'Placa REITECA:',
          myController: _placa_reteicaController
        ),
        crearInput(
          title: 'Datos para Ingresa a Contabilidad:',
          myController: _datos_contabilidadController
        ),

      ],
    );
    
    
  }





  _uploadFile() async{
    File file = await FilePicker.getFile();

    Map info = await dataProvider.uploadFile(file.path, _empresa['id'], _nota);

    if(info['ok']){
      getEmpresaDocumentos();
      Navigator.of(context).pop();
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }


  _deleteFile(id) async{
   
    Map info = await dataProvider.deleteFile(id);

    if(info['ok']){
      getEmpresaDocumentos();
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }


  showAlertDialogDocumentos(BuildContext context) {
    _notaController.text='';
    _nota = '';

    Widget botonGuardar = Container(
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
          _uploadFile();
        },
      ),
      
    );

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

            TextField(
              controller: _notaController,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (newValue) => setState(() => _nota = newValue),
            ),

            botonGuardar,

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



  crearAdjuntarDocumentoBottom(context){
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
            Text("Adjuntar", style: TextStyle(fontSize: 12.0, color: Colors.blue[900])),
          ]
        ),
        onPressed: (){
          
          showAlertDialogDocumentos(context);
        },
      ),
      
    );
  }


  Widget _headerEmpresaDocumentos(){
    var size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: size.width * .56,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(_empresa['nombre'], style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold) ),
                      )
                    ),

                    Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Nit: ${_empresa['nit']}', style: TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.bold)),
                      )
                    ),
                    SizedBox(height: 15.0),
                  ]
                ),
              ),

              crearAdjuntarDocumentoBottom(context)
            
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('ID'),
              Container(
                width: size.width * .50,
                child: Text('Notas'),
              ),
              Text('Acción'),
            ]
          ),
          Divider(thickness: 1, color: Colors.black),
        ],
      )
      

    );
  }

  _contentDocumentos() {
    var size = MediaQuery.of(context).size;
    
    return ListView.builder(
      itemCount: _listDocumentos.length +1,
      itemBuilder: (BuildContext context, int index){

        if (index == 0) { 
          return _headerEmpresaDocumentos();
        }
        index -= 1;

        var row = Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Container(
                    child: Text('${_listDocumentos[index]['id']}')
                  ),
                  Container(
                    width: size.width * .40,
                    child: Text('${_listDocumentos[index]['nota']}')
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.file_download),
                          color: Colors.blue[900],
                          onPressed: () {
                            
                            // dataProvider.openFile();

                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red,
                          onPressed: () {
                            _deleteFile(_listDocumentos[index]['id']);
                          },
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
            Divider(),
          ],
        );
        return row;
      }
    );
        

  }











  _contentObligacionesConfig() {
    var size = MediaQuery.of(context).size;


      // int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
      // int _rowsPerPage1 = PaginatedDataTable.defaultRowsPerPage;
    
      // //Obtain the data to be displayed from the Derived DataTableSource
      // var dts = DTS(_listObligacionesConfig);
      // // dts.rowcount provides the actual data length, ForInstance, If we have 7 data stored in the DataTableSource Object, then we will get 12 as dts.rowCount
      // var tableItemsCount = dts.rowCount; 
      // // PaginatedDataTable.defaultRowsPerPage provides value as 10
      // var defaultRowsPerPage = PaginatedDataTable.defaultRowsPerPage;
      // // We are checking whether tablesItemCount is less than the defaultRowsPerPage which means we are actually checking the length of the data in DataTableSource with default PaginatedDataTable.defaultRowsPerPage i.e, 10
      // var isRowCountLessDefaultRowsPerPage = tableItemsCount < defaultRowsPerPage;

      // // Assigning rowsPerPage as 10 or acutal length of our data in stored in the DataTableSource Object
      //   _rowsPerPage = isRowCountLessDefaultRowsPerPage ? tableItemsCount : defaultRowsPerPage;
      //   return SingleChildScrollView(
      //       child: PaginatedDataTable(
      //         header: Text('header'),
      //         // comparing the actual data length with the PaginatedDataTable.defaultRowsPerPage and then assigning it to _rowPerPage1 variable which then set using the setsState()
      //         onRowsPerPageChanged: isRowCountLessDefaultRowsPerPage // The source of problem!
      //         ? null
      //         : (rowCount) {
      //           setState(() {
      //             _rowsPerPage1 = rowCount;
      //           });
      //         },
      //         columns: <DataColumn>[
      //           DataColumn(label: Text('Obligación')),
      //           DataColumn(label: Text('')),
      //         ],
      //         source: dts,
      //         //Set Value for rowsPerPage based on comparing the actual data length with the PaginatedDataTable.defaultRowsPerPage 
      //         rowsPerPage:
      //             isRowCountLessDefaultRowsPerPage ? _rowsPerPage : _rowsPerPage1,
      //       ),
      //     );
      

    
    return ListView.builder(
      itemCount: _listObligacionesConfig.length +1,
      itemBuilder: (BuildContext context, int index){

        if (index == 0) {
          return Column(
            children: <Widget>[
              SizedBox(height: 5.0),
              Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('${_empresa['nombre']}', style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold) ),
                )
              ),

              Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('${_empresa['nit']}', style: TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.bold)),
                )
              ),
              SizedBox(height: 15.0),
            ]
          );
        }
        index -= 1;

        var row = Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Container(
                    width: size.width * .55,
                    child: Text('${_listObligacionesConfig[index]['nombre']}')
                  ),
                  Container(
                    child: Switch(
                      value: (_listObligacionesConfig[index]['activo']==1)? true : false,
                      onChanged: (value){
                        if(_listObligacionesConfig[index]['activo']==1){
                          deleteOblogacionConfig(_listObligacionesConfig[index]['id']);
                        }else{
                          updateOblogacionConfig(_listObligacionesConfig[index]['id']);
                        }
                      },
                      activeTrackColor: Colors.grey[350],
                      activeColor: Colors.blue[900],
                    )
                  )
                ],
              ),
            ),
            Divider(),
          ],
        );
        return row;
      }
    );
        

  }




}


// class DTS extends DataTableSource {
//   List _listObligacionesConfig = new List();

//   DTS(List listObligacionesConfig){
//     _listObligacionesConfig = listObligacionesConfig;
//   }
//   @override
//   DataRow getRow(int index) {
//     print(_listObligacionesConfig);
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(
//           Text('${_listObligacionesConfig[index]['nombre']}')
//         ),
//         DataCell(
//           Text('name #$index')
//         ),
//       ],
//     );
//   }

//   @override
//   int get rowCount => _listObligacionesConfig.length; // Manipulate this to which ever value you wish

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get selectedRowCount => 0;
// }