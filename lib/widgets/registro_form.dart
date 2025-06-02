import 'package:flutter/material.dart';

class RegistroForm extends StatefulWidget {
  @override
  _RegistroFormState createState() => _RegistroFormState();
}

class _RegistroFormState extends State<RegistroForm> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String email = '';
  String contrasena = '';
  String confirmarContrasena = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su nombre';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                nombre = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su email';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                contrasena = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor confirme su contraseña';
              }
              if (value != contrasena) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                confirmarContrasena = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Procesar datos
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registro exitoso')),
                );
              }
            },
            child: Text('Crear Cuenta'),
          ),
        ],
      ),
    );
  }
}