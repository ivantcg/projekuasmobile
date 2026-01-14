import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk menangkap input teks
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  // GlobalKey untuk validasi form sesuai materi freeCodeCamp
  final _formKey = GlobalKey<FormState>();

  // Fungsi proses Login
  void _login() async {
    // 1. Validasi apakah TextField sudah terisi sesuai aturan validator
    if (_formKey.currentState!.validate()) {
      
      // 2. Logika login lokal (Username: admin, Pass: 1234)
      if (_userController.text == "admin" && _passController.text == "1234") {
        
        // 3. Menyimpan sesi ke SharedPreferences (Persistensi Data)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', _userController.text);
        
        if (mounted) {
          // Memberikan feedback sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Berhasil! Selamat Datang."),
              backgroundColor: Colors.green,
            ),
          );

          // 4. Navigasi ke Dashboard menggunakan pushReplacement
          // Ini mencegah user kembali ke layar login saat menekan tombol back
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const DashboardScreen())
          );
        }
      } else {
        // Tampilkan pesan jika kredensial salah
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username atau Password Salah!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan tema warna aplikasi
      appBar: AppBar(
        title: const Text("Login EcoTrash"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Mendaftarkan GlobalKey untuk validasi
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Identitas Visual Aplikasi
                const SizedBox(height: 20),
                const Text(
                  "Selamat Datang Kembali",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                
                // Input Username dengan validasi
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap masukkan username Anda';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                
                // Input Password dengan obscureText
                TextFormField(
                  controller: _passController,
                  obscureText: true, 
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap masukkan password Anda';
                    }
                    if (value.length < 4) {
                      return 'Password minimal 4 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                
                // Tombol Login (ElevatedButton)
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "MASUK",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Membersihkan controller untuk menghindari kebocoran memori
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }
}