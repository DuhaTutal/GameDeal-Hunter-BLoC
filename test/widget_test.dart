import 'package:flutter_test/flutter_test.dart';
import 'package:game_deal/main.dart';
import 'package:game_deal/data/repositories/deal_repository.dart';
import 'package:game_deal/data/services/api_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Test için gerekli servis ve repository'leri oluşturuyoruz
    final apiService = ApiService();
    final dealRepository = DealRepository(apiService);

    // Uygulamayı başlatıyoruz
    await tester.pumpWidget(MyApp(dealRepository: dealRepository));

    // Ana sayfa başlığının (🎮 Game Library) ekranda olup olmadığını kontrol ediyoruz
    expect(find.text('🎮 Game Library'), findsOneWidget);
  });
}
