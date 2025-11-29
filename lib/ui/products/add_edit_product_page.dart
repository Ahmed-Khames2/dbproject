import 'package:dio/dio.dart';
import '../../data/consr.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import 'package:flutter/material.dart';
import '../../blocs/product_cubit.dart';
import '../../blocs/category_cubit.dart';
import '../../blocs/category_state.dart';
import '../../widgets/form_elements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedImageUrl;
  int? _selectedCategoryName;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _selectedImageUrl = widget.product!.imageUrl;
      _selectedCategoryName = widget.product!.categoryId;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Upload to Cloudinary
      final uploadedUrl = await _uploadToCloudinary(pickedFile.path);
      if (uploadedUrl != null) {
        setState(() {
          _selectedImageUrl = uploadedUrl;
        });
      }
    }
  }

  Future<String?> _uploadToCloudinary(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath),
        'upload_preset': kCloudinaryUploadPreset,
      });

      final response = await Dio().post(
        'https://api.cloudinary.com/v1_1/$kCloudinaryCloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['secure_url'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل في رفع الصورة')));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء رفع الصورة')));
      return null;
    }
  }

  void _saveProduct(List<CategoryModel> categories) async {
    if (_formKey.currentState!.validate()) {
      final price = double.tryParse(_priceController.text);
      final stock = int.tryParse(_stockController.text);

      if (price == null || stock == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('السعر أو المخزون غير صحيح')));
        return;
      }

      final selectedCategory = categories.firstWhere(
        (c) => c.categoryId == _selectedCategoryName,
        orElse: () => categories.first,
      );

      final product = ProductModel(
        productId: widget.product?.productId ?? 0,
        categoryId: selectedCategory.categoryId,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        price: price,
        stock: stock,
        imageUrl: _selectedImageUrl,
      );

      try {
        if (widget.product == null) {
          await context.read<ProductCubit>().createProduct(product);
        } else {
          await context.read<ProductCubit>().updateProduct(widget.product!.productId, product);
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product saved')));
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء حفظ المنتج')));
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
            final categories = state.categories;
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Name',
                      controller: _nameController,
                      validator: (value) => value!.isEmpty ? 'Name is required' : null,
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
                        if (double.tryParse(value) == null) return 'Invalid price';
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
                      value: _selectedCategoryName,
                      items: categories,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedCategoryName = value;
                        });
                      },
                      validator: (int? value) => value == null ? 'Category is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Upload Image'),
                        ),
                        const SizedBox(width: 16),
                        _selectedImageUrl != null
                            ? Image.network(_selectedImageUrl!, width: 120, height: 120, fit: BoxFit.cover)
                            : const Text('No image selected'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => _saveProduct(categories),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
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
