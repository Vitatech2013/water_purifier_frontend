class TechnicianResponse {
    final String id;
    final String name;
    final String email;
    final String password;
    final String ownerId;
    final String role;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;

    TechnicianResponse({
        required this.id,
        required this.name,
        required this.email,
        required this.password,
        required this.ownerId,
        required this.role,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    TechnicianResponse copyWith({
        String? id,
        String? name,
        String? email,
        String? password,
        String? ownerId,
        String? role,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
    }) => 
        TechnicianResponse(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            password: password ?? this.password,
            ownerId: ownerId ?? this.ownerId,
            role: role ?? this.role,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
        );

    factory TechnicianResponse.fromJson(Map<String, dynamic> json) => TechnicianResponse(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        ownerId: json["ownerId"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "ownerId": ownerId,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}