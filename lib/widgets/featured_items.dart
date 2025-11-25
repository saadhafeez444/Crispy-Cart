// featured_items.dart
import 'package:flutter/material.dart';
import 'package:crispycart/models/food_item.dart';

class FeaturedItems extends StatelessWidget {
  final List<FoodItem> items;
  final void Function(FoodItem)? onItemTap;

  const FeaturedItems({
    super.key,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (ctx, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(item);
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: item.name,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      item.imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('₦${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.deepOrange)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
