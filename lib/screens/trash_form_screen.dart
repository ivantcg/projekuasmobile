import 'package:flutter/material.dart';
import '../database/trash_db_helper.dart';

class TrashFormScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const TrashFormScreen({
    super.key,
    this.data,
  });

  @override
  State<TrashFormScreen> createState() => _TrashFormScreenState();
}

class _TrashFormScreenState extends State<TrashFormScreen> {
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedType = 'Plastik';

  // Harga per KG
  final Map<String, int> _priceList = {
    'Plastik': 3000,
    'Kertas': 2000,
    'Logam': 5000,
    'Organik': 1000,
  };

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _selectedType = widget.data!['type'] ?? 'Plastik';
      _weightController.text = widget.data!['weight'].toString();
      _noteController.text = widget.data!['note'] ?? '';
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    final weight = double.tryParse(_weightController.text);

    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan berat sampah yang valid')),
      );
      return;
    }

    final totalPrice =
        (weight * (_priceList[_selectedType] ?? 0)).toInt();

    if (widget.data == null) {
      // INSERT
      await TrashDbHelper.insertTrash(
        type: _selectedType,
        weight: weight,
        price: totalPrice,
        note: _noteController.text,
      );
    } else {
      // UPDATE
      await TrashDbHelper.updateTrash(
        id: widget.data!['id'],
        type: _selectedType,
        weight: weight,
        price: totalPrice,
        note: _noteController.text,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setor Sampah'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration:
                  const InputDecoration(labelText: 'Jenis Sampah'),
              items: _priceList.keys
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),

            TextField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Berat (KG)',
                suffixText: 'kg',
              ),
            ),

            TextField(
              controller: _noteController,
              decoration:
                  const InputDecoration(labelText: 'Catatan'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'SIMPAN SETORAN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
