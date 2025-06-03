// lib/presentation/providers/cart_provider.dart
import 'package:flutter/foundation.dart';

// Modelo temporal de CartItem
class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String image;
  final String size;
  final String color;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.size,
    required this.color,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'size': size,
      'color': color,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      size: json['size'],
      color: json['color'],
      quantity: json['quantity'],
    );
  }
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Map<String, CartItem> get items => {..._items};
  List<CartItem> get itemsList => _items.values.toList();
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  int get uniqueItemCount => _items.length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _items.isEmpty;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get subtotal => totalAmount;

  double get shipping {
    return totalAmount > 100 ? 0.0 : 10.0; // Envío gratis sobre $100
  }

  double get tax {
    return totalAmount * 0.15; // 15% de impuestos
  }

  double get finalTotal => subtotal + shipping + tax;

  // Add item to cart
  Future<void> addItem({
    required String productId,
    required String name,
    required double price,
    required String image,
    required String size,
    required String color,
    int quantity = 1,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 500));

      final itemKey = '${productId}_${size}_${color}';
      
      if (_items.containsKey(itemKey)) {
        // Si el item ya existe, incrementar cantidad
        _items[itemKey]!.quantity += quantity;
      } else {
        // Crear nuevo item
        _items[itemKey] = CartItem(
          id: itemKey,
          productId: productId,
          name: name,
          price: price,
          image: image,
          size: size,
          color: color,
          quantity: quantity,
        );
      }

      notifyListeners();
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Remove item from cart
  Future<void> removeItem(String itemId) async {
    _setLoading(true);
    _clearError();

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 300));

      _items.remove(itemId);
      notifyListeners();
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(itemId);
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 300));

      if (_items.containsKey(itemId)) {
        _items[itemId]!.quantity = newQuantity;
        notifyListeners();
      }
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    _setLoading(true);
    _clearError();

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 500));

      _items.clear();
      notifyListeners();
    } catch (e) {
      _handleError(e);
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  // Get specific item
  CartItem? getItem(String itemId) {
    return _items[itemId];
  }

  // Check if product exists in cart
  bool containsProduct(String productId, String size, String color) {
    final itemKey = '${productId}_${size}_${color}';
    return _items.containsKey(itemKey);
  }

  // Get quantity of specific product variant
  int getProductQuantity(String productId, String size, String color) {
    final itemKey = '${productId}_${size}_${color}';
    return _items[itemKey]?.quantity ?? 0;
  }

  // Load cart from server (temporal)
  Future<void> loadCart() async {
    _setLoading(true);
    _clearError();

    try {
      // Simular carga desde API
      await Future.delayed(const Duration(seconds: 1));
      
      // Por ahora no cargar nada, el carrito empieza vacío
      notifyListeners();
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoading(false);
    }
  }

  // Sync cart to server (temporal)
  Future<void> syncCart() async {
    try {
      // Simular sincronización
      await Future.delayed(const Duration(milliseconds: 500));
      // TODO: Implementar sincronización con backend
    } catch (e) {
      debugPrint('Failed to sync cart: $e');
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _handleError(dynamic error) {
    _errorMessage = error.toString();
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Cart utilities
  bool canCheckout() {
    return _items.isNotEmpty && !_isLoading;
  }

  String getCartSummary() {
    if (_items.isEmpty) return 'Carrito vacío';
    
    final totalItems = itemCount;
    final total = totalAmount;
    
    return '$totalItems ${totalItems == 1 ? 'artículo' : 'artículos'} • \${total.toStringAsFixed(2)}';
  }

  // Mock data for testing
  void addMockItems() {
    _items.clear();
    
    _items['1_M_Azul'] = CartItem(
      id: '1_M_Azul',
      productId: '1',
      name: 'Camisa Elegante',
      price: 89.99,
      image: 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=400',
      size: 'M',
      color: 'Azul',
      quantity: 1,
    );
    
    _items['2_S_Rosa'] = CartItem(
      id: '2_S_Rosa',
      productId: '2',
      name: 'Vestido Casual',
      price: 65.00,
      image: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400',
      size: 'S',
      color: 'Rosa',
      quantity: 2,
    );
    
    notifyListeners();
  }
}