class Supplier {
  int id;
  String name;
  String address;
  int contact;
  double latitude;
  double longitude;

  Supplier({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contact': contact,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'] ?? 0, 
      name: map['name'] ?? '', 
      address: map['address'] ?? '', 
      contact: map['contact'] ?? 0, 
      latitude: (map['latitude'] != null) ? map['latitude'].toDouble() : 0.0, 
      longitude: (map['longitude'] != null) ? map['longitude'].toDouble() : 0.0, 
    );
  }
}
