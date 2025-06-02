// lib/utils/navigation_utils.dart
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class NavigationUtils {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  // Navegación sin contexto
  static Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }

static Future<T?> pushReplacementNamed<T extends Object?>(String routeName, {Object? arguments}) {
  return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments) as Future<T?>;
}

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, 
    bool Function(Route<dynamic>) predicate, 
    {Object? arguments}
  ) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(routeName, predicate, arguments: arguments);
  }

  static void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  // Métodos de conveniencia
  static void goToHome() {
    pushNamedAndRemoveUntil(AppRoutes.initialRoute, (route) => false);
  }
}