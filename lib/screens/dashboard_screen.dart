import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import '../database/trash_db_helper.dart';
import 'trash_form_screen.dart';
import 'trash_detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> _filteredReports = []; 
  double _totalWeight = 0;
  int _totalEarnings = 0;
  // Menambahkan TextEditingController untuk Search Bar agar bisa di-clear jika perlu
  final TextEditingController _searchController = TextEditingController();

  // --- [READ]: Memuat data dari database ---
  void _loadData() async {
    List<Map<String, dynamic>> data;

    if (kIsWeb) {
      // Logika Data Dummy untuk Chrome
      data = [
        {
          'id': 1,
          'type': 'Plastik',
          'weight': 2.5,
          'price': 7500,
          'note': 'Botol bekas',
          'date': DateTime.now().toIso8601String()
        },
        {
          'id': 2,
          'type': 'Kertas',
          'weight': 5.0,
          'price': 10000,
          'note': 'Koran lama',
          'date': DateTime.now().toIso8601String()
        },
        {
          'id': 3,
          'type': 'Logam',
          'weight': 1.5,
          'price': 15000,
          'note': 'Kaleng soda',
          'date': DateTime.now().toIso8601String()
        },
      ];
    } else {
      // Logika Database Asli untuk Android/iOS
      data = await TrashDbHelper.getTrashReports();
    }

    double tWeight = 0;
    int tEarnings = 0;

    for (var item in data) {
      tWeight += (item['weight'] as num).toDouble();
      tEarnings += (item['price'] as num).toInt();
    }

    if (mounted) {
      setState(() {
        _reports = data;
        // Tetap jalankan filter agar saat search teks tidak hilang list tidak nge-reset
        _filterSearch(_searchController.text); 
        _totalWeight = tWeight;
        _totalEarnings = tEarnings;
      });
    }
  }

  // --- [FILTER]: Fungsi Pencarian ---
  void _filterSearch(String query) {
    setState(() {
      _filteredReports = _reports
          .where((item) => item['type']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- [DELETE]: Logika penghapusan data ---
  void _deleteData(int id) async {
    if (!kIsWeb) {
      await TrashDbHelper.deleteTrash(id);
    } else {
      // Simulasi hapus di web (hanya menghapus dari list lokal sementara)
      _reports.removeWhere((element) => element['id'] == id);
    }
    _loadData(); 
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil dihapus")),
      );
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoTrash Dashboard"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterSearch(value),
              decoration: InputDecoration(
                hintText: "Cari jenis sampah...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear), 
                      onPressed: () {
                        _searchController.clear();
                        _filterSearch("");
                      }) 
                  : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Riwayat Setoran",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadData(),
              child: _filteredReports.isEmpty
                  ? const Center(child: Text("Data tidak ditemukan."))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: _filteredReports.length,
                      itemBuilder: (context, index) {
                        final item = _filteredReports[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.recycling, color: Colors.white)
                            ),
                            title: Text("${item['type']} (${item['weight']} kg)", 
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("Rp ${item['price']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrashFormScreen(data: item)),
                                  ).then((_) => _loadData()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showDeleteDialog(item['id']),
                                ),
                              ],
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrashDetailScreen(data: item)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrashFormScreen()),
        ).then((_) => _loadData()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryColumn("Total Berat", "${_totalWeight.toStringAsFixed(1)} KG"),
          _summaryColumn("Total Saldo", "Rp $_totalEarnings"),
        ],
      ),
    );
  }

  Widget _summaryColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Hapus Setoran?"),
        content: const Text("Data yang dihapus tidak dapat dikembalikan."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _deleteData(id);
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}