import 'package:flutter/material.dart';
import 'package:suplier_api/db/db_helper.dart';
import 'package:suplier_api/model/history_stok.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock History'),
      ),
      body: FutureBuilder<List<HistoryStok>>(
        future: FirebaseHelper().getAllHistoryStok(), // Ambil semua riwayat
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
            itemCount: historyStok.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 1,
                child: ListTile(
                  leading: Icon(
                    historyStok[index].jenis == 'Keluar'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: historyStok[index].jenis == 'Masuk'
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(
                    historyStok[index].jenis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
    );
  }
}