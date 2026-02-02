import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/deal_model.dart';
import '../../data/models/store_model.dart';
import '../../logic/bloc/game_detail_bloc.dart';
import '../../logic/bloc/game_detail_event.dart';
import '../../logic/bloc/favorite_bloc.dart';
import '../pages/game_detail_page.dart';

class DealCard extends StatelessWidget {
  final DealModel deal;
  final StoreModel? store;

  const DealCard({super.key, required this.deal, this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          if (deal.gameID != null) {
            context.read<GameDetailBloc>().add(FetchGameDetailEvent(deal.gameID!));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GameDetailPage()),
            );
          }
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: deal.thumb ?? '',
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                  child: Text(
                    deal.title ?? 'Bilinmeyen Oyun',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Mağaza İsmi
                if (store != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (store!.images != null)
                          CachedNetworkImage(imageUrl: store!.iconUrl, width: 12, height: 12),
                        const SizedBox(width: 4),
                        Text(
                          store!.storeName ?? '',
                          style: const TextStyle(fontSize: 9, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // En Ucuz Fiyat Etiketi
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withAlpha(230),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${deal.salePrice}\$',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),
            // Favori Butonu
            Positioned(
              top: 6,
              right: 6,
              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  final isFavorite = state.favorites.any((d) => d.gameID == deal.gameID);
                  return CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 15,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 16,
                      ),
                      onPressed: () => context.read<FavoriteBloc>().add(ToggleFavoriteEvent(deal)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
