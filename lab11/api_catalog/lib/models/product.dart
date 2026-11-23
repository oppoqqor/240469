import 'review.dart';

class Dimensions {
  const Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  final double width;
  final double height;
  final double depth;

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        depth: (json['depth'] as num).toDouble(),
      );
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.tags,
    required this.thumbnail,
    required this.dimensions,
    required this.reviews,
    this.brand,
    this.description = '',
    this.images = const [],
  });

  final int id;
  final String title;
  final double price;
  final double rating;
  final String? brand;
  final List<String> tags;
  final String thumbnail;
  final Dimensions dimensions;
  final List<Review> reviews;
  final String description;
  final List<String> images;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        title: json['title'] as String,
        price: (json['price'] as num).toDouble(),
        rating: (json['rating'] as num).toDouble(),
        brand: json['brand'] as String?,
        // Missing tags default to an empty list instead of throwing.
        tags: (json['tags'] as List?)?.cast<String>() ?? const [],
        thumbnail: json['thumbnail'] as String,
        dimensions: Dimensions.fromJson(
          json['dimensions'] as Map<String, dynamic>,
        ),
        reviews: (json['reviews'] as List? ?? const [])
            .map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList(),
        description: json['description'] as String? ?? '',
        images: (json['images'] as List?)?.cast<String>() ?? const [],
      );
}
