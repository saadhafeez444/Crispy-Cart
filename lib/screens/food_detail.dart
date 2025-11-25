import 'package:flutter/material.dart';
import 'package:crispycart/models/food_item.dart';
import 'package:crispycart/models/food_favourites.dart'; // ✅ Import this
import 'package:crispycart/models/cart_service.dart';
import 'package:crispycart/screens/cart.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem item;

  const FoodDetailScreen({super.key, required this.item});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FoodFavorites.isFavorite(widget.item); // ✅ initialize
  }

  void toggleFavorite() {
    setState(() {
      FoodFavorites.toggleFavorite(widget.item); // ✅ add/remove
      isFavorite = FoodFavorites.isFavorite(widget.item); // ✅ refresh UI
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
            ),
            onPressed: () {
              toggleFavorite();
  
            },
          )
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: item.name,
            child: Image.asset(item.imageUrl, height: 220, fit: BoxFit.cover, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('₦${item.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.deepOrange, fontSize: 20)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(item.rating.toString()),
                    const SizedBox(width: 16),
                    Text('${item.calories} cal'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(item.description),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                CartService.addToCart(item);
                
                 Navigator.push(context,
                 MaterialPageRoute(builder: (_) => CartScreen())
                 );
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.shopping_cart, color: Colors.white,),
              label: const Text('Add to Cart',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
