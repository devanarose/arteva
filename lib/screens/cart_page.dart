import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cart_item_card.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../widget/cart_item.dart';
import 'product_detail.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});
  static const routeName = '/cartpage';

  @override
  State<CartPage> createState() => _cartPageState();
}

class _cartPageState extends State<CartPage> {


  @override
  Widget build(BuildContext context) {
    // final cartItems = context.select<CartProvider, List<CartItem>>((provider) => provider.items,);
    // final cartItems = context.read<CartProvider>().items;
    // final cartItems = Provider.of<CartProvider>(context, listen: true).items;
    final cartItems = context.watch<CartProvider>().items;
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;
    return Scaffold(
      appBar: !kIsWeb ? AppBar(
        title: Text('My Cart ${cartItems.length}'),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFF1F1F6),
      ) :null,
      body: cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cart_image.jpg',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemWidget(key: ValueKey(item.p_id), productId: item.p_id, item: cartItems[index]);},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, -1),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<CartProvider, double>(
                    selector: (_, provider) => provider.total,
                    builder: (context, total, _) {
                      return Text(
                        'Total : ₹${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      );},
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proceeding to checkout...'),),
                      );},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// class CartPage extends StatelessWidget {
//   const CartPage({super.key});
//
//   static const routeName = '/cartpage';
//
//   @override
//   Widget build(BuildContext context) {
//     // final cartItems = context.select<CartProvider, List<CartItem>>((provider) => provider.items,);
//     // final cartItems = context.read<CartProvider>().items;
//     // final cartItems = Provider.of<CartProvider>(context, listen: true).items;
//     final cartItems = context.watch<CartProvider>().items;
//     final userId = Provider.of<AuthProvider>(context, listen: false).userId;
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Cart ${cartItems.length}'),
//         foregroundColor: Colors.black,
//         backgroundColor: const Color(0xFFF1F1F6),
//       ),
//       body: cartItems.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/cart_image.jpg',
//               width: 200,
//               height: 200,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       )
//           : Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: cartItems.length,
//               padding: const EdgeInsets.all(16),
//               itemBuilder: (context, index) {
//                 final item = cartItems[index];
//                 return CartItemWidget(key: ValueKey(item.p_id), productId: item.p_id, item: cartItems[index]);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF1F1F6),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12.withAlpha(20),
//                     blurRadius: 8,
//                     offset: const Offset(0, -1),
//                   ),
//                 ],
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Selector<CartProvider, double>(
//                     selector: (_, provider) => provider.total,
//                     builder: (context, total, _) {
//                       return Text(
//                         'Total : ₹${total.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       );
//                     },
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Proceeding to checkout...'),),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Proceed to Checkout',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
