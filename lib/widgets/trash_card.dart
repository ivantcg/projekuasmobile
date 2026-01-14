import 'package:flutter/material.dart';

class TrashCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TrashCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Logika warna berdasarkan tipe sampah
    Color getCategoryColor() {
      switch (data['type'].toString().toLowerCase()) {
        case 'plastik': return Colors.blue.shade400;
        case 'kertas': return Colors.orange.shade400;
        case 'logam': return Colors.grey.shade600;
        case 'organik': return Colors.green.shade400;
        default: return Colors.indigo;
      }
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell( // InkWell memberikan efek riak (ripple) saat ditekan
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Bagian Ikon dengan Warna Kategori
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: getCategoryColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.recycling_rounded,
                  color: getCategoryColor(),
                  size: 35,
                ),
              ),
              const SizedBox(width: 15),
              
              // Bagian Informasi Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['type'] ?? "Kategori",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.monitor_weight_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${data['weight']} kg", style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 12),
                        const Icon(Icons.payments_outlined, size: 14, color: Colors.green),
                        const SizedBox(width: 4),
                        Text("Rp ${data['price']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),

              // Tombol Aksi Hapus
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}