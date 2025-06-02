// lib/main.dart
import 'package:flutter/material.dart';
import 'package:fluttersw1/screens/screens/registro_screen.dart';
import 'package:fluttersw1/screens/screens/user_list_screen.dart';
import 'package:fluttersw1/widgets/pantalla_principal.dart';
// Importar todas las pantallas

void main() {
  runApp(const Proyecto2App());
}

class Proyecto2App extends StatelessWidget {
  const Proyecto2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'proyecto2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/principal',
      routes: {
        // Definir todas las rutas directamente aquí
        '/principal': (context) => PantallaPrincipal(),
        '/registro_de_usuario': (context) => RegistroScreen(),
        '/listar__usuarios': (context) => UserListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Navegación simple - TODO EN UNA CLASE
class AppNavigation {
  // Rutas disponibles
  static const String principal = '/principal';
  static const String registro_de_usuario = '/registro_de_usuario';
  static const String listar__usuarios = '/listar__usuarios';

  // Métodos simples para navegar
  static void goTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Lista para el drawer
  static List<NavigationItem> get allRoutes => [
    NavigationItem('Principal', principal, Icons.home),
    NavigationItem('Registro de usuario', registro_de_usuario, Icons.person),
    NavigationItem('Listar Usuarios', listar__usuarios, Icons.list),
  ];
}

// Item simple de navegación
class NavigationItem {
  final String title;
  final String route;
  final IconData icon;
  const NavigationItem(this.title, this.route, this.icon);
}

// Drawer automático
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Navegación',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ...AppNavigation.allRoutes.map((item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            onTap: () {
              Navigator.pop(context);
              AppNavigation.goTo(context, item.route);
            },
          )),
        ],
      ),
    );
  }
}