import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/deal_bloc.dart';
import '../../logic/bloc/deal_event.dart';
import '../../logic/bloc/deal_state.dart';
import '../widgets/deal_card.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (query.length > 2) {
        context.read<DealBloc>().add(SearchDealsEvent(query));
      } else if (query.isEmpty) {
        context.read<DealBloc>().add(const FetchDealsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search games...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white60),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _onSearchChanged,
              )
            : const Text('🎮 GameDeal Hunter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  context.read<DealBloc>().add(const FetchDealsEvent());
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<DealBloc, DealState>(
        builder: (context, state) {
          if (state is DealLoading) return const Center(child: CircularProgressIndicator());
          if (state is DealLoaded) {
            if (state.deals.isEmpty) return const Center(child: Text('No games found.'));
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: state.deals.length,
              itemBuilder: (context, index) {
                final deal = state.deals[index];
                final store = state.stores.firstWhere(
                  (s) => s.storeID == deal.storeID,
                  orElse: () => state.stores.first,
                );
                return DealCard(deal: deal, store: store);
              },
            );
          }
          if (state is DealError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something went wrong'),
                  ElevatedButton(
                    onPressed: () => context.read<DealBloc>().add(const FetchDealsEvent()),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('Loading games...'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
