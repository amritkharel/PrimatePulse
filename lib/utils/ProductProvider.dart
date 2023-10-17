import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_state_notifier.dart';

final productProvider =
StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier(ref.container)..getProductData();
});
