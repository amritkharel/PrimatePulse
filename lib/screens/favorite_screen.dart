import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_app/utils/cart_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../utils/ProductProvider.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key, required this.favList});
  final List<Product> favList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> productList = ref
        .watch(productProvider)
        .where((element) => element.isFavourite == true)
        .toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Favorite Products',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        actions: [
          SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 15,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartScreen.id);
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 25.0,
                    ),
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 20,
                  child: Text(
                    ref
                        .watch(productProvider.notifier)
                        .cartItemCount()
                        .toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: StaggeredGridView.countBuilder(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildClipRRect(
                        index, context, ref, productList[index]);
                  },
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClipRRect(
      int index, BuildContext context, WidgetRef ref, Product product) {
    final productId = product.productId;
    return Padding(
      padding: index == 1
          ? const EdgeInsets.fromLTRB(2.0, 70.0, 2.0, 2.0)
          : const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(product1: product, fromFavView: true),
            ),
          );
        },
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.yellow[600], // Background color
          child: Column(
            children: [
              SizedBox(
                height: 300.0,
                width: 200.0,
                child: Stack(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.name ?? '',
                          style: const TextStyle(
                            fontFamily: 'Exo2',
                            color: Colors.black,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                        child: Text(
                          "Rs. ${product.price}",
                          style: const TextStyle(
                            fontFamily: 'Exo2',
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(productProvider.notifier)
                              .removeAndAddFromFavorite(productId);
                        },
                        icon: Icon(
                          (product.isFavourite ?? false)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: (product.isFavourite ?? false)
                              ? Colors.red
                              : Colors.white,
                          size: 25.0,
                          weight: 50.0,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(productProvider.notifier)
                              .removeAndAddFromCart(productId, 0);
                        },
                        icon: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                          child: Icon(
                            (product.isInCart ?? false)
                                ? Icons.remove_shopping_cart
                                : Icons.add_shopping_cart_outlined,
                            color: (product.isInCart ?? false)
                                ? Colors.green
                                : Colors.white,
                            size: 25.0,
                            weight: 50.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
