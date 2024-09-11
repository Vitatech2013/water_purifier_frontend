class SalesResponse {
  final int status;
  final String message;
  final List<Record> data;

  SalesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SalesResponse.fromJson(Map<String, dynamic> json) {
    return SalesResponse(
      status: json['status'],
      message: json['message'],
      data:json['data'] != null? (json['data'] as List<dynamic>)
          .map((item) => Record.fromJson(item as Map<String, dynamic>))
          .toList():json["data"]??[],
    );
  }
}

class Record {
  final String id;
  final User? user;
  final List<Product> products;
  final DateTime createdAt;
  final DateTime updatedAt;

  Record({
    required this.id,
    this.user,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      products: (json['products'] as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Product {
  final ProductDetails? product;
  final DateTime saleDate;
  final DateTime warrantyExpiry;
  final double salePrice;
  final double discountPercentage;
  final String id;
  final List<Service> services;

  Product({
    this.product,
    required this.saleDate,
    required this.warrantyExpiry,
    required this.salePrice,
    required this.discountPercentage,
    required this.id,
    required this.services,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product: json['product'] != null
          ? ProductDetails.fromJson(json['product'])
          : null,
      saleDate: DateTime.parse(json['saleDate']),
      warrantyExpiry: DateTime.parse(json['warrantyExpiry']),
      salePrice: json['salePrice'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      id: json['_id'],
      services: (json['services'] as List<dynamic>)
          .map((item) => Service.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductDetails {
  final String id;
  final String productName;
  final double productPrice;
  final String productImg;
  final int warranty;
  final String warrantyType;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDetails({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productImg,
    required this.warranty,
    required this.warrantyType,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['_id'],
      productName: json['productName'],
      productPrice: json['productPrice'].toDouble(),
      productImg: json['productImg'],
      warranty: json['warranty'],
      warrantyType: json['warrantyType'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Service {
  final ServiceType? serviceType;
  final DateTime? serviceDate;
  final double? servicePrice;
  final String? id;

  Service({
    required this.serviceType,
    required this.serviceDate,
    required this.servicePrice,
    required this.id,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceType: json['serviceType'] != null
          ? ServiceType.fromJson(json['serviceType'] as Map<String, dynamic>)
          : null, // Handle null serviceType
      serviceDate: json['serviceDate'] != null
          ? DateTime.tryParse(json['serviceDate'])
          : null, // Handle null or invalid date
      servicePrice: json['servicePrice'] != null
          ? (json['servicePrice'] as num).toDouble()
          : null, // Handle null servicePrice
      id: json['_id'] ?? null, // Handle null id
    );
  }
}


class ServiceType {
  final String id;
  final String name;
  final String description;
  final double price;

  ServiceType({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}

class User {
  final String id;
  final String name;
  final String mobile;

  User({
    required this.id,
    required this.name,
    required this.mobile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      mobile: json['mobile'],
    );
  }
}
