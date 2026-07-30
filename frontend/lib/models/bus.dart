class Bus {
  Bus({
    required this.id,
    this.identifier,
    this.model,
    this.year = '',
    this.capacity = 0,
    this.status,
    this.code,
  });

  final int id;
  final String? identifier;
  final String? model;
  final String year;
  final int capacity;
  final String? status;
  final String? code;

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'] as int? ?? 0,
      identifier: json['identifier']?.toString(),
      model: json['model']?.toString(),
      year: json['year']?.toString() ?? '',
      capacity: json['capacity'] as int? ?? 0,
      status: json['status']?.toString(),
      code: json['code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'identifier': identifier,
        'model': model,
        'year': year,
        'capacity': capacity,
        'status': status,
        'code': code,
      };
}
