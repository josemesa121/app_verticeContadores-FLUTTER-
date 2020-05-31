import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:vertice_contadores/src/preferencias_usuario/preferencias_usuario.dart';



class _DataProvider{

  final _prefs = new PreferenciasUsuario();

  final String urlServidor = 'http://192.168.1.103:3000';


  // Map<String, dynamic> parseJwt(String token) {
  //   final parts = token.split('.');
  //   if (parts.length != 3) {
  //     throw Exception('invalid token');
  //   }

  //   final payload = _decodeBase64(parts[1]);
  //   final payloadMap = json.decode(payload);
  //   if (payloadMap is! Map<String, dynamic>) {
  //     throw Exception('invalid payload');
  //   }

  //   return payloadMap;
  // }

  // String _decodeBase64(String str) {
  //   String output = str.replaceAll('-', '+').replaceAll('_', '/');

  //   switch (output.length % 4) {
  //     case 0:
  //       break;
  //     case 2:
  //       output += '==';
  //       break;
  //     case 3:
  //       output += '=';
  //       break;
  //     default:
  //       throw Exception('Illegal base64url string!"');
  //   }

  //   return utf8.decode(base64Url.decode(output));
  // }


  // Future<Map<String, dynamic>> verifyMeAuth() async {

  //   final res = await http.get(
  //     '$urlServidor/users/me',
  //     headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
  //   );

  //   Map<String, dynamic> decodedRes = json.decode(res.body);
  //   final int statusCode = res.statusCode;

  //   print(res.body);
      
  //   if(statusCode==200){
  //     return {'ok': true, 'data': decodedRes};
  //   }else{
  //     return {'ok':false, 'msg': 'Error'};
  //   }

  // }




  Future<Map<String, dynamic>> login( String email, String password) async {

    final formData = {
      'email'    : email,
      'password' : password
    };

    final res = await http.post(
      '$urlServidor/users/login',
      headers: {"Accept": "application/json","Content-type": "application/json"},
      body: json.encode(formData)
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      _prefs.token = decodedRes['token'];
      _prefs.user = json.encode( decodedRes['user']);

      // print(parseJwt(_prefs.token));

      return {'ok': true, 'token': decodedRes['token']};
    }else{
      return {'ok':false, 'msg': 'Correo o contraseña invalida'};
    }

  }

  Map<String, dynamic> log_out(){

    _prefs.token = '';
    _prefs.user = '';

    return {'ok':true, 'msg': 'sesion cerrada'};
  }


