# 🎮 GameDeal Hunter

**GameDeal Hunter**, CheapShark API kullanarak gerçek zamanlı PC oyun indirimlerini takip eden, modern mimari ve yüksek performans odaklı geliştirilmiş bir Flutter mobil uygulamasıdır. Kullanıcıların en ucuz oyun fiyatlarını bulmasını, mağazalar arası karşılaştırma yapmasını ve favori oyunlarını takip etmesini sağlar.

---

## 🚀 Öne Çıkan Özellikler

*   **Real-Time Tracking:** Birçok farklı mağazadaki (Steam, Epic, GOG vb.) güncel indirimleri anlık olarak listeler.
*   **Price Comparison:** Bir oyunun tüm platformlardaki fiyatlarını tek ekranda karşılaştırır ve en ucuz seçeneğe yönlendirir.
*   **Advanced Search:** Akıllı filtreleme ve gecikmeli arama (debouncing) ile hızlı ve alakalı sonuçlar sunar.
*   **Favorite & Watchlist System:** Beğendiğiniz oyunları favorilere ekleyebilir veya belirli mağaza tekliflerini takip listenize alabilirsiniz.
*   **Data Persistence:** Favori ve takip listeleriniz cihaz hafızasında güvenli bir şekilde saklanır, uygulama kapansa da kaybolmaz.

---

## 🛠️ Mimari Yapı (Architecture)

Proje, kurumsal ölçekli uygulamalarda tercih edilen **BLoC (Business Logic Component)** desenini kullanır. Bu sayede:
*   **UI & Logic Separation:** Arayüz ile veri mantığı birbirinden tamamen bağımsızdır.
*   **Reactive UI:** Uygulama durumu (state) merkezi bir yerden yönetilir ve UI anlık olarak güncellenir.
*   **Clean Code:** Kod yapısı modüler, test edilebilir ve genişletilebilir şekilde kurgulanmıştır.

---

## 🧠 Akıllı Veri Yönetimi ve Stabilite

Uygulama geliştirme aşamasında, en zorlu ağ koşullarında bile akıcı bir deneyim sunmak için **"Fault Tolerant" (Hata Toleranslı)** bir yapı inşa edilmiştir:

*   **API Protection & Retry:** Hız sınırlamalarına (429 Rate Limit) karşı, isteği otomatik olarak bekletip tekrar deneyen özel bir **Exponential Backoff** algoritması entegre edilmiştir.
*   **Null Safety & Validation:** API'den gelebilecek eksik veya hatalı verilere karşı tüm modellerde sıkı bir validasyon mekanizması (`??` operatörleri ve model kontrolleri) kurulmuştur.
*   **Search Optimization:** Kullanıcı yazarken her harf için istek atılmasını engelleyen **Debouncing** tekniği ile API yükü azaltılmış ve performans artırılmıştır.
*   **Duplicate Handling:** Farklı kaynaklardan gelen mükerrer veriler normalize edilerek kullanıcıya her zaman en temiz sonuç gösterilir.

---

## 💻 Teknik Stack

*   **Framework:** Flutter (Material 3)
*   **State Management:** BLoC / Cubit
*   **Networking:** Dio (Custom Interceptors & Retry Logic)
*   **Local Storage:** SharedPreferences (Persistence)
*   **Images:** CachedNetworkImage (Performance & Caching)
*   **UI/UX:** Dark Theme, GridView Mimari, Google Fonts (Poppins)

---

## 📸 Ekran Görüntüleri

| Library | Price Comparison | Watchlist |
| :---: | :---: | :---: |
| ![Library](https://via.placeholder.com/150) | ![Comparison](https://via.placeholder.com/150) | ![Watchlist](https://via.placeholder.com/150) |

---
*Bu proje modern mobil geliştirme prensipleriyle optimize edilmiştir.*
