import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/ProductProvider.dart';
import '../utils/cart_state_notifier.dart';
import 'favorite_screen.dart';

class FavoriteScreenFutureBuilder extends ConsumerWidget {
  const FavoriteScreenFutureBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Product>>(
        future: ref.read(productProvider.notifier).fetchAllFavoriteItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite items to show.'));
          } else {
            final favList = snapshot.data;
            return FavoriteScreen(favList: favList!);
          }
        });
  }
}
