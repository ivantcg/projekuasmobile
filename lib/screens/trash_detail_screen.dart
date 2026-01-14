import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrashDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const TrashDetailScreen({
    super.key,
    required this.data,
  });

  // Helper membuka aplikasi eksternal (WA, Maps, Browser)
  Future<void> _openExternalApp(String url) async {
    final uri = Uri.parse(url);

    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success) {
      debugPrint('Gagal membuka URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final weight = (data['weight'] ?? 0).toString();
    final price = data['price'] ?? 0;
    final date = data['date'] != null
        ? data['date'].toString().substring(0, 10)
        : '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Setoran'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD DETAIL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.eco_rounded,
                      size: 80, color: Colors.green),
                  const SizedBox(height: 10),
                  const Text(
                    'Setoran Berhasil!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(height: 30),

                  _rowDetail('ID Transaksi', '#TRSH-${data['id'] ?? '0'}'),
                  _rowDetail('Kategori', data['type'] ?? '-'),
                  _rowDetail('Berat Netto', '$weight KG'),
                  _rowDetail('Total Harga', 'Rp $price'),
                  _rowDetail('Tanggal', date),

                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Catatan: ${data['note'] ?? '-'}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // TOMBOL AKSI
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openExternalApp(
                      'https://wa.me/628123456789',
                    ),
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Tanya Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check),
                    label: const Text('Selesai'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // TIPS
            const Card(
              color: Color(0xFFE8F5E9),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tips: Pastikan sampah dalam keadaan kering untuk harga yang lebih maksimal.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
