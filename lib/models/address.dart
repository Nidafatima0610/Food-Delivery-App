class Address {
  final String id;
  final String label;
  final String addressLine;
  final String contactNumber;
  final String instructions;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.contactNumber,
    this.instructions = '',
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'addressLine': addressLine,
    'contactNumber': contactNumber,
    'instructions': instructions,
    'isDefault': isDefault,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    label: json['label'],
    addressLine: json['addressLine'],
    contactNumber: json['contactNumber'],
    instructions: json['instructions'] ?? '',
    isDefault: json['isDefault'] ?? false,
  );
}
