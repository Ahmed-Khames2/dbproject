class CategoryModel {
  final int categoryId;
  final String categoryName;
  final String? description;
  final String? imageUrl;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['CategoryID'],
      categoryName: json['CategoryName'],
      description: json['Description'],
      imageUrl: json['ImageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryID': categoryId,
      'CategoryName': categoryName,
      'Description': description,
      'ImageURL': imageUrl,
    };
  }

  Map<String, dynamic> toJsonForCreate() {
    return {
      'CategoryName': categoryName,
      'Description': description,
      'ImageURL': imageUrl,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'CategoryName': categoryName,
      'Description': description,
      'ImageURL': imageUrl,
    };
  }

  CategoryModel copyWith({
    int? categoryId,
    String? categoryName,
    String? description,
    String? imageUrl,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
