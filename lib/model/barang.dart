class Barang {
  int id;
  String name;
  String description;
  double price;
  int stock;
  String category;
  String imagePath;
  String supplier;

  Barang({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imagePath,
    required this.supplier,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'imagePath': imagePath,
      'supplier': supplier,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      stock: map['stock'],
      category: map['category'],
      imagePath: map['imagePath'],
      supplier: map['supplier'],
    );
  }
}