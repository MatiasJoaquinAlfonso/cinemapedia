import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//init
//solo las primeras 10

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoritesMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return _ButtonHome(colors: colors);
    }

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 80,
        child: MovieMansonry(
          loadNextPage: loadNextPage,
          movies: favoritesMovies,
        ),
      ),
    );
  }
}



class _ButtonHome extends StatelessWidget {
  const _ButtonHome({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline_sharp, size: 60, color: colors.primary),
          Text('Ohh!! no!!', style: TextStyle(fontSize: 30, color: colors.primary)),
          const Text('No tienes películas favoritas', style: TextStyle(fontSize: 20, color: Colors.black45)),
          
          const SizedBox(height: 20),
    
          FilledButton.tonal(
            onPressed: () => context.go('/home/0'), 
            child: const Text('Empieza a buscar')
          )
        ],
      ),
    );
  }
}
