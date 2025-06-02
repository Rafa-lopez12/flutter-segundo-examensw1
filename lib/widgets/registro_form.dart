import 'package:flutter/material.dart';

class RegistroForm extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmarContrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nombreController,
          decoration: InputDecoration(labelText: 'Nombre'),
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: contrasenaController,
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
        TextField(
          controller: confirmarContrasenaController,
          decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Lógica para crear cuenta
          },
          child: Text('Crear Cuenta'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
        ),
      ],
    );
  }
}