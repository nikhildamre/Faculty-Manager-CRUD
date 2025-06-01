class Faculty {
  final String id;
  final String name;
  final String email;
  final String dateOfBirth;
  final String contact;
  final String department;
  final String designation;
  final String address;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.contact,
    required this.department,
    required this.designation,
    required this.address,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      contact: json['contact'],
      department: json['department'],
      designation: json['designation'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'date_of_birth': dateOfBirth,
        'contact': contact,
        'department': department,
        'designation': designation,
        'address': address,
      };

  // ✅ This fixes the 'copyWith' error
  Faculty copyWith({
    String? name,
    String? email,
    String? dateOfBirth,
    String? contact,
    String? department,
    String? designation,
    String? address,
  }) {
    return Faculty(
      id: id, // Keep same ID
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      contact: contact ?? this.contact,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      address: address ?? this.address,
    );
  }
}
