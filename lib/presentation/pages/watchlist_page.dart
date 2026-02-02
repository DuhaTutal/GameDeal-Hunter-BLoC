import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../logic/bloc/watchlist_bloc.dart';
import '../../logic/bloc/deal_bloc.dart';
import '../../logic/bloc/deal_state.dart';
import '../../data/models/store_model.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dealState = context.read<DealBloc>().state;
    final List<StoreModel> stores = (dealState is DealLoaded) ? dealState.stores : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('👀 Price Watchlist'),
        centerTitle: true,
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state.watchlist.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'You haven\'t added any store offers to your watchlist yet. You can add them by tapping the eye icon on the detail page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.watchlist.length,
            itemBuilder: (context, index) {
              final deal = state.watchlist[index];
              final store = stores.firstWhere(
                (s) => s.storeID == deal.storeID,
                orElse: () => StoreModel(storeName: 'Store ${deal.storeID}'),
              );

              return Dismissible(
                key: Key(deal.dealID ?? index.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
                ),
                onDismissed: (_) {
                  context.read<WatchlistBloc>().add(ToggleWatchlistEvent(deal));
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    onTap: () => _openDeal(deal.dealID),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: deal.thumb ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(color: Colors.black12),
                        errorWidget: (context, url, error) => const Icon(Icons.gamepad),
                      ),
                    ),
                    title: Text(
                      deal.title ?? 'Game',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          if (store.images != null)
                            CachedNetworkImage(imageUrl: store.iconUrl, width: 16, height: 16),
                          const SizedBox(width: 6),
                          Text(
                            store.storeName ?? '',
                            style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${deal.salePrice}\$',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.greenAccent,
                              ),
                            ),
                            Text(
                              '${deal.normalPrice ?? ''}\$',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 11,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            context.read<WatchlistBloc>().add(ToggleWatchlistEvent(deal));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Removed from watchlist')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
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
