import 'package:flutter/material.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'package:suplier_api/model/supplier.dart';
import 'package:suplier_api/supplier/SupplierDetailScreen.dart';
import 'SupplierFormScreen.dart';


class SupplierListScreen extends StatefulWidget {
  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  late Future<List<Supplier>> _suppliers;

  @override
  void initState() {
    super.initState();
    _suppliers = FirebaseHelper().getSuppliers(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Supplier>>(
        future: _suppliers, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No suppliers found.'));
          }

          final suppliers = snapshot.data ?? [];
          return ListView.builder(
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4.0,
                child: ListTile(
                  title: Text(supplier.name),
                  subtitle: Text('Address: ${supplier.address}\nContact: ${supplier.contact}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupplierDetailPage(
                          supplierId: supplier.id, 
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSupplierPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
