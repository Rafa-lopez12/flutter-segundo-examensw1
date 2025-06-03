// lib/presentation/pages/catalog/catalog_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/product/product_card.dart';
import '../../widgets/product/category_card.dart';
import '../../widgets/common/custom_button.dart';
import '../../providers/cart_provider.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> 
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  
  bool _showAppBarShadow = false;
  String _selectedCategory = 'Todos';
  String _sortBy = 'name';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showShadow = _scrollController.offset > 0;
    if (showShadow != _showAppBarShadow) {
      setState(() {
        _showAppBarShadow = showShadow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar
            _buildAppBar(),
            
            // Search Bar
            SliverToBoxAdapter(
              child: _buildSearchSection(),
            ),
            
            // Category Tabs
            SliverToBoxAdapter(
              child: _buildCategoryTabs(),
            ),
            
            // Filters and Sort
            SliverToBoxAdapter(
              child: _buildFiltersSection(),
            ),
          ];
        },
        body: _buildProductGrid(),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: _showAppBarShadow ? 4 : 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      title: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Text(
          AppStrings.catalog,
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      actions: [
        FadeInDown(
          duration: const Duration(milliseconds: 800),
          child: IconButton(
            onPressed: _onFiltersTapped,
            icon: Stack(
              children: [
                Icon(
                  IconlyLight.filter,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                if (_showFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getHorizontalPadding(context),
          vertical: 16,
        ),
        child: SearchBarWidget(
          hintText: 'Buscar productos...',
          onTap: _onSearchTapped,
          onCameraSearch: _onCameraSearchTapped,
          onVoiceSearch: _onVoiceSearchTapped,
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        height: 50,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getHorizontalPadding(context),
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          indicator: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: -12, vertical: 8),
          tabs: _categories.map((category) {
            return Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(category['name']),
              ),
            );
          }).toList(),
          onTap: (index) {
            setState(() {
              _selectedCategory = _categories[index]['name'];
            });
            HapticFeedback.lightImpact();
          },
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getHorizontalPadding(context),
          vertical: 16,
        ),
        child: Row(
          children: [
            // Results count
            Expanded(
              child: Text(
                '${_getFilteredProducts().length} productos encontrados',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Sort button
            GestureDetector(
              onTap: _onSortTapped,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconlyLight.swap,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Ordenar',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _getFilteredProducts();
    final crossAxisCount = ResponsiveUtils.getGridColumns(context);
    
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getHorizontalPadding(context),
        ),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => _onProductTapped(product),
              onAddToCart: () => _onAddToCartTapped(product),
              onFavorite: () => _onFavoriteTapped(product),
              showNewBadge: product['isNew'] ?? false,
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeIn(
            duration: const Duration(milliseconds: 800),
            child: Icon(
              IconlyLight.search,
              size: 80,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            child: Text(
              AppStrings.noProducts,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            duration: const Duration(milliseconds: 1200),
            child: Text(
              'Intenta con otros filtros o categorías',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            duration: const Duration(milliseconds: 1400),
            child: CustomButton(
              text: 'Limpiar Filtros',
              onPressed: _onClearFiltersTapped,
              type: ButtonType.outline,
              icon: IconlyLight.delete,
            ),
          ),
        ],
      ),
    );
  }

  // Event handlers
  void _onSearchTapped() {
    HapticFeedback.lightImpact();
    // TODO: Navigate to search page
  }

  void _onCameraSearchTapped() {
    HapticFeedback.lightImpact();
    // TODO: Navigate to AI search camera
  }

  void _onVoiceSearchTapped() {
    HapticFeedback.lightImpact();
    // TODO: Implement voice search
  }

  void _onFiltersTapped() {
    HapticFeedback.lightImpact();
    setState(() {
      _showFilters = !_showFilters;
    });
    // TODO: Show filters bottom sheet
    _showFiltersBottomSheet();
  }

  void _onSortTapped() {
    HapticFeedback.lightImpact();
    _showSortBottomSheet();
  }

  void _onProductTapped(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to product detail
  }

  void _onAddToCartTapped(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    
    // Add to cart with default values
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(
      productId: product['id'],
      name: product['name'],
      price: product['price'].toDouble(),
      image: product['image'] ?? '',
      size: 'M', // Default size
      color: 'Default', // Default color
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} agregado al carrito'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onFavoriteTapped(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    // TODO: Toggle favorite
  }

  void _onClearFiltersTapped() {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedCategory = 'Todos';
      _sortBy = 'name';
      _showFilters = false;
    });
    _tabController.animateTo(0);
  }

  // Bottom sheets
  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Rango de Precios',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // TODO: Add price range slider
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Slider de precios - Próximamente',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              CustomButton(
                text: 'Aplicar Filtros',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Ordenar por',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 20),
              
              ..._sortOptions.map((option) {
                return ListTile(
                  title: Text(option['label']),
                  leading: Radio<String>(
                    value: option['value'],
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                      Navigator.of(context).pop();
                    },
                    activeColor: AppColors.primary,
                  ),
                  onTap: () {
                    setState(() {
                      _sortBy = option['value'];
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  // Data filtering and sorting
  List<Map<String, dynamic>> _getFilteredProducts() {
    List<Map<String, dynamic>> filtered = List.from(_mockProducts);
    
    // Filter by category
    if (_selectedCategory != 'Todos') {
      filtered = filtered.where((product) {
        return product['category'] == _selectedCategory;
      }).toList();
    }
    
    // Sort products
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'price_low':
          return a['price'].compareTo(b['price']);
        case 'price_high':
          return b['price'].compareTo(a['price']);
        case 'rating':
          return (b['rating'] ?? 0).compareTo(a['rating'] ?? 0);
        case 'name':
        default:
          return a['name'].compareTo(b['name']);
      }
    });
    
    return filtered;
  }

  // Mock data
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Todos', 'icon': IconlyLight.category},
    {'name': 'Camisas', 'icon': IconlyLight.paper},
    {'name': 'Pantalones', 'icon': IconlyLight.bag},
    {'name': 'Vestidos', 'icon': IconlyLight.star},
    {'name': 'Zapatos', 'icon': IconlyLight.heart},
    {'name': 'Accesorios', 'icon': IconlyLight.bookmark},
  ];

  final List<Map<String, dynamic>> _sortOptions = [
    {'label': 'Nombre (A-Z)', 'value': 'name'},
    {'label': 'Precio: Menor a Mayor', 'value': 'price_low'},
    {'label': 'Precio: Mayor a Menor', 'value': 'price_high'},
    {'label': 'Mejor Calificación', 'value': 'rating'},
  ];

  final List<Map<String, dynamic>> _mockProducts = [
    {
      'id': '1',
      'name': 'Camisa Elegante Azul',
      'category': 'Camisas',
      'price': 89.99,
      'originalPrice': 120.00,
      'image': 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=400',
      'rating': 4.5,
      'isFavorite': false,
      'isNew': true,
    },
    {
      'id': '2',
      'name': 'Vestido Casual Rosa',
      'category': 'Vestidos',
      'price': 65.00,
      'image': 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400',
      'rating': 4.8,
      'isFavorite': true,
      'isNew': false,
    },
    {
      'id': '3',
      'name': 'Pantalón Formal Negro',
      'category': 'Pantalones',
      'price': 75.50,
      'originalPrice': 95.00,
      'image': 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
      'rating': 4.2,
      'isFavorite': false,
      'isNew': false,
    },
    {
      'id': '4',
      'name': 'Zapatos Deportivos',
      'category': 'Zapatos',
      'price': 120.00,
      'image': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      'rating': 4.6,
      'isFavorite': true,
      'isNew': true,
    },
    {
      'id': '5',
      'name': 'Reloj Clásico',
      'category': 'Accesorios',
      'price': 199.99,
      'originalPrice': 250.00,
      'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      'rating': 4.9,
      'isFavorite': false,
      'isNew': false,
    },
    {
      'id': '6',
      'name': 'Camisa Casual Blanca',
      'category': 'Camisas',
      'price': 45.00,
      'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      'rating': 4.3,
      'isFavorite': false,
      'isNew': true,
    },
  ];
}