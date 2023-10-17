import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;
  bool isAddedToCart = false;
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>>? productData = [];

  Future<void> getProductData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> productSnapshot =
      await _firestore.collection("shoes").orderBy("name").get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
      in productSnapshot.docs) {
        productData?.add(doc.data());
      }
      print(productData);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getProductData().then((_) {
      setState(() {});
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical, // Set vertical scrolling
            itemCount: (productData?.length ?? 0),
            itemBuilder: (BuildContext context, int index) {
              if (index % 2 == 0) {
                // Even index
                return Row(
                  children: [
                    Expanded(
                      child: buildClipRRect(index),
                    ),
                    if (index + 1 < productData!.length) // Check if there's another item
                      Expanded(
                        child: buildClipRRect(index + 1),
                      ),
                  ],
                );
              } else {
                // Odd index
                return SizedBox(); // Empty container for odd index
              }
            },
          ),
        ),
      ),
    );
  }

  // Widget buildClipRRect(int index) {
  //   return Padding(
  //     padding: const EdgeInsets.all(5.0),
  //     child: Column(
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(30.0),
  //           child: Container(
  //             height: 280.0,
  //             width: 185.0,
  //             decoration: BoxDecoration(
  //               color: Colors.yellow[600],
  //               image: DecorationImage(
  //                 image: NetworkImage(productData?[index]["imageurl"]),
  //                 //fit: BoxFit.cover,
  //               ),
  //             ),
  //             child: Stack(
  //               children: [
  //                 Positioned(
  //                   bottom: 15,
  //                   left: 5,
  //                   right: 0,
  //                   child: Container(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "${productData?[index]["name"]}",
  //                       style: TextStyle(
  //                         fontFamily: 'Exo2',
  //                         color: Colors.black,
  //                         fontSize: 35.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const Divider(
  //                   height: 1.0,
  //                 ),
  //                 Positioned(
  //                   bottom: -5,
  //                   left: 5,
  //                   right: 0,
  //                   child: Container(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "Rs. ${productData?[index]["price"]}",
  //                       style: TextStyle(
  //                         fontFamily: 'Exo2',
  //                         color: Colors.black,
  //                         fontSize: 20.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   top: 0,
  //                   right: 0,
  //                   child: IconButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         isFavorite = !isFavorite;
  //                       });
  //                     },
  //                     icon: Icon(
  //                       isFavorite
  //                           ? Icons.favorite
  //                           : Icons.favorite_border_outlined,
  //                       color: isFavorite ? Colors.red : Colors.white,
  //                       size: 25.0,
  //                       weight: 50.0,
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   top: 30,
  //                   right: 0,
  //                   child: IconButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         isAddedToCart = !isAddedToCart;
  //                       });
  //                     },
  //                     icon: Padding(
  //                       padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
  //                       child: Icon(
  //                         isAddedToCart
  //                             ? Icons.remove_shopping_cart
  //                             : Icons.add_shopping_cart_outlined,
  //                         color: isAddedToCart ? Colors.green : Colors.white,
  //                         size: 25.0,
  //                         weight: 50.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildClipRRect(int index) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.yellow[600], // Background color
        child: Column(
          children: [
            Container(
              height: 280.0,
              width: 190.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(productData?[index]["imageurl"]), // Ensure the image covers the card
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 15,
                    left: 5,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${productData?[index]["name"]}",
                        style: TextStyle(
                          fontFamily: 'Exo2',
                          color: Colors.black,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                
                  Positioned(
                    bottom: -5,
                    left: 5,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Rs. ${productData?[index]["price"]}",
                        style: TextStyle(
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
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 25.0,
                        weight: 50.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isAddedToCart = !isAddedToCart;
                        });
                      },
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                        child: Icon(
                          isAddedToCart
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart_outlined,
                          color: isAddedToCart ? Colors.green : Colors.white,
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
    );
  }


}
