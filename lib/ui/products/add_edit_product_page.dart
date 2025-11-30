import 'dart:io';
import '../../models/product.dart';
import '../../models/category.dart';
import 'package:flutter/material.dart';
import '../../blocs/product_cubit.dart';
import '../../blocs/category_cubit.dart';
import '../../blocs/category_state.dart';
import '../../widgets/form_elements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/cloudinary_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _imageUrl;
  File? _selectedImageFile;
  int? _selectedCategoryName;
  bool _isUploadingImage = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchAllCategories();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _imageUrl = widget.product!.imageUrl;
      _selectedCategoryName = widget.product!.categoryId;
    }
  }

  Future<void> _selectImage() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Product Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _isUploadingImage = true;
      });

      final uploadedUrl = await CloudinaryService.uploadImage(image);
      setState(() {
        _isUploadingImage = false;
        if (uploadedUrl != null) {
          _imageUrl = uploadedUrl;
        } else {
          _selectedImageFile = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      });
    }
  }

  void _saveProduct(List<CategoryModel> categories) async {
    if (_formKey.currentState!.validate()) {
      final price = double.tryParse(_priceController.text);
      final stock = int.tryParse(_stockController.text);

      if (price == null || stock == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('السعر أو المخزون غير صحيح')),
        );
        return;
      }

      setState(() => _isUploadingImage = true);

      // Use existing image URL or keep current one if not changed
      String? finalImageUrl = _imageUrl ?? widget.product?.imageUrl;

      final selectedCategory = categories.firstWhere(
        (c) => c.categoryId == _selectedCategoryName,
        orElse: () => categories.first,
      );

      final product = ProductModel(
        productId: widget.product?.productId ?? 0,
        categoryId: selectedCategory.categoryId,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        price: price,
        stock: stock,
        imageUrl: finalImageUrl,
      );

      try {
        if (widget.product == null) {
          await context.read<ProductCubit>().createProduct(product);
        } else {
          await context.read<ProductCubit>().updateProduct(
            widget.product!.productId,
            product,
          );
        }
        if (!mounted) return;
        // Refresh the products list in the parent page
        context.read<ProductCubit>().fetchAllProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product ${widget.product == null ? 'created' : 'updated'} successfully')),
        );
        // Only pop for new products, stay on page for updates
        if (widget.product == null) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء ${widget.product == null ? 'إنشاء' : 'تحديث'} المنتج: $e')),
        );
      } finally {
        if (mounted) setState(() => _isUploadingImage = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoriesLoaded) {
            // Remove duplicate categories by ID to avoid dropdown errors
            final categories = state.categories
                .fold<Map<int, CategoryModel>>({}, (map, category) {
                  map[category.categoryId] = category;
                  return map;
                })
                .values
                .toList();

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Name',
                      controller: _nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Description',
                      controller: _descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Price',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Price is required';
                        if (double.tryParse(value) == null)
                          return 'Invalid price';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Old Price (Optional)',
                      controller: _oldPriceController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Stock',
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Stock is required';
                        if (int.tryParse(value) == null) return 'Invalid stock';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      label: 'Category',
                      value:
                          _selectedCategoryName != null &&
                              categories.any(
                                (c) => c.categoryId == _selectedCategoryName,
                              )
                          ? _selectedCategoryName
                          : null,
                      items: categories,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedCategoryName = value;
                        });
                      },
                      validator: (int? value) =>
                          value == null ? 'Category is required' : null,
                    ),
                    const SizedBox(height: 16),
                    // Product image preview
                    GestureDetector(
                      onTap: _isUploadingImage ? null : _selectImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.grey[200],
                        ),
                        child: _isUploadingImage
                            ? const Center(child: CircularProgressIndicator())
                            : _imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              )
                            : _selectedImageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.file(
                                  _selectedImageFile!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tap to select image',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => _saveProduct(categories),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Save Product'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _oldPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
