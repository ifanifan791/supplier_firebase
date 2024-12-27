import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'package:suplier_api/model/supplier.dart';

class AddSupplierPage extends StatefulWidget {
  @override
  _AddSupplierPageState createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  // Method to launch Google Maps using the URL Launcher
  Future<void> _openGoogleMaps() async {
    final latitude = _latitudeController.text.trim();
    final longitude = _longitudeController.text.trim();

    if (latitude.isEmpty || longitude.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid coordinates')),
      );
      return;
    }

    final String mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (!await launchUrl(Uri.parse(mapsUrl), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $mapsUrl';
    }
  }

  void _saveSupplier() async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      // Generate the new supplier ID
      int lastId = await FirebaseHelper().getLastSupplierId();

      final supplier = Supplier(
        id: lastId + 1,
        name: _nameController.text,
        address: _addressController.text,
        contact: int.parse(_contactController.text),
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
      );

      await FirebaseHelper().addSuppliers(supplier);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supplier added successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving supplier: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Supplier'),
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
                    'Supplier Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Supplier Name',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _contactController,
                    decoration: InputDecoration(
                      labelText: 'Contact',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _latitudeController,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                      prefixIcon: Icon(Icons.map),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _longitudeController,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      prefixIcon: Icon(Icons.map_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _openGoogleMaps, // Open Google Maps when clicked
                    child: Text('Open Google Maps'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveSupplier,
                    child: Text('Save Supplier'),
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
