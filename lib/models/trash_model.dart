class TrashModel {
  final int? id;
  final String type;
  final double weight;
  final int price;
  final String note;
  final String date;

  TrashModel({
    this.id,
    required this.type,
    required this.weight,
    required this.price,
    required this.note,
    required this.date,
  });

  // 1. Fungsi untuk mengubah data dari Map (Database) ke Object Flutter
  factory TrashModel.fromMap(Map<String, dynamic> map) {
    return TrashModel(
      id: map['id'],
      type: map['type'] ?? '',
      weight: (map['weight'] as num).toDouble(), // Memastikan jadi double
      price: map['price'] ?? 0,
      note: map['note'] ?? '',
      date: map['date'] ?? '',
    );
  }

  // 2. Fungsi untuk mengubah Object Flutter ke Map (untuk simpan ke Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'weight': weight,
      'price': price,
      'note': note,
      'date': date,
    };
  }
}