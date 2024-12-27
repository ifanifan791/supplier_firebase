import 'package:flutter/material.dart';

class InventoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('List of all inventory items goes here.'),
      ),
    );
  }
}
