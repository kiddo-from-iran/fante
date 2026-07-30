class BusLocation {
  BusLocation({
    required this.id,
    this.latitude,
    this.longitude,
    this.busId,
  });

  final int id;
  final double? latitude;
  final double? longitude;
  final int? busId;

  factory BusLocation.fromJson(Map<String, dynamic> json) {
    return BusLocation(
      id: json['id'] as int? ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      busId: json['bus'] as int? ?? json['bus_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'bus': busId,
      };
}
