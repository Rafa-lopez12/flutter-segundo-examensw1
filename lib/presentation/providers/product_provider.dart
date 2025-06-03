import 'package:flutter/foundation.dart';
import '../../core/services/product_service.dart';
import '../../data/models/product/product_model.dart';
import '../../data/models/product/category_model.dart';
import '../../data/models/product/product_filter_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  // State variables
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  ProductModel? _selectedProduct;
  ProductFilterModel _currentFilter = ProductFilterModel();
  
  bool _isLoading = false;
  bool _isLoadingCategories = false;
  bool _isLoadingDetail = false;
  String? _errorMessage;
  
  // Pagination
  bool _hasMoreProducts = true;
  bool _isLoadingMore = false;

  // Getters
  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  ProductModel? get selectedProduct => _selectedProduct;
  ProductFilterModel get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingDetail => _isLoadingDetail;
  bool get hasMoreProducts => _hasMoreProducts;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;

  // Computed getters
  int get totalProducts => _products.length;
  bool get hasProducts => _products.isNotEmpty;
  bool get hasCategories => _categories.isNotEmpty;
  bool get hasFiltersApplied => _currentFilter.hasFilters;
  String get filterSummary => _currentFilter.filterSummary;

  // Load products with filters
  Future<void> loadProducts({
    ProductFilterModel? filter,
    bool refresh = false,
  }) async {
    if (refresh) {
      _products.clear();
      _hasMoreProducts = true;
    }

    _setLoading(true);
    _clearError();

    try {
      if (filter != null) {
        _currentFilter = filter.copyWith(page: 1);
      }

      final newProducts = await _productService.getProducts(
        categoryId: _currentFilter.categoryId,
        subcategory: _currentFilter.subcategory,
        search: _currentFilter.search,
        minPrice: _currentFilter.minPrice,
        maxPrice: _currentFilter.maxPrice,
        size: _currentFilter.size,
        color: _currentFilter.color,
        orderBy: _currentFilter.orderBy,
        orderDirection: _currentFilter.orderDirection,
        page: _currentFilter.page,
        limit: _currentFilter.limit,
      );

      if (refresh) {
        _products = newProducts;
      } else {
        _products.addAll(newProducts);
      }

      _hasMoreProducts = newProducts.length >= _currentFilter.limit;
      
      debugPrint('Loaded ${newProducts.length} products. Total: ${_products.length}');
      notifyListeners();
    } catch (error) {
      _handleError(error);
    } finally {
      _setLoading(false);
    }
  }

  // Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentFilter.page + 1;
      final filter = _currentFilter.copyWith(page: nextPage);
      
      final newProducts = await _productService.getProducts(
        categoryId: filter.categoryId,
        subcategory: filter.subcategory,
        search: filter.search,
        minPrice: filter.minPrice,
        maxPrice: filter.maxPrice,
        size: filter.size,
        color: filter.color,
        orderBy: filter.orderBy,
        orderDirection: filter.orderDirection,
        page: filter.page,
        limit: filter.limit,
      );

      if (newProducts.isNotEmpty) {
        _products.addAll(newProducts);
        _currentFilter = filter;
        _hasMoreProducts = newProducts.length >= _currentFilter.limit;
      } else {
        _hasMoreProducts = false;
      }

      debugPrint('Loaded ${newProducts.length} more products. Total: ${_products.length}');
    } catch (error) {
      debugPrint('Error loading more products: $error');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      _categories = await _productService.getCategories();
      debugPrint('Loaded ${_categories.length} categories');
    } catch (error) {
      debugPrint('Error loading categories: $error');
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // Load product detail
  Future<void> loadProductDetail(String productId) async {
    _isLoadingDetail = true;
    _clearError();
    notifyListeners();

    try {
      _selectedProduct = await _productService.getProductDetail(productId);
      debugPrint('Loaded product detail: ${_selectedProduct?.name}');
    } catch (error) {
      _handleError(error);
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    final filter = ProductFilterModel(
      search: query.trim(),
      orderBy: 'name',
      orderDirection: 'ASC',
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Filter by category
  Future<void> filterByCategory(String categoryId) async {
    final filter = _currentFilter.copyWith(
      categoryId: categoryId,
      subcategory: null, // Clear subcategory when changing category
      page: 1,
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Filter by subcategory
  Future<void> filterBySubcategory(String subcategory) async {
    final filter = _currentFilter.copyWith(
      subcategory: subcategory,
      page: 1,
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Apply price filter
  Future<void> filterByPrice(double? minPrice, double? maxPrice) async {
    final filter = _currentFilter.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: 1,
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Filter by size
  Future<void> filterBySize(String? size) async {
    final filter = _currentFilter.copyWith(
      size: size,
      page: 1,
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Filter by color
  Future<void> filterByColor(String? color) async {
    final filter = _currentFilter.copyWith(
      color: color,
      page: 1,
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Sort products
  Future<void> sortProducts(String orderBy, String orderDirection) async {
    final filter = _currentFilter.copyWith(
      orderBy: orderBy,
      orderDirection: orderDirection,
      page: 1,
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Clear all filters
  Future<void> clearFilters() async {
    _currentFilter = ProductFilterModel();
    await loadProducts(refresh: true);
  }

  // Apply multiple filters at once
  Future<void> applyFilters({
    String? categoryId,
    String? subcategory,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? size,
    String? color,
    String? orderBy,
    String? orderDirection,
  }) async {
    final filter = ProductFilterModel(
      categoryId: categoryId,
      subcategory: subcategory,
      search: search,
      minPrice: minPrice,
      maxPrice: maxPrice,
      size: size,
      color: color,
      orderBy: orderBy ?? 'name',
      orderDirection: orderDirection ?? 'ASC',
      page: 1,
    );
    
    await loadProducts(filter: filter, refresh: true);
  }

  // Get featured products
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    try {
      return await _productService.getFeaturedProducts(limit: limit);
    } catch (error) {
      debugPrint('Error loading featured products: $error');
      return [];
    }
  }

  // Get similar products
  Future<List<ProductModel>> getSimilarProducts(String productId) async {
    try {
      return await _productService.getSimilarProducts(productId);
    } catch (error) {
      debugPrint('Error loading similar products: $error');
      return [];
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      return await _productService.getProductsByCategory(categoryId);
    } catch (error) {
      debugPrint('Error loading products by category: $error');
      return [];
    }
  }

  // Utility methods
  ProductModel? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  CategoryModel? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  List<String> getAvailableSizes() {
    final sizes = <String>{};
    for (final product in _products) {
      sizes.addAll(product.availableSizes);
    }
    return sizes.toList()..sort();
  }

  List<String> getAvailableColors() {
    final colors = <String>{};
    for (final product in _products) {
      colors.addAll(product.availableColors);
    }
    return colors.toList()..sort();
  }

  double get minPrice {
    if (_products.isEmpty) return 0.0;
    return _products.map((p) => p.minPrice).reduce((a, b) => a < b ? a : b);
  }

  double get maxPrice {
    if (_products.isEmpty) return 1000.0;
    return _products.map((p) => p.maxPrice).reduce((a, b) => a > b ? a : b);
  }

  // Clear selected product
  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadCategories(),
      loadProducts(refresh: true),
    ]);
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _handleError(dynamic error) {
    _errorMessage = error.toString();
    debugPrint('Product Provider Error: $_errorMessage');
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Initialize provider
  Future<void> initialize() async {
    await refreshAll();
  }
}