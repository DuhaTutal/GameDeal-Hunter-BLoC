import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/favorite_bloc.dart';
import '../../logic/bloc/deal_bloc.dart';
import '../../logic/bloc/deal_state.dart';
import '../widgets/deal_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dealState = context.read<DealBloc>().state;
    final stores = (dealState is DealLoaded) ? dealState.stores : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Favorites'),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return const Center(child: Text('You don\'t have any favorite games yet.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final deal = state.favorites[index];
              final store = stores.firstWhere(
                (s) => s.storeID == deal.storeID,
                orElse: () => stores.isNotEmpty ? stores.first : null,
              );
              return DealCard(deal: deal, store: store);
            },
          );
        },
      ),
    );
  }
}
