import 'package:flutter/material.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'package:suplier_api/model/category.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Kategori'),
        backgroundColor: const Color.fromARGB(255, 250, 249, 250),
        elevation: 0,
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Kategori Baru',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Kategori',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.category),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama kategori tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Mendapatkan ID terakhir dari database
                          int lastId = await FirebaseHelper().getLastCategoryId();

                          final category = Category(
                            id: lastId + 1, // Menghasilkan ID baru
                            name: _categoryNameController.text,
                          );

                          await FirebaseHelper().addCategory(category);

                          // Kembali ke halaman sebelumnya setelah menambah kategori
                          Navigator.pop(context);
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('Simpan Kategori'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        foregroundColor:
                            const Color.fromARGB(255, 112, 11, 212),
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                      ),
                    ),
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