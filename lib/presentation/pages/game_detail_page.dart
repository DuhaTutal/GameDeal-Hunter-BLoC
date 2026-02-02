import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/deal_model.dart';
import '../../data/models/store_model.dart';
import '../../logic/bloc/game_detail_bloc.dart';
import '../../logic/bloc/game_detail_state.dart';
import '../../logic/bloc/deal_bloc.dart';
import '../../logic/bloc/deal_state.dart';
import '../../logic/bloc/watchlist_bloc.dart';
import '../../logic/bloc/favorite_bloc.dart';

class GameDetailPage extends StatelessWidget {
  const GameDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dealState = context.read<DealBloc>().state;
    final List<StoreModel> stores = (dealState is DealLoaded) ? dealState.stores : [];

    return BlocBuilder<GameDetailBloc, GameDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Price Comparison'),
            actions: [
              if (state is GameDetailLoaded)
                BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, favoriteState) {
                    final game = state.gameDetail;
                    final isFavorite = favoriteState.favorites.any((d) => d.gameID == state.gameId);
                    
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        final dealToFavorite = DealModel(
                          gameID: state.gameId,
                          title: game.infoName,
                          thumb: game.infoThumb,
                          salePrice: game.deals?.first.price,
                        );
                        context.read<FavoriteBloc>().add(ToggleFavoriteEvent(dealToFavorite));
                      },
                    );
                  },
                ),
            ],
          ),
          body: _buildBody(context, state, stores),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, GameDetailState state, List<StoreModel> stores) {
    if (state is GameDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GameDetailLoaded) {
      final game = state.gameDetail;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: game.infoThumb ?? '',
                    width: 120,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    game.infoName ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('All Stores & Offers', style: TextStyle(color: Colors.white54, fontSize: 14)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: game.deals?.length ?? 0,
              itemBuilder: (context, index) {
                final offer = game.deals![index];
                final store = stores.firstWhere(
                  (s) => s.storeID == offer.storeID,
                  orElse: () => StoreModel(storeName: 'Store ${offer.storeID}'),
                );

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    onTap: () => _openDeal(offer.dealID),
                    leading: (store.images != null)
                        ? CachedNetworkImage(imageUrl: store.iconUrl, width: 34)
                        : const Icon(Icons.shopping_cart),
                    title: Text(store.storeName ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${offer.price}\$',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.greenAccent),
                            ),
                            Text(
                              '${offer.retailPrice}\$',
                              style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 11, color: Colors.white38),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        BlocBuilder<WatchlistBloc, WatchlistState>(
                          builder: (context, watchlistState) {
                            final isWatched = watchlistState.watchlist.any((d) => d.dealID == offer.dealID);
                            return IconButton(
                              icon: Icon(
                                isWatched ? Icons.visibility : Icons.visibility_outlined,
                                color: isWatched ? Colors.blueAccent : Colors.white54,
                              ),
                              onPressed: () {
                                final dealToWatch = DealModel(
                                  dealID: offer.dealID,
                                  title: '${game.infoName} (${store.storeName})',
                                  salePrice: offer.price,
                                  normalPrice: offer.retailPrice,
                                  thumb: game.infoThumb,
                                  storeID: offer.storeID,
                                );
                                context.read<WatchlistBloc>().add(ToggleWatchlistEvent(dealToWatch));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (state is GameDetailError) {
      return Center(child: Text(state.message));
    }
    return const Center(child: Text('Loading details...'));
  }

  Future<void> _openDeal(String? dealId) async {
    if (dealId == null) return;
    final Uri url = Uri.parse('https://www.cheapshark.com/redirect?dealID=$dealId');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not open link: $e');
    }
  }
}
