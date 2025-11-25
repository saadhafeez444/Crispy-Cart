import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food_item.dart';

class FoodFavorites {
  static final List<FoodItem> _items = [];

  static List<FoodItem> get items => List.unmodifiable(_items);

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    _items.clear();
    for (var doc in snapshot.docs) {
      _items.add(FoodItem.fromMap({...doc.data(), 'id': doc.id}));
    }
  }

  static bool isFavorite(FoodItem item) {
    return _items.any((f) => f.id == item.id);
  }

  static Future<void> toggleFavorite(FoodItem item) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(item.id);

    final exists = _items.any((f) => f.id == item.id);
    if (exists) {
      await favRef.delete();
      _items.removeWhere((f) => f.id == item.id);
    } else {
      await favRef.set(item.toMap());
      _items.add(item);
    }
  }
}