  Future<Map<String, dynamic>> register( String nombre, String apellidos, String email, String password, String confirmPassword) async {

    String mensaje = '';
    bool validForm = true;

    if(password==''){
      mensaje='Contraseña es requerido';
      validForm = false;
    }
    if(password!=confirmPassword){
      mensaje='Repetir contraseña debe ser igual a contraseña';
      validForm = false;
    }
    if(apellidos==''){
      mensaje='Appellidos es requerido';
      validForm = false;
    }
    if(nombre==''){
      mensaje='Nombre es requerido';
      validForm = false;
    }
    if(email==''){
      mensaje='Correro es requerido';
      validForm = false;
    }

    if(!validForm){
      return {'ok': false, 'msg': mensaje};
    }

    final formData = {
      'firstName': nombre,
      'lastName': apellidos,
      'email': email,
      'password': password
    };

    final res = await http.post(
      '$urlServidor/users',
      headers: {"Accept": "application/json","Content-type": "application/json"},
      body: json.encode(formData)
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
  
    if(statusCode == 200){
      return {'ok': true, 'msg': 'Registro completado'};
    }else{

      if(decodedRes['error']['message']=="ER_DUP_ENTRY: Duplicate entry '$email' for key 'uniqueEmail'"){
        mensaje =  'Este correo ya esta registrado';
      }else if(decodedRes['error']['message']=='invalid email'){
        mensaje = 'Correo invalido';
      }else if (decodedRes['error']['message']=='password must be minimum 8 characters'){
        mensaje = 'Contrasseña minimo 8 caraccteres';
      }else{
        mensaje = decodedRes['error']['message'];
      }

      return {'ok': false, 'msg': mensaje};
    }
    
  }


  Future<Map<String, dynamic>> recover_password( String email) async {
    String mensaje = '';
    bool validForm = true;

    if(email==''){
      mensaje='Correro es requerido';
      validForm = false;
    }

    if(!validForm){
      return {'ok': false, 'msg': mensaje};
    }

    final formData = {
      'email': email
    };

    final res = await http.post(
      '$urlServidor/recover-password',
      headers: {"Accept": "application/json","Content-type": "application/json"},
      body: json.encode(formData)
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(decodedRes['status'] == 'ok'){
      return {'ok': true, 'msg': decodedRes['message']};
    }else{
      return {'ok': false, 'msg': decodedRes['message']};
    }

  }


  Future<Map<String, dynamic>> getObligacionesRango(String fechaInicio, String fechaFin) async {

    final res = await http.get(
      '$urlServidor/empresas/obligaciones-rango/$fechaInicio/$fechaFin',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;

      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }


  Future exportExcelObligacionesRango(Map<String, dynamic> data) async {

    final res = await http.post(
      '$urlServidor/empresas/export-obligaciones-rango',
      headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Accept": 'application/vnd.ms-excel',
        "Authorization": "Bearer ${_prefs.token}"
      },
      body: json.encode(data)
    );
    print(res.body);

    // Map<String, dynamic> decodedRes = json.decode(res.body);
    // final int statusCode = res.statusCode;

      
    // if(statusCode==200){
    //   return {'ok': true, 'data': decodedRes};
    // }else{
    //   return {'ok':false, 'msg': 'Correo o contraseña invalida'};
    // }

  }

  Future<Map<String, dynamic>> getEmpresas() async {

    final res = await http.get(
      '$urlServidor/empresas',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    List decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }


  Future<Map<String, dynamic>> registrarEmpresa(
    String nombre,
    int tipo,
    String nit,
    String nitDigito,
    String contacto,
    String direccion,
    String email,
    String telefono,
    String cedula,
    String clave_dian,
    String clave_firma_dian,
    String place_iyc,
    String placa_reteica,
    String datos_contabilidad
  ) async {

    String mensaje = '';
    bool validForm = true;


    if(nitDigito==''){
      mensaje='Registro de Verificación es requerido';
      validForm = false;
    }
    if(nit==''){
      mensaje='Nit es requerido';
      validForm = false;
    }
    if(nombre==''){
      mensaje='Nombre es requerido';
      validForm = false;
    }

    if(!validForm){
      return {'ok': false, 'msg': mensaje};
    }

    final formData = {
      'nombre': nombre,
      'tipo': tipo,
      'nit': nit,
      'nitDigito': nitDigito,
      'contacto': contacto,
      'direccion': direccion,
      'email': email,
      'telefono': telefono,
      'cedula': cedula,
      'clave_dian': clave_dian,
      'clave_firma_dian': clave_firma_dian,
      'place_iyc': place_iyc,
      'placa_reteica': placa_reteica,
      'datos_contabilidad': datos_contabilidad
    };

    final res = await http.post(
      '$urlServidor/empresas',
      headers: {"Accept": "application/json","Content-type": "application/json","Authorization": "Bearer ${_prefs.token}"},
      body: json.encode(formData)
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
  
    if(statusCode == 200){
      return {'ok': true, 'msg': 'Empresa agregada', 'data': decodedRes};
    }else{
      mensaje = 'Opps!! Hubo un error';
      return {'ok': false, 'msg': mensaje};
    }


    
  }



  Future<Map<String, dynamic>> updateEmpresa(
    int userId,
    int id,
    String nombre,
    int tipo,
    String nit,
    String nitDigito,
    String contacto,
    String direccion,
    String email,
    String telefono,
    String cedula,
    String clave_dian,
    String clave_firma_dian,
    String place_iyc,
    String placa_reteica,
    String datos_contabilidad
  ) async {

    String mensaje = '';
    bool validForm = true;


    if(nitDigito==''){
      mensaje='Registro de Verificación es requerido';
      validForm = false;
    }
    if(nit==''){
      mensaje='Nit es requerido';
      validForm = false;
    }
    if(nombre==''){
      mensaje='Nombre es requerido';
      validForm = false;
    }

    if(!validForm){
      return {'ok': false, 'msg': mensaje};
    }

    final formData = {
      'userId': userId,
      'nombre': nombre,
      'tipo': tipo,
      'nit': nit,
      'nitDigito': nitDigito,
      'contacto': contacto,
      'direccion': direccion,
      'email': email,
      'telefono': telefono,
      'cedula': cedula,
      'clave_dian': clave_dian,
      'clave_firma_dian': clave_firma_dian,
      'place_iyc': place_iyc,
      'placa_reteica': placa_reteica,
      'datos_contabilidad': datos_contabilidad
    };

    final res = await http.put(
      '$urlServidor/empresas/$id',
      headers: {"Accept": "application/json","Content-type": "application/json","Authorization": "Bearer ${_prefs.token}"},
      body: json.encode(formData)
    );

    print(res.body);
    final int statusCode = res.statusCode;
  
    if(statusCode == 204){
      return {'ok': true, 'msg': 'Empresa actualizada'};
    }else{
      mensaje = 'Opps!! Hubo un error';
      return {'ok': false, 'msg': mensaje};
    }


    
  }



  Future<Map<String, dynamic>> deleteEmpresa(id) async {

    final res = await http.delete(
      '$urlServidor/empresas/$id',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    final int statusCode = res.statusCode;
      
    if(statusCode==204){
      return {'ok': true, 'msg': 'Empresa eliminada'};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }



  Future<Map<String, dynamic>> getEmpresa(int id) async {

    final res = await http.get(
      '$urlServidor/empresas/$id',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;

      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }


  Future<Map<String, dynamic>> getObligacion(int id) async {

    final res = await http.get(
      '$urlServidor/obligacion/$id',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }



  Future<Map<String, dynamic>> getEmpresaObligaciones(empresaId, obligacionId) async {

    final res = await http.get(
      '$urlServidor/empresas/$empresaId/obligaciones/$obligacionId/',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    List decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }


  Future<Map<String, dynamic>> updateEmpresaObligacionNota(int id, String nota ) async {

    String mensaje = '';
    bool validForm = true;


    if(nota==null){
      nota == '';
    }

    final formData = {
      'nota': nota,
    };

    final res = await http.patch(
      '$urlServidor/empresa-obligacion/$id',
      headers: {"Accept": "application/json","Content-type": "application/json","Authorization": "Bearer ${_prefs.token}"},
      body: json.encode(formData)
    );

    print(res.body);
    final int statusCode = res.statusCode;
  
    if(statusCode == 204){
      return {'ok': true, 'msg': 'Nota Guardada'};
    }else{
      mensaje = 'Opps!! Hubo un error';
      return {'ok': false, 'msg': mensaje};
    }
    
  }

  Future<Map<String, dynamic>> updateEmpresaObligacionStatus(int id, int  status) async {

    String mensaje = '';
    bool validForm = true;

    final formData = {
      'status': status,
    };

    final res = await http.patch(
      '$urlServidor/empresa-obligacion/$id',
      headers: {"Accept": "application/json","Content-type": "application/json","Authorization": "Bearer ${_prefs.token}"},
      body: json.encode(formData)
    );

    final int statusCode = res.statusCode;
  
    if(statusCode == 204){
      return {'ok': true, 'msg': 'Estado Actualizado'};
    }else{
      mensaje = 'Opps!! Hubo un error';
      return {'ok': false, 'msg': mensaje};
    }
    
  }







  Future<Map<String, dynamic>> getObligacionesAnios() async {

    final res = await http.get(
      '$urlServidor/empresas/obligaciones-anios',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    List decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }


  Future<Map<String, dynamic>> getEmpresaObligacionesByAnio(empresaId, anioId) async {

    final res = await http.get(
      '$urlServidor/empresas/$empresaId/obligacionesbyanio/$anioId',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    List decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }









  Future<Map<String, dynamic>> getEmpresaDocumentos(empresaId) async {

    final res = await http.get(
      '$urlServidor/documentos/$empresaId',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    List decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }
  }



  Future<Map<String, dynamic>> uploadFile(String filename, int empresaId, String nota) async {

    var uri = '$urlServidor/documentos/upload/$empresaId';

    var request = http.MultipartRequest('POST', Uri.parse(uri));
    request.headers['authorization'] = "Bearer ${_prefs.token}";

    request.fields['nota'] = nota;
    request.fields['documentoCategoriaId'] = '1';
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();

    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'msg': 'Archivo guardado', 'data': res};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }
  }


  Future<Map<String, dynamic>> deleteFile(id) async {

    final res = await http.delete(
      '$urlServidor/documentos/$id',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    final int statusCode = res.statusCode;
    print(res.body);
      
    if(statusCode==204){
      return {'ok': true, 'msg': 'Documento eliminado'};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }






  Future<Map<String, dynamic>> getEmpresaObligacionesConfig(empresaId, obligacionAnioId) async {

    final res = await http.get(
      '$urlServidor/empresas/obligaciones-config/$empresaId/year/$obligacionAnioId',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    List decodedRes = json.decode(res.body);
    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'data': decodedRes};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }
  }




  Future<Map<String, dynamic>> updateOblogacionConfig(empresaId, obligacionId) async {

    final res = await http.post(
      '$urlServidor/empresas/$empresaId/obligaciones/$obligacionId',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"},
    );

    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'msg': 'Obligacion actualizada'};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }


  Future<Map<String, dynamic>> deleteOblogacionConfig(empresaId, obligacionId) async {

    final res = await http.delete(
      '$urlServidor/empresas/$empresaId/obligaciones/$obligacionId',
      headers: {"Accept": "application/json","Content-type": "application/json", "Authorization": "Bearer ${_prefs.token}"}
    );

    final int statusCode = res.statusCode;
      
    if(statusCode==200){
      return {'ok': true, 'msg': 'Obligacion actualizada'};
    }else{
      return {'ok':false, 'msg': 'Error'};
    }

  }




  Future<Map<String, dynamic>> updatePassword(currentPassword, user) async {

    if(user['password'].length<8){
      return {'ok': false, 'msg': 'Nueva Clave: Minimo 8 caracteres'};
    }

    final formData = {
      'currentPassword': currentPassword,
      'user': user
    };

    final res = await http.patch(
      '$urlServidor/users/update-password/${user['id']}',
      headers: {"Accept": "application/json","Content-type": "application/json","Authorization": "Bearer ${_prefs.token}"},
      body: json.encode(formData)
    );

    final int statusCode = res.statusCode;
  
    if(statusCode == 204){
      return {'ok': true, 'msg': 'Contraseña actualizada'};
    }else{
      return {'ok': false, 'msg': res.body};
    }
    
  }

}

final dataProvider = new _DataProvider();