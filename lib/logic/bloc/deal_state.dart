import 'package:equatable/equatable.dart';
import '../../data/models/deal_model.dart';
import '../../data/models/store_model.dart';

abstract class DealState extends Equatable {
  const DealState();

  @override
  List<Object?> get props => [];
}

/// Başlangıç durumu
class DealInitial extends DealState {}

/// Veriler yükleniyor
class DealLoading extends DealState {}

/// Veriler başarıyla yüklendi
class DealLoaded extends DealState {
  final List<DealModel> deals;
  final List<StoreModel> stores;

  const DealLoaded({required this.deals, required this.stores});

  @override
  List<Object?> get props => [deals, stores];
}

/// Hata durumu
class DealError extends DealState {
  final String message;

  const DealError(this.message);

  @override
  List<Object?> get props => [message];
}
