import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/pages/components/components.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';
import 'package:vertice_contadores/utils/utils.dart';


class ManageEmpresaPage extends StatefulWidget {
  // final int id;
  // ManageEmpresaPage(this.id);

  @override
  _ManageEmpresaPageState createState() => _ManageEmpresaPageState();
}

class _ManageEmpresaPageState extends State<ManageEmpresaPage> {

  @override
  void initState() {
    super.initState();
    
  }

  bool _loadData = false;
  int _id = null;

  int _userId = null;

  // String _nombre = '';
  final _nombreController = TextEditingController();
  String _nombre = '';

  int _tipo = 1;

  final _nitController = TextEditingController();
  String _nit = '';
  final _nitDigitoController = TextEditingController();
  String _nitDigito = '';
  final _contactoController = TextEditingController();
  String _contacto = '';
  final _direccionController = TextEditingController();
  String _direccion = '';
  final _emailController = TextEditingController();
  String _email = '';
  final _telefonoController = TextEditingController();
  String _telefono = '';
  final _cedulaController = TextEditingController();
  String _cedula = '';
  final _clave_dianController = TextEditingController();
  String _clave_dian = '';
  final _clave_firma_dianController = TextEditingController();
  String _clave_firma_dian = '';
  final _place_iycController = TextEditingController();
  String _place_iyc = '';
  final _placa_reteicaController = TextEditingController();
  String _placa_reteica = '';
  final _datos_contabilidadController = TextEditingController();
  String _datos_contabilidad = '';


  getEmpresa(id) async{
    Map info = await dataProvider.getEmpresa(id);

    if(info['ok']){
      _userId = info['data']['userId'];

      _nombreController.text = info['data']['nombre'];
      _nombre = info['data']['nombre'];

      _tipo = info['data']['tipo'];

      _nitController.text = info['data']['nit'];
      _nit = info['data']['nit'];
      _nitDigitoController.text = info['data']['nitDigito'];
      _nitDigito = info['data']['nitDigito'];
      _contactoController.text = info['data']['contacto'];
      _contacto = info['data']['contacto'];
      _direccionController.text = info['data']['direccion'];
      _direccion = info['data']['direccion'];
      _emailController.text = info['data']['email'];
      _email = info['data']['email'];
      _telefonoController.text = info['data']['telefono'];
      _telefono = info['data']['telefono'];
      _cedulaController.text = info['data']['cedula'];
      _cedula = info['data']['cedula'];
      _clave_dianController.text = info['data']['clave_dian'];
      _clave_dian = info['data']['clave_dian'];
      _clave_firma_dianController.text = info['data']['clave_firma_dian'];
      _clave_firma_dian = info['data']['clave_firma_dian'];
      _place_iycController.text = info['data']['place_iyc'];
      _place_iyc = info['data']['place_iyc'];
      _placa_reteicaController.text = info['data']['placa_reteica'];
      _placa_reteica = info['data']['placa_reteica'];
      _datos_contabilidadController.text = info['data']['datos_contabilidad'];
      _datos_contabilidad = info['data']['datos_contabilidad'];

    }

    _loadData = true;
    setState(() {});
  }


  _registrarEmpresa() async{
   
    Map info = await dataProvider.registrarEmpresa(
      _nombre,
      _tipo,
      _nit,
      _nitDigito,
      _contacto,
      _direccion,
      _email,
      _telefono,
      _cedula,
      _clave_dian,
      _clave_firma_dian,
      _place_iyc,
      _placa_reteica,
      _datos_contabilidad
    );

    if(info['ok']){
      Navigator.pushNamed(context, 'empresas');
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }


  _updateEmpresa() async{
   
    Map info = await dataProvider.updateEmpresa(
      _userId,
      _id,
      _nombre,
      _tipo,
      _nit,
      _nitDigito,
      _contacto,
      _direccion,
      _email,
      _telefono,
      _cedula,
      _clave_dian,
      _clave_firma_dian,
      _place_iyc,
      _placa_reteica,
      _datos_contabilidad
    );

    if(info['ok']){
      Navigator.pushNamed(context, 'empresas');
      showToast(context, info['msg']);
    }else{
      showToast(context, info['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final empresa = ModalRoute.of(context).settings.arguments as Map;

    if(empresa !=null && !_loadData){
      _id = empresa['id'];
      getEmpresa(_id);
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
              child: ListView(
                children: _crearInputList()
              ),
            ),

            crearFooterBottom(),

          ],
        )
        
      )
    );
  }

