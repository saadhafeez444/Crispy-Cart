import 'package:flutter/material.dart';
import 'package:crispycart/data/dummy_categories.dart';
import 'package:crispycart/screens/category_items.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dummyCategories.length,
            itemBuilder: (ctx, index) {
              final category = dummyCategories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryItemsScreen(category: category),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.deepOrange),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
