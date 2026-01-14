// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ivan/main.dart';

void main() {
  testWidgets('Eco Trash Initial Load Test', (WidgetTester tester) async {
    // Jalankan aplikasi dengan status login false (menuju LoginScreen)
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verifikasi apakah teks 'Login EcoTrash' atau 'Username' muncul
    // Ini membuktikan aplikasi berhasil terbuka tanpa crash
    expect(find.text('Login EcoTrash'), findsOneWidget);
  });
}

