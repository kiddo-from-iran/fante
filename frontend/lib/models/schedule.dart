class Schedule {
  Schedule({
    required this.id,
    this.bus,
    this.route,
    this.service,
    this.startTime,
    this.endTime,
  });

  final int id;
  final dynamic bus;
  final dynamic route;
  final String? service;
  final String? startTime;
  final String? endTime;

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as int? ?? 0,
      bus: json['bus'],
      route: json['route'],
      service: json['service']?.toString(),
      startTime: json['start_time']?.toString() ?? json['startTime']?.toString(),
      endTime: json['end_time']?.toString() ?? json['endTime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bus': bus,
        'route': route,
        'service': service,
        'start_time': startTime,
        'end_time': endTime,
      };

  @override
  String toString() => service ?? 'Schedule #$id';
}
