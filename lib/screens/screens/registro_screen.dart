import 'package:flutter/material.dart';
import 'package:fluttersw1/main.dart';
import 'package:fluttersw1/widgets/registro_form.dart';

class RegistroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // Navegación automática
      
      appBar: AppBar(
        title: Text('Formulario de Registro'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Color(0xFFE1F5FE),
        child: RegistroForm(),
      ),
    );
  }
}