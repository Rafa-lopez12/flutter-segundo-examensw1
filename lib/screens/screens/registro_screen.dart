import 'package:flutter/material.dart';
import 'package:fluttersw1/widgets/registro_form.dart';

class RegistroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.lightBlue[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formulario de Registro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            RegistroForm(),
          ],
        ),
      ),
    );
  }
}