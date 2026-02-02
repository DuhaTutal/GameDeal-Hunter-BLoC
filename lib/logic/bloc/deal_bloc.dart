import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/deal_model.dart';
import '../../data/models/store_model.dart';
import '../../data/repositories/deal_repository.dart';
import 'deal_event.dart';
import 'deal_state.dart';

class DealBloc extends Bloc<DealEvent, DealState> {
  final DealRepository _dealRepository;
  List<StoreModel>? _cachedStores;

  DealBloc(this._dealRepository) : super(DealInitial()) {
    on<FetchDealsEvent>(_onFetchDeals);
    on<SearchDealsEvent>(_onSearchDeals);
  }

  Future<void> _onFetchDeals(FetchDealsEvent event, Emitter<DealState> emit) async {
    emit(DealLoading());
    try {
      _cachedStores ??= await _dealRepository.getStores();
      final Map<String, dynamic> params = Map.from(event.queryParameters ?? {});
      params.putIfAbsent('pageSize', () => 60);

      final allDeals = await _dealRepository.getDeals(queryParameters: params);
      final uniqueDeals = _getUniqueDeals(allDeals);
      
      emit(DealLoaded(deals: uniqueDeals, stores: _cachedStores!));
    } catch (e) {
      emit(DealError('Yükleme hatası: ${e.toString()}'));
    }
  }

  Future<void> _onSearchDeals(SearchDealsEvent event, Emitter<DealState> emit) async {
    emit(DealLoading());
    try {
      _cachedStores ??= await _dealRepository.getStores();
      
      final allDeals = await _dealRepository.getDeals(queryParameters: {
        'title': event.title,
        'pageSize': 50,
      });
      
      final filteredDeals = allDeals.where((deal) {
        final title = deal.title?.toLowerCase() ?? '';
        final query = event.title.toLowerCase();
        return title.contains(query);
      }).toList();
      
      final uniqueDeals = _getUniqueDeals(filteredDeals);
      emit(DealLoaded(deals: uniqueDeals, stores: _cachedStores!));
    } catch (e) {
      emit(DealError('Arama hatası: ${e.toString()}'));
    }
  }

  List<DealModel> _getUniqueDeals(List<DealModel> deals) {
    final Map<String, DealModel> uniqueMap = {};
    for (var deal in deals) {
      if (deal.title == null) continue;
      
      final normalizedTitle = deal.title!.trim().toLowerCase();
      
      if (!uniqueMap.containsKey(normalizedTitle)) {
        uniqueMap[normalizedTitle] = deal;
      } else {
        double currentPrice = double.tryParse(uniqueMap[normalizedTitle]?.salePrice ?? '99999') ?? 99999;
        double newPrice = double.tryParse(deal.salePrice ?? '99999') ?? 99999;
        
        if (newPrice < currentPrice) {
          uniqueMap[normalizedTitle] = deal;
        }
      }
    }
    return uniqueMap.values.toList();
  }
}
