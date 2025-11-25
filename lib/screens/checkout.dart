import 'package:flutter/material.dart';
import 'package:crispycart/models/cart_service.dart';


class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = CartService.cartItems;
    final totalAmount = CartService.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.deepOrange,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.asset(item.item.imageUrl, width: 50, height: 50),
                        title: Text(item.item.name),
                        subtitle: Text('₦${item.item.price.toStringAsFixed(0)} × ${item.quantity}'),
                        trailing: Text('₦${(item.item.price * item.quantity).toStringAsFixed(0)}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("₦${totalAmount.toStringAsFixed(0)}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Place order logic here
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Order Placed"),
                              content: const Text("Thank you for your order!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    CartService.clearCart();
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  },
                                  child: const Text("OK"),
                                )
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text("Place Order", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
