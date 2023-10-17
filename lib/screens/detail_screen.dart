import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/ProductProvider.dart';
import '../utils/cart_state_notifier.dart';

// final productProvider =
//     StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
//   return ProductNotifier(ref.container);
// });

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.product1, this.fromFavView=false});
  static const id = 'detail_screen';
  final Product product1;
  final bool fromFavView;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = product1.productId;
    var product =ref.watch(productProvider).firstWhere((element) => element.productId == productId);
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.yellow[600],
              alignment: const Alignment(0, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 300.0, 30.0),
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
                            : Colors.black,
                        size: 50.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 50.0),
                    child: CachedNetworkImage(
                      height: 350,
                      imageUrl: product.imageUrl ?? "",
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                        ),
                      ),
                      margin: const EdgeInsets.all(0.0),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 35,
                            left: 30,
                            right: 100,
                            child: Text(
                              product.name ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            right: 50,
                            child: Text(
                              'Rs. ${product.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 110,
                            left: 30,
                            right: 30,
                            child: Text(
                              "Here goes the product description just to make you believe you are missing out on something you didn't know even existed until yesterday.",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            right: 70.0,
                            left: 70.0,
                            child: Material(
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(20.0),
                              color: (product.isInCart ?? false)
                                  ? Colors.redAccent
                                  : Colors.yellow[600],
                              child: MaterialButton(
                                onPressed: () {
                                  ref
                                      .read(productProvider.notifier)
                                      .removeAndAddFromCart(productId, 0);
                                },
                                minWidth: 200.0,
                                height: 80.0,
                                child: Text(
                                  (product.isInCart ?? false)
                                      ? "Remove From Cart"
                                      : "Add to Cart",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
