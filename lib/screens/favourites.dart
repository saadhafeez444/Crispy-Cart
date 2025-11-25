import 'package:flutter/material.dart';
import 'package:crispycart/models/food_item.dart';
import 'package:crispycart/widgets/featured_items.dart';
import 'package:crispycart/screens/food_detail.dart';
import 'package:crispycart/models/food_favourites.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FoodItem> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // ✅ Initial load
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true); // Optional: show loading again on return
    await FoodFavorites.loadFavorites();
    setState(() {
      _favorites = FoodFavorites.items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        backgroundColor: Colors.deepOrange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(child: Text('No favorite items yet.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FeaturedItems(
                    items: _favorites,
                    onItemTap: (item) async {
  final changed = await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item)),
  );
  if (changed == true) {
    await _loadFavorites(); // ✅ Only reload if a favorite was toggled
  }
},
                  ),
                ),
    );
  }
}
