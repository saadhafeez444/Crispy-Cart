class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final int calories;
  final String category;
  int quantity; // ✅ Add this line

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.calories,
    required this.category,
    this.quantity = 1, // ✅ Default to 1
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'].toDouble(),
      rating: map['rating'].toDouble(),
      calories: map['calories'],
      category: map['category'],
      quantity: map['quantity'] ?? 1, // ✅ Safe fallback
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'calories': calories,
      'category': category,
      'quantity': quantity, // ✅ Include it here
    };
  }
}
