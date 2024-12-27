import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Digunakan untuk mengelola sesi pengguna
import 'login/login_page.dart'; // Pastikan Anda memiliki file ini untuk layar login
import 'barang/dashboard_screen.dart';
import 'supplier/SupplierListScreen.dart';

class DashboardScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    // Bersihkan sesi pengguna (misalnya, dengan SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigasi ke layar login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Konfirmasi sebelum logout
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Apakah Anda yakin ingin logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Ya'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                _logout(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Total Barang (Total Items) Section
            GestureDetector(
              onTap: () {
                // Navigate to Inventory List
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemListPage()),
                );
              },
              child: _buildCard(
                'Total Barang',
                Icons.inventory, // Ikon untuk barang
                'Items Available',
              ),
            ),

            SizedBox(height: 20.0),

            // Jumlah Supplier (Number of Suppliers) Section
            GestureDetector(
              onTap: () {
                // Navigate to Supplier List
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupplierListScreen()),
                );
              },
              child: _buildCard(
                'Jumlah Supplier',
                Icons.people, // Ikon untuk supplier
                'Suppliers Registered',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the card view
  Widget _buildCard(String title, IconData icon, String subtitle) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: double.infinity,
        child: Row(
          children: <Widget>[
            // Ikon di sisi kiri
            Icon(
              icon,
              size: 50.0,
              color: Colors.blueAccent,
            ),
            SizedBox(width: 20.0),
            // Teks di sisi kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
