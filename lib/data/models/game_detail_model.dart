class GameDetailModel {
  final String? infoName;
  final String? infoThumb;
  final List<DealOffer>? deals;

  GameDetailModel({this.infoName, this.infoThumb, this.deals});

  factory GameDetailModel.fromJson(Map<String, dynamic> json) {
    return GameDetailModel(
      infoName: json['info']?['title'],
      infoThumb: json['info']?['thumb'],
      deals: (json['deals'] as List?)
          ?.map((d) => DealOffer.fromJson(d))
          .toList(),
    );
  }
}

class DealOffer {
  final String? storeID;
  final String? dealID;
  final String? price;
  final String? retailPrice;
  final String? savings;

  DealOffer({this.storeID, this.dealID, this.price, this.retailPrice, this.savings});

  factory DealOffer.fromJson(Map<String, dynamic> json) {
    return DealOffer(
      storeID: json['storeID'],
      dealID: json['dealID'],
      price: json['price'],
      retailPrice: json['retailPrice'],
      savings: json['savings'],
    );
  }
}
