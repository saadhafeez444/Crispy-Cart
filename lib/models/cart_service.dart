import 'package:crispycart/models/food_item.dart';

class CartItem {
  final FoodItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class CartService {
  static final List<CartItem> _cartItems = [];

  static List<CartItem> get cartItems => _cartItems;

  static void addToCart(FoodItem item) {
    final index = _cartItems.indexWhere((cartItem) => cartItem.item.name == item.name);
    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(item: item));
    }
  }

  static void removeFromCart(FoodItem item) {
    _cartItems.removeWhere((cartItem) => cartItem.item.name == item.name);
  }

  static void increaseQuantity(FoodItem item) {
    final index = _cartItems.indexWhere((cartItem) => cartItem.item.name == item.name);
    if (index != -1) {
      _cartItems[index].quantity++;
    }
  }

  static void decreaseQuantity(FoodItem item) {
    final index = _cartItems.indexWhere((cartItem) => cartItem.item.name == item.name);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        removeFromCart(item);
      }
    }
  }

  static double get totalPrice {
    return _cartItems.fold(0.0, (sum, cartItem) {
      final price = cartItem.item.price;
      return sum + (price * cartItem.quantity);
    });
  }

  static void clearCart() {
    _cartItems.clear();
  }
}
