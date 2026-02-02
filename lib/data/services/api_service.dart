import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'User-Agent': 'FlutterGameApp/1.0', // Bazı API'ler boş User-Agent'ı bloklar
    },
  ));

  Future<dynamic> _safeGet(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    int retryCount = 0;
    const int maxRetries = 3; // Retry sayısını artırdık

    while (retryCount <= maxRetries) {
      try {
        final response = await _dio.get(endpoint, queryParameters: queryParameters);
        return response.data;
      } on DioException catch (e) {
        if (e.response?.statusCode == 429 && retryCount < maxRetries) {
          retryCount++;
          // Daha uzun bir bekleme süresi (4sn, 8sn, 12sn...)
          await Future.delayed(Duration(seconds: retryCount * 4));
          continue;
        }
        rethrow;
      }
    }
  }

  Future<List<dynamic>> getDeals({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _safeGet(AppConstants.dealsEndpoint, queryParameters: queryParameters);
      return data as List<dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw Exception('API limiti aşıldı. Lütfen 1 dakika sonra tekrar deneyin.');
      }
      throw Exception('Fırsatlar getirilemedi: ${e.message}');
    }
  }

  Future<List<dynamic>> getStores() async {
    try {
      final data = await _safeGet(AppConstants.storesEndpoint);
      return data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Mağazalar yüklenemedi');
    }
  }

  Future<Map<String, dynamic>> getGameLookup(String gameId) async {
    try {
      final data = await _safeGet('/games', queryParameters: {'id': gameId});
      return data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Oyun detayı bulunamadı');
    }
  }
}
