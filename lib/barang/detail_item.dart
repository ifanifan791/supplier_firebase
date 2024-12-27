import 'package:flutter/material.dart';
import 'package:suplier_api/model/barang.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'dart:io';
import 'package:suplier_api/model/history_stok.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  ItemDetailPage({required this.itemId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late Future<Barang?> _item;
  int? _stockChange;
  String? _stockType;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _item = FirebaseHelper().getItemById(widget.itemId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Detail Item', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // Tampilkan dialog konfirmasi
              bool? confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Konfirmasi Hapus'),
                    content:
                        Text('Apakah Anda yakin ingin menghapus item ini?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Batal'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Hapus'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              // Jika pengguna mengkonfirmasi, lakukan penghapusan
              if (confirmDelete == true) {
                await FirebaseHelper().deleteItem(widget.itemId.toString());
                Navigator.of(context).pop(); 
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Barang?>(
        future: _item,
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

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.file(
                    File(item.imagePath),
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  item.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(item.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Suplier: ', style: TextStyle(fontSize: 16)),
                            Text('${item.supplier}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text('Kategori: ', style: TextStyle(fontSize: 16)),
                            Text('${item.category}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text('Harga: ', style: TextStyle(fontSize: 16)),
                            Text('Rp. ${item.price}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text('Stok Saat Ini: ',
                                style: TextStyle(fontSize: 16)),
                            Text('${item.stock}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Divider(),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Jenis Stok',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                                value: 'Masuk', child: Text('Masuk')),
                            DropdownMenuItem(
                                value: 'Keluar', child: Text('Keluar')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _stockType = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Jumlah Stok',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _stockChange = int.tryParse(value);
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _selectedDate = selectedDate;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (_stockChange != null &&
                                _stockType != null &&
                                _selectedDate != null) {
                              if (_stockType == 'Keluar' &&
                                  _stockChange! > item.stock) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Stok tidak mencukupi untuk pengurangan')),
                                );
                                return;
                              }
                              int newStock = _stockType == 'Masuk'
                                  ? item.stock + _stockChange!
                                  : item.stock - _stockChange!;

                              await FirebaseHelper().updateStock(
                                widget.itemId.toString(),
                                newStock,
                              );
                              await FirebaseHelper().addHistoryStok(
                                HistoryStok(
                                  itemId: widget.itemId,
                                  jenis: _stockType!,
                                  jumlah: _stockChange!,
                                  tanggal: _selectedDate!,
                                ),
                              );

                              setState(() {
                                _item = FirebaseHelper()
                                    .getItemById(widget.itemId.toString());
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Harap lengkapi semua input')),
                              );
                            }
                          },
                          child: Text('Simpan Stok'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Riwayat Stok',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                FutureBuilder<List<HistoryStok>>(
                  future:
                      FirebaseHelper().getHistoryStokByItemId(widget.itemId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final historyStok = snapshot.data;

                    if (historyStok == null || historyStok.isEmpty) {
                      return Center(child: Text('Tidak ada riwayat'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: historyStok.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 1,
                          child: ListTile(
                            leading: Icon(
                              historyStok[index].jenis == 'Masuk'
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: historyStok[index].jenis == 'Masuk'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(
                              historyStok[index].jenis,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Jumlah: ${historyStok[index].jumlah} - Tanggal: ${historyStok[index].tanggal.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