  _crearInputList(){
    return <Widget>[

      SizedBox(height: 5.0),
      Container(
        child: Align(
          alignment: Alignment.topLeft,
          child: Text('NUEVA', style: TextStyle(fontSize: 25.0, color: Colors.blue[900], fontWeight: FontWeight.bold) ),
        )
      ),

      Container(
        margin: EdgeInsets.only(left: 40.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text('Empresa', style: TextStyle(fontSize: 14.0, color: Colors.blue[900], fontWeight: FontWeight.bold)),
        )
      ),
      SizedBox(height: 5.0),

      crearInput(
        title: 'Nombre:',
        onChanged: (newValue) => setState(() => _nombre = newValue),
        myController: _nombreController
      ),

      SizedBox(height: 15.0),
      Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: RadioListTile(
                value: 1,
                groupValue: _tipo,
                onChanged: (newValue) => {
                  setState(() => _tipo = newValue)
                },
                title: Text('Persona Natural', style: TextStyle(fontSize: 11.0)),
              )
            ),

            Expanded(
              flex: 1,
              child: RadioListTile(
                value: 2,
                groupValue: _tipo,
                onChanged: (newValue) => {
                  setState(() => _tipo = newValue)
                },
                title: Text('Persona Juridica', style: TextStyle(fontSize: 11.0)),
              )
            )

          ],
        )
      ),
  
      crearInput(
        title: 'Nit:',
        onChanged: (newValue) => setState(() => _nit = newValue),
        myController: _nitController
      ),

      crearInput(
        title: 'Dígito de Verificación:',
        onChanged: (newValue) => setState(() => _nitDigito = newValue),
        myController: _nitDigitoController
      ),

      crearInput(
        title: 'Representante Legal:',
        onChanged: (newValue) => setState(() => _contacto = newValue),
        myController: _contactoController
      ),

      crearInput(
        title: 'Dirección:',
        onChanged: (newValue) => setState(() => _direccion = newValue),
        myController: _direccionController
      ),
      
      crearInput(
        title: 'Email:',
        onChanged: (newValue) => setState(() => _email = newValue),
        myController: _emailController,
        keyboardType: TextInputType.emailAddress, 
      ),

      crearInput(
        title: 'Teléfono:',
        onChanged: (newValue) => setState(() => _telefono = newValue),
        myController: _telefonoController
      ),

      crearInput(
        title: 'Cédula:',
        onChanged: (newValue) => setState(() => _cedula = newValue),
        myController: _cedulaController
      ),

      crearInput(
        title: 'Clave Ingreso DIAN:',
        onChanged: (newValue) => setState(() => _clave_dian = newValue),
        myController: _clave_dianController
      ),

      crearInput(
        title: 'Clave Firma DIAN:',
        onChanged: (newValue) => setState(() => _clave_firma_dian = newValue),
        myController: _clave_firma_dianController
      ),

      crearInput(
        title: 'Placa Industria U¿Y Comercio:',
        onChanged: (newValue) => setState(() => _place_iyc = newValue),
        myController: _place_iycController
      ),

      crearInput(
        title: 'Placa REITECA:',
        onChanged: (newValue) => setState(() => _placa_reteica = newValue),
        myController: _placa_reteicaController
      ),

      crearInput(
        title: 'Datos para Ingresa a Contabilidad:',
        onChanged: (newValue) => setState(() => _datos_contabilidad = newValue),
        myController: _datos_contabilidadController
      ),


    ];

  }
  
  
  Widget crearInput({String title, Function onChanged, myController, keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      controller: myController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: title,
      ),
      onChanged: onChanged,
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
            (_id==null)? Text("Crear Empresa", style: TextStyle(color: Colors.blue)):
            Text("Actualizar", style: TextStyle(color: Colors.blue)),
          ]
        ),
        onPressed: (){

          if(_id == null){
            _registrarEmpresa();
          }else{
            _updateEmpresa();
          }

        },
      ),
      
    );
  }
}