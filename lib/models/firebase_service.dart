import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crispycart/models/food_item.dart';

class FirebaseService {
  static final _favRef = FirebaseFirestore.instance.collection('favorites');

  static Future<void> addFavorite(FoodItem item) async {
    await _favRef.doc(item.name).set({
      'name': item.name,
      'description': item.description,
      'imageUrl': item.imageUrl,
      'price': item.price,
      'rating': item.rating,
      'calories': item.calories,
      'category': item.category,
    });
  }

  static Future<void> removeFavorite(String name) async {
    await _favRef.doc(name).delete();
  }

 static Future<List<FoodItem>> fetchFavorites() async {
  final snapshot = await _favRef.get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return FoodItem.fromMap(data);
  }).toList();
}

}
