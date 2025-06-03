import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    String? categoryId,
    String? description,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default(0) int preparationTime,
    @Default(0) int stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

extension ProductBackendJson on Product {
  Map<String, dynamic> toJsonBackend() => {
    'id': id,
    'name': name,
    'price': price,
    'category_id': categoryId,
    'description': description,
    'imageUrl': imageUrl,
    'is_active': isAvailable,
    'preparationTime': preparationTime,
    'stock': stock,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
} 