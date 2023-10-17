import 'package:final_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/ProductProvider.dart';

class CartScreenFutureBuilder extends ConsumerWidget {
  const CartScreenFutureBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
              future: ref.read(productProvider.notifier).fetchAllCartItems(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Scaffold(body: Center(child: CircularProgressIndicator(),));
                }else if(snapshot.hasError){
                  return Scaffold(body: Center(child: Text('Error: ${snapshot.error}'),));
                }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return const Scaffold(body: Center(child: Text("No Items In Cart"),));
                }else{
                  final cartList = snapshot.data;
                  return const CartScreen();
                }
  }
    );
}
}
