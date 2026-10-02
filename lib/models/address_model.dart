class AddressItem {
  final String id;
  String label; // 'Home', 'Work', 'Other'
  String fullName;
  String phone;
  String houseNo;
  String area;
  String city;
  String state;
  String pincode;
  bool isDefault;

  AddressItem({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.houseNo,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });

  String get formattedAddress {
    final parts = <String>[];
    if (houseNo.isNotEmpty) parts.add(houseNo);
    if (area.isNotEmpty) parts.add(area);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (pincode.isNotEmpty) parts.add(pincode);
    return parts.join(', ');
  }

  String get fullDisplayText => '$label: $formattedAddress';

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'fullName': fullName,
        'phone': phone,
        'addressLine1': houseNo,
        'addressLine2': area,
        'city': city,
        'state': state,
        'zipCode': pincode,
        'country': 'India',
        'isDefault': isDefault,
      };

  factory AddressItem.fromJson(Map<String, dynamic> json) {
    return AddressItem(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      label: json['label'] ?? 'Home',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      houseNo: json['addressLine1'] ?? '',
      area: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? 'Delhi',
      pincode: json['zipCode'] ?? '',
      isDefault: json['isDefault'] == true || json['default'] == true,
    );
  }
}
