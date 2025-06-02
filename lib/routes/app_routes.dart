// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:fluttersw1/screens/screens/registro_screen.dart';
import 'package:fluttersw1/screens/screens/user_list_screen.dart';
import 'package:fluttersw1/widgets/pantalla_principal.dart';

class AppRoutes {
  // Rutas de la aplicación
  static const String principal = '/principal';
  static const String registro_de_usuario = '/registro_de_usuario';
  static const String listar__usuarios = '/listar__usuarios';

  // Ruta inicial
  static String get initialRoute => principal;

  // Mapa de rutas
  static Map<String, WidgetBuilder> get routes {
    return {
      principal: (context) => PantallaPrincipal(),
      registro_de_usuario: (context) => RegistroScreen(),
      listar__usuarios: (context) => UserListScreen(),
    };
  }

  // Métodos de navegación
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndClearStack(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: arguments);
  }

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

// Extensión para navegación simplificada
extension NavigationExtension on BuildContext {
  void navigateTo(String routeName, {Object? arguments}) {
    AppRoutes.navigateTo(this, routeName, arguments: arguments);
  }

  void navigateReplace(String routeName, {Object? arguments}) {
    AppRoutes.navigateReplace(this, routeName, arguments: arguments);
  }

  void navigateAndClearStack(String routeName, {Object? arguments}) {
    AppRoutes.navigateAndClearStack(this, routeName, arguments: arguments);
  }

  void goBack() {
    AppRoutes.goBack(this);
  }
}