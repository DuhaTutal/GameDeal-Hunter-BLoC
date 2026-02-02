import 'package:equatable/equatable.dart';

abstract class DealEvent extends Equatable {
  const DealEvent();

  @override
  List<Object?> get props => [];
}

class FetchDealsEvent extends DealEvent {
  final Map<String, dynamic>? queryParameters;
  const FetchDealsEvent({this.queryParameters});

  @override
  List<Object?> get props => [queryParameters];
}

class SearchDealsEvent extends DealEvent {
  final String title;
  const SearchDealsEvent(this.title);

  @override
  List<Object?> get props => [title];
}
