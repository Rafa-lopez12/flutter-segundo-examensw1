// lib/widgets/app_navigation.dart
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Navegación', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('Principal'),
            onTap: () {
              Navigator.pop(context);
              context.navigateTo(AppRoutes.principal);
            },
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('Registro de usuario'),
            onTap: () {
              Navigator.pop(context);
              context.navigateTo(AppRoutes.registro_de_usuario);
            },
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('Listar Usuarios'),
            onTap: () {
              Navigator.pop(context);
              context.navigateTo(AppRoutes.listar__usuarios);
            },
          ),
        ],
      ),
    );
  }
}