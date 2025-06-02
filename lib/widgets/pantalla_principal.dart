import 'package:flutter/material.dart';
import 'widget_boton.dart';

class PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel Administrativo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetBoton(
              color: Colors.green,
              texto: 'Registros usuario',
              onPressed: () {
                // Acción para Registros usuario
              },
            ),
            SizedBox(height: 20),
            WidgetBoton(
              color: Colors.cyan,
              texto: 'Listar usuarios',
              onPressed: () {
                // Acción para Listar usuarios
              },
            ),
            SizedBox(height: 20),
            WidgetBoton(
              color: Colors.red,
              texto: 'Cerrar Sección',
              onPressed: () {
                // Acción para Cerrar Sección
              },
            ),
          ],
        ),
      ),
    );
  }
}