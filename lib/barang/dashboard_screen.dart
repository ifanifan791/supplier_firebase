import 'package:flutter/material.dart';
import 'package:suplier_api/model/barang.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'dart:io';
import 'package:suplier_api/barang/add_item.dart';
import 'package:suplier_api/barang/detail_item.dart';
import 'package:suplier_api/barang/add_category.dart';
import 'package:suplier_api/barang/all_histori.dart';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  late Future<List<Barang>> _items;

  @override
  void initState() {
    super.initState();
    _items = FirebaseHelper().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Barang'),
      ),
      body: FutureBuilder<List<Barang>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(item.imagePath),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '${item.category} - Rp ${item.price} - ${item.stock} - ${item.supplier}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailPage(itemId: item.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Tombol History
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryPage()), // Navigasi ke HistoryPage
              );
            },
            child: Icon(Icons.history),
            heroTag: null,
          ),
          SizedBox(height: 10), // Spasi antara tombol
          // Tombol Kategori
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              );
            },
            child: Icon(Icons.category),
            heroTag: null,
          ),
          SizedBox(height: 10), // Spasi antara tombol
          // Tombol Add Item
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItemPage()),
              );
            },
            child: Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
