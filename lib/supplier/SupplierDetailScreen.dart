import 'package:flutter/material.dart';
import 'package:suplier_api/model/supplier.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierDetailPage extends StatefulWidget {
  final int supplierId;

  SupplierDetailPage({required this.supplierId});

  @override
  _SupplierDetailPageState createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage> {
  late Future<Supplier?> _supplier;

  @override
  void initState() {
    super.initState();
    _supplier = FirebaseHelper().getSupplierById(widget.supplierId.toString());
  }

  // Method to open Google Maps with the supplier's coordinates
  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final String mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (!await launchUrl(Uri.parse(mapsUrl), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $mapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier Details'),
      ),
      body: FutureBuilder<Supplier?>(
        future: _supplier,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final item = snapshot.data;

          if (item == null) {
            return Center(child: Text('Item tidak ditemukan'));
          }

          // Apply padding here
          return Padding(
            padding: const EdgeInsets.all(16.0),  // Add padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Supplier Name: ${item.name}',  // Display supplier's name
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Address: ${item.address}',  // Display supplier's address
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Contact: ${item.contact}',  // Display supplier's phone number
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => _openGoogleMaps(item.latitude, item.longitude),
                  child: Text('Open in Maps'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
