import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_app/utils/ProductProvider.dart';
import 'package:final_app/utils/cart_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});
  static const id = "cart_screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> productList = ref
        .watch(productProvider)
        .where((element) => element.isInCart == true)
        .toList();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  StaggeredGridView.countBuilder(
                    crossAxisCount: 1,
                    physics: const BouncingScrollPhysics(),
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildCartCard(productList[index], ref,
                          lastIndex: index == productList.length - 1);
                    },
                    staggeredTileBuilder: (int index) =>
                        const StaggeredTile.fit(1),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                      child: Card(
                        elevation: 10.0,
                        child: Stack(
                          children: [
                            const Positioned(
                                top: 13,
                                left: 50,
                                child: Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )),
                            Positioned(
                              top: 30,
                              left: 50,
                              child: Text(
                                'Rs. ${ref.watch(productProvider.notifier).cartTotalAmountCount().toString()}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 10,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Center(child: Text('Detail Info')),
                                        content: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Form(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Name',
                                                    icon: Icon(Icons
                                                        .account_box_outlined),
                                                  ),
                                                ),
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Phone number',
                                                    icon: Icon(Icons
                                                        .phone),
                                                  ),
                                                  keyboardType: TextInputType.phone,
                                                ),
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'District',
                                                    icon: Icon(Icons
                                                        .house),
                                                  ),
                                                ),
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'City',
                                                    icon: Icon(Icons
                                                        .location_city),
                                                  ),
                                                ),
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Street',
                                                    icon: Icon(Icons
                                                        .home_outlined),
                                                  ),
                                                ),
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText:
                                                        'Nearest Landmark',
                                                    icon: Icon(Icons
                                                        .location_on),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            child: const Text("Confirm"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  elevation: 0.0,
                                ),
                                child: const Center(
                                  child: Text("Checkout"),
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget buildCartCard(Product product, WidgetRef ref,
      {bool lastIndex = false}) {
    return Padding(
      padding: lastIndex
          ? const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80.0)
          : const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 390,
            height: 160,
            child: Card(
              elevation: 5.0,
              color: Colors.yellow[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: SizedBox(
                      height: 110,
                      width: 130,
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl ?? '',
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 180,
                    child: Text(
                      product.name ?? '',
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 180,
                    child: Text(
                      'Rs. ${product.price.toString()}',
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    right: 60,
                    child: IconButton(
                      onPressed: () {
                        ref
                            .read(productProvider.notifier)
                            .removeAndAddFromCart(product.productId, -1);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 48,
                    child: Text(
                      product.quantity.toString(),
                      style: const TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        ref
                            .read(productProvider.notifier)
                            .removeAndAddFromCart(product.productId, 1);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        ref
                            .read(productProvider.notifier)
                            .removeAndAddFromCart(product.productId, 0);
                      },
                      icon: const Icon(
                        Icons.delete_outline_outlined,
                        size: 30.0,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
