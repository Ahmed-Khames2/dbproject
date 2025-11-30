import '../../models/product.dart';
import '../../models/category.dart';
import 'add_edit_product_page.dart';
import 'package:flutter/material.dart';
import '../../blocs/product_cubit.dart';
import '../../blocs/product_state.dart';
import '../../blocs/category_cubit.dart';
import '../../blocs/category_state.dart';
import '../../widgets/form_elements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String getCategoryName(int categoryId, List<CategoryModel> categories) {
  try {
    return categories
        .firstWhere((cat) => cat.categoryId == categoryId)
        .categoryName;
  } catch (e) {
    return 'Category $categoryId';
  }
}

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<CategoryModel> categories = [];
  int? selectedCategoryFilter;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_applyFilters);
    context.read<ProductCubit>().fetchAllProducts();
    context.read<CategoryCubit>().fetchAllCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    filteredProducts = allProducts.where((product) {
      // Apply search filter
      bool matchesSearch =
          product.name.toLowerCase().contains(query) ||
          product.description?.toLowerCase().contains(query) == true ||
          getCategoryName(
            product.categoryId,
            categories,
          ).toLowerCase().contains(query);

      // Apply category filter
      bool matchesCategory =
          selectedCategoryFilter == null ||
          product.categoryId == selectedCategoryFilter;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _deleteProduct(int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<ProductCubit>().deleteProduct(productId);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, categoryState) {
          if (categoryState is CategoriesLoaded) {
            categories = categoryState.categories;
          }
          return BlocBuilder<ProductCubit, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (productState is ProductsLoaded) {
                allProducts = productState.products;
                _applyFilters();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Category Filter Chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FilterChip(
                                      label: const Text(
                                        'All',
                                        style: TextStyle(color: Colors.cyan),
                                      ),
                                      selected: selectedCategoryFilter == null,
                                      onSelected: (selected) {
                                        setState(() {
                                          selectedCategoryFilter = null;
                                        });
                                      },
                                    ),
                                  ),
                                  ...categories.map((category) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: FilterChip(
                                        label: Text(
                                          category.categoryName,
                                          style: TextStyle(color: Colors.cyan),
                                        ),
                                        selected:
                                            selectedCategoryFilter ==
                                            category.categoryId,
                                        onSelected: (selected) {
                                          setState(() {
                                            selectedCategoryFilter = selected
                                                ? category.categoryId
                                                : null;
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                          // Search Bar
                          SearchBarWidget(
                            controller: searchController,
                            hintText:
                                'Search products by name, description, or category...',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: filteredProducts.isEmpty
                          ? Center(
                              child: Text(
                                'No products found',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount: filteredProducts.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return ProductListItem(
                                  product: product,
                                  categoryName: getCategoryName(
                                    product.categoryId,
                                    categories,
                                  ),
                                  onEdit: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditProductPage(
                                              product: product,
                                            ),
                                      ),
                                    );
                                  },
                                  onDelete: () =>
                                      _deleteProduct(product.productId),
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (productState is ProductError) {
                return Center(child: Text('حدث خطأ: ${productState.message}'));
              } else {
                return const Center(child: Text('No data'));
              }
            },
          );
        },
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final String categoryName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductListItem({
    super.key,
    required this.product,
    required this.categoryName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 400) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: product.imageUrl != null
                            ? Image.network(
                                product.imageUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Price: \$${product.price}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailChip(
                          context,
                          Icons.inventory_2_outlined,
                          'Stock: ${product.stock}',
                          product.stock < 10 ? Colors.red : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDetailChip(
                          context,
                          Icons.category_outlined,
                          categoryName,
                        ),
                      ),
                    ],
                  ),
                  if (product.description != null &&
                      product.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        product.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: \$${product.price}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildDetailChip(
                              context,
                              Icons.inventory_2_outlined,
                              'Stock: ${product.stock}',
                              product.stock < 10 ? Colors.red : null,
                            ),
                            const SizedBox(width: 8),
                            _buildDetailChip(
                              context,
                              Icons.category_outlined,
                              categoryName,
                            ),
                          ],
                        ),
                        if (product.description != null &&
                            product.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              product.description!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete',
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailChip(
    BuildContext context,
    IconData icon,
    String text, [
    Color? textColor,
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color:
                  textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
