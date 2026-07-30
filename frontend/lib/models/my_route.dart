class MyRoute {
  MyRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.estimatedTime,
    this.code = '',
    this.fare = 0,
    this.isActive = true,
    this.orderedStations = const [],
    this.round = false,
  });

  final int id;
  final String name;
  final String description;
  final num distance;
  final num estimatedTime;
  final String code;
  final num fare;
  final bool isActive;
  final List<RouteStation> orderedStations;
  final bool round;

  factory MyRoute.fromJson(Map<String, dynamic> json) {
    final stations = (json['ordered_stations'] as List<dynamic>?)
            ?.map(
              (e) => RouteStation.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const <RouteStation>[];

    return MyRoute(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      distance: json['distance'] as num? ?? 0,
      estimatedTime: json['estimated_time'] as num? ??
          json['estimatedTime'] as num? ??
          0,
      code: json['code']?.toString() ?? '',
      fare: json['fare'] as num? ?? 0,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      orderedStations: stations,
      round: json['round'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'distance': distance,
        'estimated_time': estimatedTime,
        'code': code,
        'fare': fare,
        'is_active': isActive,
        'ordered_stations': orderedStations.map((e) => e.toJson()).toList(),
        'round': round,
      };
}

class RouteStation {
  RouteStation({
    required this.stationId,
    required this.priority,
  });

  final int stationId;
  final int priority;

  factory RouteStation.fromJson(Map<String, dynamic> json) {
    return RouteStation(
      stationId: json['station_id'] as int? ?? json['stationId'] as int? ?? 0,
      priority: json['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'station_id': stationId,
        'priority': priority,
      };
}
