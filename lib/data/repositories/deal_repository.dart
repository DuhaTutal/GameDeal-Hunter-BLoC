import '../models/deal_model.dart';
import '../models/store_model.dart';
import '../services/api_service.dart';

class DealRepository {
  final ApiService _apiService;

  DealRepository(this._apiService);

  Future<List<DealModel>> getDeals({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _apiService.getDeals(queryParameters: queryParameters);
      return data.map((json) => DealModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// API isteği atmak yerine en popüler mağazaları statik olarak döndürüyoruz.
  /// Bu sayede "Too Many Requests" hatasından kurtuluyoruz.
  Future<List<StoreModel>> getStores() async {
    return [
      const StoreModel(storeID: '1', storeName: 'Steam', isActive: 1, images: {'icon': '/img/stores/icons/0.png'}),
      const StoreModel(storeID: '2', storeName: 'GamersGate', isActive: 1, images: {'icon': '/img/stores/icons/1.png'}),
      const StoreModel(storeID: '3', storeName: 'GreenManGaming', isActive: 1, images: {'icon': '/img/stores/icons/2.png'}),
      const StoreModel(storeID: '7', storeName: 'GOG', isActive: 1, images: {'icon': '/img/stores/icons/6.png'}),
      const StoreModel(storeID: '8', storeName: 'Origin', isActive: 1, images: {'icon': '/img/stores/icons/7.png'}),
      const StoreModel(storeID: '11', storeName: 'Humble Store', isActive: 1, images: {'icon': '/img/stores/icons/10.png'}),
      const StoreModel(storeID: '25', storeName: 'Epic Games Store', isActive: 1, images: {'icon': '/img/stores/icons/24.png'}),
      const StoreModel(storeID: '31', storeName: '2Game', isActive: 1, images: {'icon': '/img/stores/icons/30.png'}),
    ];
  }

  Future<Map<String, dynamic>> getGameDetails(String gameId) async {
    try {
      return await _apiService.getGameLookup(gameId);
    } catch (e) {
      rethrow;
    }
  }
}
