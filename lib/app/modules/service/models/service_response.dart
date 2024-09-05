class ServiceResponse {
  final String id;
  final String name;
  final String description;
  final int price;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
