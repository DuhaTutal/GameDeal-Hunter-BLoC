import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/repositories/deal_repository.dart';
import 'data/services/api_service.dart';
import 'logic/bloc/deal_bloc.dart';
import 'logic/bloc/deal_event.dart';
import 'logic/bloc/game_detail_bloc.dart';
import 'logic/bloc/favorite_bloc.dart';
import 'logic/bloc/watchlist_bloc.dart';
import 'presentation/screens/main_screen.dart';

void main() {
  final apiService = ApiService();
  final dealRepository = DealRepository(apiService);

  runApp(MyApp(dealRepository: dealRepository));
}

class MyApp extends StatelessWidget {
  final DealRepository dealRepository;

  const MyApp({super.key, required this.dealRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: dealRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DealBloc(dealRepository)..add(const FetchDealsEvent()),
          ),
          BlocProvider(
            create: (context) => GameDetailBloc(dealRepository),
          ),
          BlocProvider(
            create: (context) => FavoriteBloc()..add(LoadFavoritesEvent()),
          ),
          BlocProvider(
            create: (context) => WatchlistBloc()..add(LoadWatchlistEvent()),
          ),
        ],
        child: MaterialApp(
          title: 'GameDeal Hunter',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          ),
          home: const MainScreen(),
        ),
      ),
    );
  }
}
