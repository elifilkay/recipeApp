import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipes_app/main.dart';  // RecipeApp widget'ını buradan import etmelisiniz.

void main() {
  testWidgets('Tarif Bulucu App Başlangıç Testi', (WidgetTester tester) async {
    // Uygulamayı başlat ve bir frame tetikle.
    await tester.pumpWidget(const RecipeApp()); // MyApp yerine RecipeApp

    // Başlangıçta HomeScreen ya da LoginScreen'in olup olmadığını kontrol et.
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // Uygulama beklerken bir loading spinner'ı göstermeli.
  });
}
