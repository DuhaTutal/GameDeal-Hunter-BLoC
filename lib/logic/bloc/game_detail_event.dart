import 'package:equatable/equatable.dart';

abstract class GameDetailEvent extends Equatable {
  const GameDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchGameDetailEvent extends GameDetailEvent {
  final String gameId;
  const FetchGameDetailEvent(this.gameId);

  @override
  List<Object?> get props => [gameId];
}
