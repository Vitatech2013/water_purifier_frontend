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
    try {
      return SalesResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null
            ? (json['data'] as List<dynamic>)
            .map((item) => Record.fromJson(item as Map<String, dynamic>))
            .toList()
            : [],
      );
    } catch (e) {
      // Handle the exception as needed, for example:
      return SalesResponse(status: 500, message: 'Error parsing sales response', data: []);
    }
  }
}

class Record {
  final String id;
  final User? user;
  final List<Product> products;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Sale>? sales; // New field added

  Record({
    required this.id,
    this.user,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
    this.sales, // New parameter added
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    try {
      return Record(
        id: json['_id'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        products: (json['products'] as List<dynamic>)
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        sales: json['sales'] != null
            ? (json['sales'] as List<dynamic>)
            .map((item) => Sale.fromJson(item as Map<String, dynamic>))
            .toList()
            : null,
      );
    } catch (e) {
      // Handle the exception as needed, for example:
      return Record(
        id: '',
        user: null,
        products: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sales: null,
      );
    }
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
    try {
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
    } catch (e) {
      // Handle the exception as needed, for example:
      return Product(
        product: null,
        saleDate: DateTime.now(),
        warrantyExpiry: DateTime.now(),
        salePrice: 0.0,
        discountPercentage: 0.0,
        id: '',
        services: [],
      );
    }
  }
}

class ProductDetails {
  final String id;
  final String productName;
  final double productPrice;
  final String productImg;
  final int? warranty;
  final String warrantyType;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDetails({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productImg,
    this.warranty,
    required this.warrantyType,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    try {
      return ProductDetails(
        id: json['_id'],
        productName: json['productName'],
        productPrice: json['productPrice'].toDouble(),
        productImg: json['productImg'],
        warranty: json['warranty'] != null ? json['warranty'] : null,
        warrantyType: json['warrantyType'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
    } catch (e) {
      // Handle the exception as needed, for example:
      return ProductDetails(
        id: '',
        productName: '',
        productPrice: 0.0,
        productImg: '',
        warranty: null,
        warrantyType: '',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
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
    try {
      return Service(
        serviceType: json['serviceType'] != null
            ? ServiceType.fromJson(json['serviceType'] as Map<String, dynamic>)
            : null,
        serviceDate: json['serviceDate'] != null
            ? DateTime.tryParse(json['serviceDate'])
            : null,
        servicePrice: json['servicePrice'] != null
            ? (json['servicePrice'] as num).toDouble()
            : null,
        id: json['_id'] ?? null,
      );
    } catch (e) {
      // Handle the exception as needed, for example:
      return Service(
        serviceType: null,
        serviceDate: null,
        servicePrice: null,
        id: null,
      );
    }
  }
}

class ServiceType {
  final String? id; // Nullable
  final String? serviceName; // Nullable
  final double servicePrice;
  final String? serviceDescription; // Nullable

  ServiceType({
    this.id, // Nullable
    this.serviceName, // Nullable
    required this.serviceDescription,
    required this.servicePrice,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    try {
      return ServiceType(
        id: json['_id'],
        serviceName: json['serviceName'] ?? '',
        serviceDescription: json['serviceDescription'] ?? '',
        servicePrice: json['servicePrice']?.toDouble() ?? 0.0,
      );
    } catch (e) {
      // Handle the exception as needed
      return ServiceType(
        id: '',
        serviceName: '',
        serviceDescription: '',
        servicePrice: 0.0,
      );
    }
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
    try {
      return User(
        id: json['_id'],
        name: json['name'],
        mobile: json['mobile'],
      );
    } catch (e) {
      // Handle the exception as needed, for example:
      return User(
        id: '',
        name: '',
        mobile: '',
      );
    }
  }
}

class Sale {
  final String id;
  final double totalAmount;
  final DateTime saleDate;
  final List<Service>? services; // Added field to hold services related to the sale

  Sale({
    required this.id,
    required this.totalAmount,
    required this.saleDate,
    this.services, // New parameter added
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    try {
      return Sale(
        id: json['_id'],
        totalAmount: json['totalAmount'].toDouble(),
        saleDate: DateTime.parse(json['saleDate']),
        services: json['services'] != null // Check if services are present
            ? (json['services'] as List<dynamic>)
            .map((item) => Service.fromJson(item as Map<String, dynamic>))
            .toList()
            : null, // Set to null if no services are present
      );
    } catch (e) {
      // Handle the exception as needed
      return Sale(
        id: '',
        totalAmount: 0.0,
        saleDate: DateTime.now(),
        services: null, // Default to null if there's an error
      );
    }
  }
}
