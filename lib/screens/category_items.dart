// category_items.dart
import 'package:flutter/material.dart';
import 'package:crispycart/data/dummy_data.dart';
import 'package:crispycart/widgets/featured_items.dart';
import 'package:crispycart/screens/food_detail.dart';

class CategoryItemsScreen extends StatelessWidget {
  const CategoryItemsScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final filteredItems = dummyFoodItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FeaturedItems(
          items: filteredItems,
          onItemTap: (item) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FoodDetailScreen(item: item),
              ),
            );
          },
        ),
      ),
    );
  }
}
