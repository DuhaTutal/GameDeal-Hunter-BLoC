import 'package:equatable/equatable.dart';

class DealModel extends Equatable {//API'den (CheapShark) bize çok fazla veri geliyor.
  final String? internalName;// Bu kısım, o verilerden hangilerini uygulamamızda kullanacağımızı belirlediğimiz yerdir.
  final String? title;
  final String? dealID;    //? (Nullable): "Bu veri API'den boş gelebilir, hazırlıklı ol" demektir. Uygulamanın çökmesini engeller.
  final String? storeID;
  final String? gameID;     //final: Bu değişkenler bir kez değer alınca bir daha değiştirilemezler.
  final String? salePrice;
  final String? normalPrice;
  final String? isOnSale;
  final String? savings;
  final String? metacriticScore;
  final String? steamRatingText;
  final String? steamRatingPercent;
  final String? steamRatingCount;
  final String? steamAppID;
  final int? releaseDate;
  final int? lastChange;
  final String? dealRating;
  final String? thumb;

  const DealModel({//Constructor
    this.internalName,
    this.title,
    this.dealID,
    this.storeID,
    this.gameID,
    this.salePrice,
    this.normalPrice,
    this.isOnSale,
    this.savings,
    this.metacriticScore,
    this.steamRatingText,
    this.steamRatingPercent,
    this.steamRatingCount,
    this.steamAppID,
    this.releaseDate,
    this.lastChange,
    this.dealRating,
    this.thumb,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(                //API'den gelen {"title": "FIFA 23", "salePrice": "10.00"} şeklindeki karmaşık yapıyı alır ve bir DealModel nesnesine dönüştürür.
      internalName: json['internalName'],// Uygulama içinde artık oyun.title diyerek veriye ulaşabiliriz.
      title: json['title'],
      dealID: json['dealID'],
      storeID: json['storeID'],
      gameID: json['gameID'],
      salePrice: json['salePrice'],
      normalPrice: json['normalPrice'],
      isOnSale: json['isOnSale'],
      savings: json['savings'],
      metacriticScore: json['metacriticScore'],
      steamRatingText: json['steamRatingText'],
      steamRatingPercent: json['steamRatingPercent'],
      steamRatingCount: json['steamRatingCount'],
      steamAppID: json['steamAppID'],
      releaseDate: json['releaseDate'],
      lastChange: json['lastChange'],
      dealRating: json['dealRating'],
      thumb: json['thumb'],
    );
  }

  Map<String, dynamic> toJson() {//Eğer uygulamanda bir form olsaydı ve sen sunucuya bir veri göndermek isteseydin, sunucu senden bir Nesne değil, JSON paketi bekleyecekti.
    return {
      'internalName': internalName,
      'title': title,
      'dealID': dealID,
      'storeID': storeID,
      'gameID': gameID,
      'salePrice': salePrice,
      'normalPrice': normalPrice,
      'isOnSale': isOnSale,
      'savings': savings,
      'metacriticScore': metacriticScore,
      'steamRatingText': steamRatingText,
      'steamRatingPercent': steamRatingPercent,
      'steamRatingCount': steamRatingCount,
      'steamAppID': steamAppID,
      'releaseDate': releaseDate,
      'lastChange': lastChange,
      'dealRating': dealRating,
      'thumb': thumb,
    };
  }

  @override
  List<Object?> get props => [dealID, gameID, title];
} //Eğer iki oyunun dealID'si, gameID'si ve title'ı aynıysa, bu oyunlar aynı oyundur.
  // Listeyi boşuna baştan aşağı yenileme (rebuild yapma).
