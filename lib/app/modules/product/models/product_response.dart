class ProductResponse {
  final int status;
  final String message;
  final List<Datum> data;

  ProductResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  ProductResponse copyWith({
    int? status,
    String? message,
    List<Datum>? data,
  }) =>
      ProductResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final String id;
  final String productName;
  final int productPrice;
  final String productImg;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final int? warranty;
  final String? warrantyType;

  Datum({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productImg,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.warranty,
    this.warrantyType,
  });

  Datum copyWith({
    String? id,
    String? productName,
    int? productPrice,
    String? productImg,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    int? warranty,
    String? warrantyType,
  }) =>
      Datum(
        id: id ?? this.id,
        productName: productName ?? this.productName,
        productPrice: productPrice ?? this.productPrice,
        productImg: productImg ?? this.productImg,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        warranty: warranty ?? this.warranty,
        warrantyType: warrantyType ?? this.warrantyType,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    productName: json["productName"],
    productPrice: json["productPrice"],
    productImg: json["productImg"],
    description: json["description"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    warranty: json["warranty"],
    warrantyType: json["warrantyType"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "productName": productName,
    "productPrice": productPrice,
    "productImg": productImg,
    "description": description,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "warranty": warranty,
    "warrantyType": warrantyType,
  };
}
