import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/pages/components/components.dart';
import 'package:vertice_contadores/src/providers/data_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  List<Map<String, dynamic>> _list = new List();
  DateTime _fechaInicio;
  DateTime _fechaFin;

  // Variables para el export
  Map<String, dynamic> _fechasExport;
  List<String> _fechasArrayExport = new List();

  @override
  void initState() {
    super.initState();

    var now = new DateTime.now();
    int today = now.weekday;
    var dayNr = (today + 6) % 7;
    // FECHA INICIO Y FIN SEMANA ACTUAL
    _fechaInicio = now.subtract(new Duration(days:(dayNr)));
    _fechaFin = _fechaInicio.add(new Duration(days:6));


    getObligacionesRango(getDateString('complete', _fechaInicio), getDateString('complete', _fechaFin));
  }

  getDateString(type, date){
    String dateString = date.toString();
    List<String> arrayFecha = dateString.split(" ");

    String fecha = arrayFecha[0];
    if(type=='complete'){
      return fecha;
    }

    List<String> monthNames = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];

    List<String> arrayFecha2 = fecha.split("-");
      int monthNumber = int.parse(arrayFecha2[1]) - 1;

    if(type == 'calendar'){
      String fecha = '${arrayFecha2[2]} De ${monthNames[monthNumber]} Del ${arrayFecha2[0]}';
      return fecha;
    }

    if(type == 'calendarShort'){
      String fecha = '${arrayFecha2[2]}/${arrayFecha2[1]}/${arrayFecha2[0]}';
      return fecha;
    }
  }

  lastWeek(){
    _fechaFin = _fechaInicio.subtract(new Duration(days:1));
    _fechaInicio = _fechaInicio.subtract(new Duration(days:7));

    getObligacionesRango(getDateString('complete', _fechaInicio), getDateString('complete', _fechaFin));
  }

  nextWeek(){
    _fechaInicio = _fechaInicio.add(new Duration(days:7));
    _fechaFin = _fechaInicio.add(new Duration(days:6));

    getObligacionesRango(getDateString('complete', _fechaInicio), getDateString('complete', _fechaFin));
  }

  getObligacionesRango(String fechaInicio, String fechaFin) async{
    Map info = await dataProvider.getObligacionesRango(fechaInicio, fechaFin);
    List<Map<String, dynamic>> listTempDate = [];

    _fechasExport = info['data'];

    _fechasArrayExport = [];
    info['data'].forEach((final String key, final value){
      Map<String, dynamic> tempDate = {
        'fecha': key,
        'obligaciones': value
      };
      listTempDate.add(tempDate);

      _fechasArrayExport.add(key);
    });

    _list = listTempDate;
    setState(() {});
  }

  exportExcelObligacionesRango() async {
    
    Map<String, dynamic> requestBody = {
      'currentWeek': {
        'start': getDateString('complete', _fechaInicio),
        'end': getDateString('complete', _fechaFin)
      },
      'fechas': _fechasExport,
      'fechasArray': _fechasArrayExport
    };

    // Map info = await dataProvider.exportExcelObligacionesRango(requestBody);


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo2.png', fit: BoxFit.contain, height: 40.0),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Colors.blue),
      ),
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

            _crearDatePicker(),

            SizedBox(height: 5.0),

            Expanded(child: _crearLista()),

            crearFooterBottom()

          ],
        )
        
      )
    );
  }

  Widget _crearDatePicker(){
    var size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            lastWeek();
          },
        ),
        (size.width>375.0) ? Text(getDateString('calendar', _fechaInicio), style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.blue))
        : Text(getDateString('calendarShort', _fechaInicio), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.blue)) ,
        
        
        (size.width>375.0) ? Text(' Al ' + getDateString('calendar', _fechaFin), style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.blue[900]))
        : Text(' Al ' + getDateString('calendarShort', _fechaFin), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.blue[900])),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: Colors.black,
          onPressed: () {
            nextWeek();
          },
        )
      ],
    );
  }


  Widget _crearLista(){
    
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index){
        var fecha = _list[index]['fecha'].split('T');
        fecha = fecha[0];
        var arrayFecha = fecha.split('-');

        var row = Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Text(arrayFecha[2], style: TextStyle(fontSize: 30.0)),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black, width: 3.0),
                      ),
                    ),
                    child:Column(
                      children: _listObligaciones(_list[index]['obligaciones'])
                    )
                  )
                ],
              ),
            ),
          ],
        );
        return row;
        
      }, 
    );
  }

  List<Widget> _listObligaciones(List list) {
    var size = MediaQuery.of(context).size;
    List<Widget> obligaciones = [];

    for (var i = 0; i < list.length; i++) {
      final x = list[i];
      obligaciones.add(
        GestureDetector(
          onTap: ()=> {
            Navigator.pushNamed(context, 'empresa_obligaciones', arguments: x)
          },
          child: Row(
            children: <Widget>[
              Container(
                width: size.width * .35,
                child: Text(x['empresaNombre'])
              ),
              Container(
                width: size.width * .25,
                child: Text(x['nombre'])
              ),
              Container(
                padding: EdgeInsets.only(left: 3.0),
                child: (x['status']==1) ? Icon(Icons.check, color: Colors.blue[900]) : Icon(Icons.access_time, color: Colors.red)
              ),
              SizedBox(height: 60.0)
            ],
          ),
        )
      );
    }

    return obligaciones;
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
          exportExcelObligacionesRango();
        },
      ),
      
    );
  }

}

