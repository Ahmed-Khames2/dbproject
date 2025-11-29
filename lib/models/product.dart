class ProductModel {
  final int productId;
  final int categoryId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;

  ProductModel({
    required this.productId,
    required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['ProductID'],
      categoryId: json['CategoryID'],
      name: json['Name'],
      description: json['Description'],
      price: json['Price'].toDouble(),
      stock: json['Stock'],
      imageUrl: json['ImageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductID': productId,
      'CategoryID': categoryId,
      'Name': name,
      'Description': description,
      'Price': price,
      'Stock': stock,
      'ImageURL': imageUrl,
    };
  }

  Map<String, dynamic> toJsonForCreate() {
    return {
      'CategoryID': categoryId,
      'Name': name,
      'Description': description,
      'Price': price,
      'Stock': stock,
      'ImageURL': imageUrl,
    };
  }

  ProductModel copyWith({
    int? productId,
    int? categoryId,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
