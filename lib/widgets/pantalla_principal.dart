import 'package:flutter/material.dart';
import 'widget_boton.dart';

class PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel Administrativo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetBoton(color: Colors.green, texto: 'Registros usuario'),
          WidgetBoton(color: Colors.cyan, texto: 'Listar usuarios'),
          WidgetBoton(color: Colors.red, texto: 'Cerrar Sección'),
        ],
      ),
    );
  }
}