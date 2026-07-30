class Stop {
  Stop({
    required this.id,
    this.name,
    this.address = '',
    this.code = '',
    this.latitude = '',
    this.longitude = '',
  });

  final int id;
  final String? name;
  final String address;
  final String code;
  final String latitude;
  final String longitude;

  factory Stop.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final coordinates = location?['coordinates'] as List<dynamic>?;

    return Stop(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString(),
      address: json['address']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      latitude: json['latitude']?.toString() ??
          (coordinates != null && coordinates.length > 1
              ? coordinates[1].toString()
              : ''),
      longitude: json['longitude']?.toString() ??
          (coordinates != null && coordinates.isNotEmpty
              ? coordinates[0].toString()
              : ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'code': code,
        'latitude': latitude,
        'longitude': longitude,
      };
}
