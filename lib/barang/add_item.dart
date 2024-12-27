import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suplier_api/model/barang.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'package:suplier_api/model/category.dart';
import 'package:suplier_api/model/supplier.dart';
import 'package:suplier_api/barang/dashboard_screen.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSupplier;
  XFile? _imageFile;

  final _picker = ImagePicker();
  List<Category> _categories = [];
  List<Supplier> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getSuppliers();
  }

  Future<void> _getCategories() async {
    final categories = await FirebaseHelper().getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _getSuppliers() async {
    final suppliers = await FirebaseHelper().getSuppliers();
    setState(() {
      _suppliers = suppliers;
    });
  }

  void _pickImage() async {
    // Show a bottom sheet or dialog to choose between gallery or camera
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  _imageFile = pickedFile;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Pick from gallery'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _imageFile = pickedFile;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _saveItem() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedSupplier == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and pick an image')),
      );
      return;
    }

    try {
      // Mendapatkan ID terakhir dari database
      int lastId = await FirebaseHelper().getLastItemId();

      final item = Barang(
        id: lastId + 1,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        category: _selectedCategory!,
        supplier: _selectedSupplier!,
        imagePath: _imageFile!.path,
      );

      await FirebaseHelper().addItem(item);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added successfully!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ItemListPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Item Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller:
                        _stockController, // Menggunakan controller untuk menangani input
                    keyboardType:
                        TextInputType.number, // Menetapkan input hanya angka
                    decoration: InputDecoration(
                      labelText: 'Stock', // Label untuk input
                      prefixIcon: Icon(Icons.shopping_bag_outlined), // Ikon untuk input
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price (Rp)',
                      prefixIcon: Icon(Icons.monetization_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedCategory,
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category.name,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Supplier',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedSupplier,
                    items: _suppliers.map((supplier) {
                      return DropdownMenuItem(
                        value: supplier.name,
                        child: Text(supplier.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplier = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text(
                        _imageFile == null ? 'Pick Image' : 'Change Image'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: Text('Save Item'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
