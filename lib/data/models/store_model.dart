import 'package:equatable/equatable.dart';

class StoreModel extends Equatable {
  final String? storeID;
  final String? storeName;
  final int? isActive;
  final Map<String, dynamic>? images;

  const StoreModel({
    this.storeID,
    this.storeName,
    this.isActive,
    this.images,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeID: json['storeID'],
      storeName: json['storeName'],
      isActive: json['isActive'],
      images: json['images'],
    );
  }

  String get logoUrl => 'https://www.cheapshark.com${images?['logo'] ?? ''}';
  String get iconUrl => 'https://www.cheapshark.com${images?['icon'] ?? ''}';

  @override
  List<Object?> get props => [storeID, storeName];
}
