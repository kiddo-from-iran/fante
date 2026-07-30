class Driver {
  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.isActive = true,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final bool isActive;

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name']?.toString() ?? json['firstName']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'is_active': isActive,
      };
}
