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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryID': categoryId,
      'CategoryName': categoryName,
      'Description': description,
    };
  }
}
