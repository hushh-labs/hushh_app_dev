// app/platforms/mobile/card_wallet/presentation/pages/create_lookbook.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/products_grid_view.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class CreateLookbookPage extends StatefulWidget {
  const CreateLookbookPage({super.key});

  @override
  State<CreateLookbookPage> createState() => _CreateLookbookPageState();
}

class _CreateLookbookPageState extends State<CreateLookbookPage>
    with TickerProviderStateMixin {
  final controller = sl<LookBookProductBloc>();
  final inventoryController = sl<InventoryBloc>();
  final lookbookNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Load products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppLocalStorage.agent != null) {
        controller
            .add(FetchAllProductsEvent(AppLocalStorage.agent!.agentBrandId));
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    lookbookNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: false,
        title: Text(
          'Create Lookbook',
          style: context.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: BlocBuilder<LookBookProductBloc, LookBookProductState>(
        bloc: controller,
        builder: (context, state) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade50,
                            Colors.purple.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.collections_bookmark,
                                  color: Colors.deepPurple,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Create Your Lookbook',
                                      style: context.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Curate a collection of products to share with customers',
                                      style: context.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Lookbook Name Input
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lookbook Name',
                                  style: context.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: lookbookNameController,
                                  decoration: InputDecoration(
                                    hintText: 'e.g., Summer Collection 2025',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple, width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter a lookbook name';
                                    }
                                    if (value.trim().length < 3) {
                                      return 'Name must be at least 3 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selected Products Counter
                    BlocBuilder<InventoryBloc, InventoryState>(
                      bloc: inventoryController,
                      builder: (context, inventoryState) {
                        final selectedCount =
                            inventoryController.selectedProductIds.length;
                        if (selectedCount > 0) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$selectedCount products selected',
                                  style: context.bodyMedium?.copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: CustomTextField(
                        controller: controller.searchProductsController,
                        hintText: 'Search products...',
                        onChanged: (value) {
                          print('🔍 [SEARCH] Search text changed: $value');
                          controller.add(const SearchProductEvent());
                        },
                      ),
                    ),

                    // Products Grid
                    _buildProductsSection(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductsSection(LookBookProductState state) {
    if (state is LoadingState) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading your products...'),
          ],
        ),
      );
    }

    if (controller.inventoryAllProductsResult == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: context.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload some products first to create a lookbook',
              style: context.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final products =
        state is ProductSearchState || state is ProductSearchFinishedState
            ? controller.allProductSearch ?? []
            : controller.inventoryAllProductsResult!.products;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products match your search',
              style: context.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ProductsGridView(
        productTileType: ProductTileType.selectProducts,
        products: products,
      ),
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      bloc: inventoryController,
      builder: (context, inventoryState) {
        return BlocBuilder<LookBookProductBloc, LookBookProductState>(
          bloc: controller,
          builder: (context, state) {
            final selectedProductIds = inventoryController.selectedProductIds;
            final hasSelectedProducts = selectedProductIds.isNotEmpty;
            final isCreating = state is CreatingLookBookState;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasSelectedProducts)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Selected Products',
                              style: context.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${selectedProductIds.length}',
                              style: context.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: HushhLinearGradientButton(
                        text: isCreating
                            ? 'Creating Lookbook...'
                            : 'Create Lookbook',
                        radius: 12,
                        icon: isCreating ? null : Icons.collections_bookmark,
                        loader: isCreating,
                        onTap: hasSelectedProducts && !isCreating
                            ? () => _createLookbook()
                            : () {},
                        color: hasSelectedProducts
                            ? Colors.deepPurple
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _createLookbook() {
    print('📝 [CREATE_LOOKBOOK] _createLookbook method called');

    if (!formKey.currentState!.validate()) {
      print('📝 [CREATE_LOOKBOOK] Form validation failed');
      return;
    }

    final selectedProductIds = inventoryController.selectedProductIds;
    print('📝 [CREATE_LOOKBOOK] Selected product IDs: $selectedProductIds');
    print(
        '📝 [CREATE_LOOKBOOK] Selected product IDs count: ${selectedProductIds.length}');

    if (selectedProductIds.isEmpty) {
      print('📝 [CREATE_LOOKBOOK] No products selected, showing warning');
      ToastManager(Toast(
        title: 'No products selected',
        description: 'Please select at least one product for your lookbook',
        type: ToastificationType.warning,
      )).show(context);
      return;
    }

    // Get selected products from the inventory
    final selectedProducts = controller.inventoryAllProductsResult!.products
        .where((product) =>
            selectedProductIds.contains(product.productSkuUniqueId))
        .toList();

    print(
        '📝 [CREATE_LOOKBOOK] Filtered selected products count: ${selectedProducts.length}');
    print(
        '📝 [CREATE_LOOKBOOK] Total products in inventory: ${controller.inventoryAllProductsResult!.products.length}');

    final lookbookName = lookbookNameController.text.trim();
    print('📝 [CREATE_LOOKBOOK] Lookbook name: $lookbookName');

    // Show Apple-style confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Create Lookbook',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: $lookbookName',
                style: Theme.of(context).textTheme.bodyMedium),
            Text('Products: ${selectedProducts.length}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            const Text('Are you sure you want to create this lookbook?'),
          ],
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Cancel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    )),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              controller.selectedProducts = selectedProducts;
              controller.add(CreateLookbookEvent(lookbookName, context));
            },
            child: Text('Create',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
          ),
        ],
      ),
    );
  }
}
