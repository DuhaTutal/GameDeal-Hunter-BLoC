import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/deal_model.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWatchlistEvent extends WatchlistEvent {}

class ToggleWatchlistEvent extends WatchlistEvent {
  final DealModel deal;
  const ToggleWatchlistEvent(this.deal);
  @override
  List<Object?> get props => [deal];
}

class WatchlistState extends Equatable {
  final List<DealModel> watchlist;
  const WatchlistState({this.watchlist = const []});
  @override
  List<Object?> get props => [watchlist];
}

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  static const String _storageKey = 'watchlist_list';

  WatchlistBloc() : super(const WatchlistState()) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
    on<ToggleWatchlistEvent>(_onToggleWatchlist);
  }

  Future<void> _onLoadWatchlist(LoadWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<DealModel> watchlist = jsonList.map((j) => DealModel.fromJson(j)).toList();
      emit(WatchlistState(watchlist: watchlist));
    }
  }

  Future<void> _onToggleWatchlist(ToggleWatchlistEvent event, Emitter<WatchlistState> emit) async {
    final isExist = state.watchlist.any((d) => d.dealID == event.deal.dealID);
    List<DealModel> updatedList;
    
    if (isExist) {
      updatedList = state.watchlist.where((d) => d.dealID != event.deal.dealID).toList();
    } else {
      updatedList = List.from(state.watchlist)..add(event.deal);
    }
    
    emit(WatchlistState(watchlist: updatedList));

    // Diske kaydet
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(updatedList.map((w) => w.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }
}
