class SalesResponse {
  final int status;
  final String message;
  final List<Record> data;

  SalesResponse({required this.status, required this.message, required this.data});

  factory SalesResponse.fromJson(Map<String, dynamic> json) {
    return SalesResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => Record.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
class Record {
  final String id;
  final User user;
  final List<Product> products;
  final DateTime createdAt;
  final DateTime updatedAt;

  Record({
    required this.id,
    required this.user,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['_id'],
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}


class Product {
  final Map<String, dynamic>? product;
  final DateTime saleDate;
  final DateTime warrantyExpiry;
  final String id;
  final List<Service> services;

  Product({
    required this.product,
    required this.saleDate,
    required this.warrantyExpiry,
    required this.id,
    required this.services,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product: json['product'] as Map<String, dynamic>?,
      saleDate: DateTime.parse(json['saleDate']),
      warrantyExpiry: DateTime.parse(json['warrantyExpiry']),
      id: json['_id'],
      services: (json['services'] as List<dynamic>)
          .map((item) => Service.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}


class Service {
  final String serviceType;
  final DateTime serviceDate;
  final double servicePrice;
  final String id;

  Service({
    required this.serviceType,
    required this.serviceDate,
    required this.servicePrice,
    required this.id,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceType: json['serviceType'],
      serviceDate: DateTime.parse(json['serviceDate']),
      servicePrice: json['servicePrice'].toDouble(),
      id: json['_id'],
    );
  }
}


class User {
  final String name;
  final String mobile;

  User({
    required this.name,
    required this.mobile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      mobile: json['mobile'],
    );
  }
}

