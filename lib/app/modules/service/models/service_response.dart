class ServiceResponse {
  final int status;
  final String message;
  final List<Data> data;  // Updated to List<Data>

  ServiceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  ServiceResponse copyWith({
    int? status,
    String? message,
    List<Data>? data, // Updated to List<Data>
  }) =>
      ServiceResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ServiceResponse.fromJson(Map<String, dynamic> json) => ServiceResponse(
    status: json["status"],
    message: json["message"],
    // Parsing list of services
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())), // Convert list to JSON
  };
}
class Data {
  final String serviceName;
  final int servicePrice;
  final String serviceDescription;
  final String ownerId;
  final String status;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Data({
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDescription,
    required this.ownerId,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  Data copyWith({
    String? serviceName,
    int? servicePrice,
    String? serviceDescription,
    String? ownerId,
    String? status,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      Data(
        serviceName: serviceName ?? this.serviceName,
        servicePrice: servicePrice ?? this.servicePrice,
        serviceDescription: serviceDescription ?? this.serviceDescription,
        ownerId: ownerId ?? this.ownerId,
        status: status ?? this.status,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    serviceName: json["serviceName"],
    servicePrice: json["servicePrice"],
    serviceDescription: json["serviceDescription"],
    ownerId: json["ownerId"],
    status: json["status"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "serviceName": serviceName,
    "servicePrice": servicePrice,
    "serviceDescription": serviceDescription,
    "ownerId": ownerId,
    "status": status,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
