// lib/presentation/providers/auth_provider.dart
import 'package:flutter/foundation.dart';

// Modelo temporal básico de Cliente para el diseño
class Cliente {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? address;
  final bool isActive;
  final String tenantId;

  Cliente({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.address,
    required this.isActive,
    required this.tenantId,
  });

  String get fullName => '$firstName $lastName';
}

class AuthProvider extends ChangeNotifier {
  // State variables
  Cliente? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  String? _token;

  // Getters
  Cliente? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  String? get userFullName => _currentUser?.fullName;
  String? get userEmail => _currentUser?.email;
  String? get userId => _currentUser?.id;

  // Initialize auth state (temporal - sin persistencia)
  Future<void> initializeAuth() async {
    _setLoading(true);
    
    // Simular verificación de token guardado
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Por ahora, siempre empezamos sin autenticar
    _isAuthenticated = false;
    _currentUser = null;
    _token = null;
    
    _setLoading(false);
  }

  // Login method (temporal - solo para UI)
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular validación básica
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email y contraseña son requeridos');
      }
      
      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }
      
      if (password.length < 6) {
        throw Exception('Contraseña muy corta');
      }

      // Simular respuesta exitosa - crear usuario temporal
      _currentUser = Cliente(
        id: 'temp_user_123',
        email: email,
        firstName: 'Usuario',
        lastName: 'Demo',
        phone: null,
        address: null,
        isActive: true,
        tenantId: 'temp_tenant_123',
      );
      
      _token = 'temp_token_${DateTime.now().millisecondsSinceEpoch}';
      _isAuthenticated = true;

      notifyListeners();
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Register method (temporal - solo para UI)
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? address,
    DateTime? birthDate,
    bool acceptNewsletter = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular validación básica
      if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Todos los campos obligatorios deben completarse');
      }
      
      if (!email.contains('@')) {
        throw Exception('Email inválido');
      }
      
      if (password.length < 6) {
        throw Exception('Contraseña muy corta');
      }

      // Simular respuesta exitosa - crear usuario temporal
      _currentUser = Cliente(
        id: 'temp_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        isActive: true,
        tenantId: 'temp_tenant_123',
      );
      
      _token = 'temp_token_${DateTime.now().millisecondsSinceEpoch}';
      _isAuthenticated = true;

      notifyListeners();
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Logout method (temporal)
  Future<void> logout() async {
    _setLoading(true);

    try {
      // Simular llamada a logout
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Limpiar datos locales
      await _clearAuthData();
      
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Limpiar datos aunque haya error
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile (temporal)
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    if (_currentUser == null) return;

    _setLoading(true);
    _clearError();

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));
      
      // Crear usuario actualizado
      _currentUser = Cliente(
        id: _currentUser!.id,
        email: _currentUser!.email,
        firstName: firstName ?? _currentUser!.firstName,
        lastName: lastName ?? _currentUser!.lastName,
        phone: phone ?? _currentUser!.phone,
        address: address ?? _currentUser!.address,
        isActive: _currentUser!.isActive,
        tenantId: _currentUser!.tenantId,
      );
      
      notifyListeners();
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Simular cambio de contraseña
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simular validación y llamada a API
      await Future.delayed(const Duration(seconds: 1));
      
      if (currentPassword.isEmpty || newPassword.isEmpty) {
        throw Exception('Ambas contraseñas son requeridas');
      }
      
      if (newPassword.length < 6) {
        throw Exception('La nueva contraseña debe tener al menos 6 caracteres');
      }
      
      // Simular éxito
      notifyListeners();
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Auto-login (temporal - siempre retorna false)
  Future<bool> tryAutoLogin() async {
    // Por ahora no implementamos auto-login
    return false;
  }

  // Refresh user data (temporal)
  Future<void> refreshUserData() async {
    if (!_isAuthenticated || _currentUser == null) return;

    try {
      // Simular refresh
      await Future.delayed(const Duration(milliseconds: 500));
      // Por ahora no hacemos nada, los datos ya están actualizados
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to refresh user data: $e');
    }
  }

  // Limpiar todos los datos de autenticación
  Future<void> _clearAuthData() async {
    _currentUser = null;
    _token = null;
    _isAuthenticated = false;
    _errorMessage = null;
    
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Handle errors
  void _handleError(dynamic error) {
    _errorMessage = error.toString();
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    _errorMessage = null;
  }

  // Utilidades temporales
  bool hasPermission(String permission) {
    return _isAuthenticated;
  }

  bool get isEmailVerified {
    return _currentUser?.isActive ?? false;
  }

  String get userInitials {
    if (_currentUser == null) return '';
    
    final firstName = _currentUser!.firstName;
    final lastName = _currentUser!.lastName;
    
    if (firstName.isEmpty && lastName.isEmpty) return '';
    
    return '${firstName.isNotEmpty ? firstName[0].toUpperCase() : ''}'
           '${lastName.isNotEmpty ? lastName[0].toUpperCase() : ''}';
  }

  bool get isNewUser => false;

  // Session management (temporal - no implementado)
  void startSessionTimer() {
    // TODO: Implementar cuando sea necesario
  }

  void resetSessionTimer() {
    // TODO: Implementar cuando sea necesario
  }
}