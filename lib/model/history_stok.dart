class HistoryStok {
  int? id;
  int itemId;
  String jenis;
  int jumlah;
  DateTime tanggal;

  HistoryStok({
    this.id,
    required this.itemId,
    required this.jenis,
    required this.jumlah,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_id': itemId,
      'jenis': jenis,
      'jumlah': jumlah,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  factory HistoryStok.fromMap(Map<String, dynamic> map) {
    return HistoryStok(
      id: map['id'],
      itemId: map['item_id'],
      jenis: map['jenis'],
      jumlah: map['jumlah'],
      tanggal: DateTime.parse(map['tanggal']),
    );
  }
}