import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/deal_model.dart';

// Events
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final DealModel deal;
  const ToggleFavoriteEvent(this.deal);
  @override
  List<Object?> get props => [deal];
}

// States
class FavoriteState extends Equatable {
  final List<DealModel> favorites;
  const FavoriteState({this.favorites = const []});
  @override
  List<Object?> get props => [favorites];
}

// Bloc
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  static const String _storageKey = 'favorites_list';

  FavoriteBloc() : super(const FavoriteState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<DealModel> favorites = jsonList.map((j) => DealModel.fromJson(j)).toList();
      emit(FavoriteState(favorites: favorites));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    final isExist = state.favorites.any((d) => d.gameID == event.deal.gameID);
    List<DealModel> updatedFavorites;
    
    if (isExist) {
      updatedFavorites = state.favorites.where((d) => d.gameID != event.deal.gameID).toList();
    } else {
      updatedFavorites = List.from(state.favorites)..add(event.deal);
    }
    
    emit(FavoriteState(favorites: updatedFavorites));
    
    // Diske kaydet
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(updatedFavorites.map((f) => f.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }
}
