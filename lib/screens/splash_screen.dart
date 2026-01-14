import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // Fungsi untuk mengecek sesi login
  Future<void> _checkSession() async {
    // Memberikan delay 3 detik agar animasi splash terlihat
    await Future.delayed(const Duration(seconds: 3));
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (mounted) {
      if (isLoggedIn) {
        // Jika sudah login, langsung ke Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        // Jika belum, arahkan ke halaman Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Aplikasi
            const Icon(Icons.recycling, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "ECO TRASH",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.green
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}