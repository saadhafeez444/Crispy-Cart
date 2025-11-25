import 'package:flutter/material.dart';
import 'package:crispycart/data/dummy_data.dart';
import 'package:crispycart/widgets/featured_items.dart';
import 'package:crispycart/widgets/category_selector.dart';
import 'package:crispycart/models/food_item.dart';
import 'package:crispycart/screens/food_detail.dart'; // Make sure this import exists
import 'package:crispycart/widgets/app_drawer.dart';
import 'package:crispycart/models/food_favourites.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';

  List<FoodItem> get _searchResults {
    if (_searchQuery.isEmpty) return [];
    return dummyFoodItems
        .where((item) =>
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
void initState() {
  super.initState();
  FoodFavorites.loadFavorites(); // ✅ Load from Firebase
}


  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _navigateToFoodDetail(FoodItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodDetailScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredItems = dummyFoodItems.take(6).toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on outside tap
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          title: const Text(
            "CrispyCart!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Banner
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🔍 Search Bar
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    if (value.isEmpty && _searchFocusNode.hasFocus) {
                      _searchFocusNode.unfocus();
                    }
                  });
                },
                onSubmitted: (_) {
                  _searchFocusNode.unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Search food items...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        BorderSide(color: Colors.deepOrange.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Colors.deepOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_searchQuery.isNotEmpty) ...[
                const Text(
                  'Search Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                FeaturedItems(
                  items: _searchResults,
                  onItemTap: _navigateToFoodDetail,
                ),
              ] else ...[
                const CategorySelector(),
                const SizedBox(height: 24),
                const Text(
                  'Featured Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                FeaturedItems(
                  items: featuredItems,
                  onItemTap: _navigateToFoodDetail,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
