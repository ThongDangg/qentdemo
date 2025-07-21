class CustomerInfo {
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String? address;
  final Map<String, dynamic>? additionalInfo;

  CustomerInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    this.address,
    this.additionalInfo,
  });

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'gender': gender,
    'address': address,
    'additionalInfo': additionalInfo ?? {},
  };

  factory CustomerInfo.fromMap(Map<String, dynamic> map) => CustomerInfo(
    fullName: map['fullName'] ?? '',
    email: map['email'] ?? '',
    phone: map['phone'] ?? '',
    gender: map['gender'] ?? '',
    address: map['address'],
    additionalInfo: map['additionalInfo'],
  );
}
