import 'package:final_app/screens/home_screen_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final reachedEndOfDataProvider = StateProvider<bool>((ref) => false);

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier(this.container) : super([]);
  final ProviderContainer container;

  final CollectionReference<Map<String, dynamic>> cartCollection =
      FirebaseFirestore.instance.collection('userProfile');
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final _firestore = FirebaseFirestore.instance;
  int pageSize = 5;
  late DocumentSnapshot lastVisibleItem;
  List<String> favItemIds = [];
  List<Map<String, dynamic>> cartItemList = [];
  List<Product> favItems = [];
  List<Product> cartItems = [];

  Future<void> getProductData() async {
    try {
      await fetchAndSetFavoriteState();
      await fetchAndSetCartState();
      state = [];
      final QuerySnapshot<Map<String, dynamic>> productSnapshot =
          await _firestore
              .collection("shoes")
              .orderBy("name")
              .limit(pageSize)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in productSnapshot.docs) {
        final productMap = doc.data();
        final String id = doc.id;
        final String name = productMap['name'];
        final int price = productMap['price'];
        final String imageUrl = productMap['imageurl'];
        final cartItem = cartItemList.firstWhere(
          (element) => element['productid'] == id,
          orElse: () => {'quantity': 0},
        );
        final quantity = cartItem['quantity'] as int;
        final mappedProduct = Product(
          productId: id,
          imageUrl: imageUrl,
          name: name,
          price: price,
          quantity: quantity,
          isFavourite: favItemIds.contains(id),
          isInCart: cartItemList.any((element) => element['productid'] == id),
        );
        if (state.every((element) => element.productId != id)) {
          state = [...state, mappedProduct];
        }
      }
      lastVisibleItem = productSnapshot.docs.last;
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadMoreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final QuerySnapshot<Map<String, dynamic>> productSnapshot =
          await _firestore
              .collection("shoes")
              .orderBy("name")
              .startAfterDocument(lastVisibleItem)
              .limit(pageSize)
              .get();
      if (productSnapshot.docs.isEmpty) {
        container
            .read(reachedEndOfDataProvider.notifier)
            .update((state) => true);
        container.read(isLoadingProvider.notifier).update((state) => false);
        prefs.setBool("isFavoriteView", false);
        return;
      } else {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in productSnapshot.docs) {
          final productMap = doc.data();
          final String id = doc.id;
          final String name = productMap['name'];
          final int price = productMap['price'];
          final String imageUrl = productMap['imageurl'];
          final cartItem = cartItemList.firstWhere(
            (element) => element['productid'] == id,
            orElse: () => {'quantity': 0},
          );
          final quantity = cartItem['quantity'] as int;
          final mappedProduct = Product(
            productId: id,
            imageUrl: imageUrl,
            name: name,
            price: price,
            quantity: quantity,
            isFavourite: favItemIds.contains(id),
            isInCart: cartItemList.any((element) => element['productid'] == id),
          );
          if (state.every((element) => element.productId != id)) {
            state = [...state, mappedProduct];
          }
        }
        lastVisibleItem = productSnapshot.docs.last;
      }
    } catch (e) {
      print(e);
    }
  }

  Future fetchAndSetFavoriteState() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final QuerySnapshot<Map<String, dynamic>> favoritesSnapshot =
          await _firestore
              .collection('userProfile')
              .doc(uid)
              .collection('favorites')
              .get();

      for (var doc in favoritesSnapshot.docs) {
        favItemIds.add(doc.data()['productid']);
      }
    } catch (e) {
      print("Error fetching favorite data from Firebase to set state: $e");
    }
  }

  Future<List<Product>> fetchAllFavoriteItems() async {
    try {
      favItems = [];
      //final uid = FirebaseAuth.instance.currentUser?.uid;
      if (favItemIds.isEmpty) {
        //do nothing
        return [];
      }
      final QuerySnapshot<Map<String, dynamic>> favoriteProductSnapshot =
          await _firestore
              .collection("shoes")
              .where(FieldPath.documentId, whereIn: favItemIds)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in favoriteProductSnapshot.docs) {
        final productMap = doc.data();
        //print(productMap);
        final String id = doc.id;
        final String name = productMap['name'];
        final int price = productMap['price'];
        final String imageUrl = productMap['imageurl'];
        final cartItem = cartItemList.firstWhere(
          (element) => element['productid'] == id,
          orElse: () => {'quantity': 0},
        );
        final quantity = cartItem['quantity'] as int;
        Product mappedProduct = Product(
          productId: id,
          imageUrl: imageUrl,
          name: name,
          price: price,
          quantity: quantity,
          isFavourite: true,
          isInCart: cartItemList.any((element) => element['productid'] == id),
        );
        if (!state.any((element) => element.productId == id)) {
          state = [...state, mappedProduct];
        }
        // print("State from inside favorite fetch $state");
        favItems.add(mappedProduct);
      }
      return favItems;
    } catch (e) {
      print("Error while fetching list of FavItems $e");
    }
    return [];
  }

  void addFavoriteItemToFirebase(String productId) async {
    try {
      final cartRef = cartCollection.doc(uid).collection('favorites');
      final existingItemQuery =
          await cartRef.where('productid', isEqualTo: productId).limit(1).get();
      if (existingItemQuery.docs.isEmpty) {
        // If no existing item with the same productId, add it as a new item
        await cartRef.add({
          'productid': productId,
        });
      }
    } catch (e) {
      print("Error adding item to favorites: $e");
    }
  }

  void removeFavoriteItemFromFirebase(String productId) async {
    try {
      await cartCollection
          .doc(uid)
          .collection('favorites')
          .where('productid', isEqualTo: productId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print("Error removing item from favorites: $e");
    }
  }

  void removeAndAddFromFavorite(String productId)  {
    if (state.any((element) => element.productId == productId)) {
      final product =
          state.firstWhere((element) => element.productId == productId);
      int indexOfProduct = state.indexOf(product);
      if (favItemIds.contains(productId)) {
        favItemIds.remove(productId);
        favItems.removeWhere((element) => element.productId == productId);
        product.isFavourite = false;
        state[indexOfProduct] = product;
        state = [...state];
        removeFavoriteItemFromFirebase(productId);
      } else {
        favItemIds.add(productId);
        product.isFavourite = true;
        state[indexOfProduct] = product;
        state = [...state];
        addFavoriteItemToFirebase(productId);
      }
    } else {
      if (favItemIds.contains(productId)) {
        favItemIds.remove(productId);
        favItems.removeWhere((element) => element.productId == productId);
        state = [...state];
        removeFavoriteItemFromFirebase(productId);
      }
    }
  }

  //state management and firebase data handling for cart

  Future fetchAndSetCartState() async {
    try {
      cartItemList = [];
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final QuerySnapshot<Map<String, dynamic>> cartSnapshot = await _firestore
          .collection('userProfile')
          .doc(uid)
          .collection('carts')
          .get();
      for (var doc in cartSnapshot.docs) {
        cartItemList.add({
          'productid': doc.data()['productid'],
          'quantity': doc.data()['quantity'],
        });
      }
    } catch (e) {
      print("Error fetching favorite data from Firebase to set state: $e");
    }
  }

  Future<List<Product>> fetchAllCartItems() async {
    try {
      cartItems = [];
      //final uid = FirebaseAuth.instance.currentUser?.uid;
      if (cartItemList.isEmpty) {
        //do nothing
        return [];
      }
      final List cartItemProductIds = cartItemList.map((item) => item['productid']).toList();
      //print("Cart Item ids $cartItemProductIds");
      final QuerySnapshot<Map<String, dynamic>> favoriteProductSnapshot =
      await _firestore
          .collection("shoes")
          .where(FieldPath.documentId, whereIn: cartItemProductIds)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
      in favoriteProductSnapshot.docs) {
        final productMap = doc.data();
        //print(productMap);
        final String id = doc.id;
        final String name = productMap['name'];
        final int price = productMap['price'];
        final String imageUrl = productMap['imageurl'];
        final cartItem = cartItemList.firstWhere(
              (element) => element['productid'] == id,
          orElse: () => {'quantity': 0},
        );
        final quantity = cartItem['quantity'] as int;
        Product mappedProduct = Product(
          productId: id,
          imageUrl: imageUrl,
          name: name,
          price: price,
          quantity: quantity,
          isFavourite: favItemIds.contains(id),
          isInCart: cartItemList.any((element) => element['productid'] == id),
        );
        if (!state.any((element) => element.productId == id)) {
          state = [...state, mappedProduct];
        }
        //print("State from inside cart fetch $state");
        cartItems.add(mappedProduct);
      }
      return cartItems;
    } catch (e) {
      print("Error while fetching list of FavItems $e");
    }
    return [];
  }


  void removeAndAddFromCart(String productId, int quantity) async {
    final product =
        state.firstWhere((element) => element.productId == productId);
    int indexOfProduct = state.indexOf(product);

    if (cartItemList.any((element) => element['productid'] == productId)) {
      int? currentQuantity = product.quantity;
      int newQuantity = currentQuantity! + quantity;
      quantity == 0 ? newQuantity = 0 : newQuantity;
      int indexOfCartItem = cartItemList
          .indexWhere((element) => element['productid'] == productId);
      if (indexOfCartItem != -1) {
        cartItemList[indexOfCartItem]['quantity'] = newQuantity;
      }
      if (newQuantity <= 0) {
        cartItemList
            .removeWhere((element) => element['productid'] == productId);
        product.isInCart = false;
        product.quantity = 0;
        state[indexOfProduct] = product;
        state = [...state];
        removeCartItemFromFirebase(productId);
      } else {
        product.isInCart = true;
        product.quantity = newQuantity;
        state[indexOfProduct] = product;
        state = [...state];
        addCartItemToFirebase(productId, newQuantity);
      }
    } else {
      cartItemList.add({'productid': productId, 'quantity': 1});
      product.isInCart = true;
      product.quantity = 1;
      state[indexOfProduct] = product;
      state = [...state];
      addCartItemToFirebase(productId, 1);
    }
  }

  void addCartItemToFirebase(String productId, int quantity) async {
    try {
      final cartRef = cartCollection.doc(uid).collection('carts');
      final existingItemQuery =
          await cartRef.where('productid', isEqualTo: productId).limit(1).get();
      if (existingItemQuery.docs.isEmpty) {
        // If no existing item with the same productId, add it as a new item
        await cartRef.add({
          'productid': productId,
          'quantity': quantity,
        });
      } else {
        final existingDoc = existingItemQuery.docs.first;
        final existingItemId = existingDoc.id;
        await cartRef.doc(existingItemId).update({'quantity': quantity});
      }
    } catch (e) {
      print("Error adding item to cart: $e");
    }
  }

  void removeCartItemFromFirebase(String productId) async {
    try {
      await cartCollection
          .doc(uid)
          .collection('carts')
          .where('productid', isEqualTo: productId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print("Error removing item from cart: $e");
    }
  }

  cartItemCount() {
    final count = cartItemList.length;
    return count;
  }

  cartTotalAmountCount(){
    int totalCartPrice = 0;
    if(cartItemList.isNotEmpty){
      for(var cartItem in cartItemList){
        String productId = cartItem['productid'];
        final product = state.firstWhere((element) => element.productId == productId);
        int? quantity = product.quantity;
        int? price = product.price;
        totalCartPrice += (quantity!*price!);
      }
      return totalCartPrice;
    }
    return totalCartPrice;
  }
  clearCartState() {
    state = [];
    cartItemList = [];
    favItems = [];
    cartItems = [];
    favItemIds = [];
  }
}

class Product {
  final String productId;
  final String? name;
  final int? price;
  final String? imageUrl;
  bool? isFavourite;
  bool? isInCart;
  int? quantity;
  Product(
      {required this.productId,
      this.name,
      this.price,
      this.imageUrl,
      this.isFavourite = false,
      this.isInCart = false,
      this.quantity});
}
