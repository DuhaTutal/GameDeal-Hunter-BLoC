import 'package:equatable/equatable.dart';
import '../../data/models/game_detail_model.dart';

abstract class GameDetailState extends Equatable {
  const GameDetailState();
  @override
  List<Object?> get props => [];
}

class GameDetailInitial extends GameDetailState {}
class GameDetailLoading extends GameDetailState {}
class GameDetailLoaded extends GameDetailState {
  final GameDetailModel gameDetail;
  final String gameId; // gameId ekledik
  const GameDetailLoaded(this.gameDetail, this.gameId);

  @override
  List<Object?> get props => [gameDetail, gameId];
}
class GameDetailError extends GameDetailState {
  final String message;
  const GameDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
