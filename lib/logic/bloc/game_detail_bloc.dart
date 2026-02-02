import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/game_detail_model.dart';
import '../../data/repositories/deal_repository.dart';
import 'game_detail_event.dart';
import 'game_detail_state.dart';

class GameDetailBloc extends Bloc<GameDetailEvent, GameDetailState> {
  final DealRepository _dealRepository;

  GameDetailBloc(this._dealRepository) : super(GameDetailInitial()) {
    on<FetchGameDetailEvent>(_onFetchGameDetail);
  }

  Future<void> _onFetchGameDetail(FetchGameDetailEvent event, Emitter<GameDetailState> emit) async {
    emit(GameDetailLoading());
    try {
      final data = await _dealRepository.getGameDetails(event.gameId);
      final detail = GameDetailModel.fromJson(data);
      // gameId'yi de state ile birlikte gönderiyoruz
      emit(GameDetailLoaded(detail, event.gameId));
    } catch (e) {
      emit(GameDetailError('Oyun detayları yüklenemedi: ${e.toString()}'));
    }
  }
}
