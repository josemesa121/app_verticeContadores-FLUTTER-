import 'package:flutter/material.dart';
import 'package:vertice_contadores/src/pages/cambio_clave_page.dart';
import 'package:vertice_contadores/src/pages/empresa_detalles_page.dart';
import 'package:vertice_contadores/src/pages/empresa_obligaciones_page.dart';
import 'package:vertice_contadores/src/pages/empresas_page.dart';
import 'package:vertice_contadores/src/pages/forgot_password_page.dart';
import 'package:vertice_contadores/src/pages/home_page.dart';
import 'package:vertice_contadores/src/pages/login_page.dart';
import 'package:vertice_contadores/src/pages/manage_empresa_page.dart';
import 'package:vertice_contadores/src/pages/register_page.dart';


Map<String, WidgetBuilder> getApplicationRoutes() {

  return <String, WidgetBuilder>{
    '/': (BuildContext context) => LoginPage(),
    'register': (BuildContext context) => RegisterPage(),
    'forgot_password': (BuildContext context) => ForgotPasswordPage(),
    'home': (BuildContext context) => HomePage(),
    'empresas': (BuildContext context) => EmpresasPage(),
    'manage_empresa': (BuildContext context) => ManageEmpresaPage(),
    'empresa_obligaciones': (BuildContext context) => EmpresaObligacionesPage(),
    'empresa_detalles': (BuildContext context) => EmpresaDetallesPage(),
    'cambio_clave': (BuildContext context) => CambioClavePage(),
  };
}