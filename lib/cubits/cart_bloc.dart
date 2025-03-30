import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diamond_model.dart';

/// **Helper method to generate a unique composite key for a Diamond**
String generateDiamondKey(Diamond diamond) {
  return '${diamond.lotId}-${diamond.carat}-${diamond.size}-${diamond.shape}-'
      '${diamond.color}-${diamond.clarity}-${diamond.cut}-${diamond.polish}-'
      '${diamond.symmetry}-${diamond.fluorescence}';
}

Diamond generateDiamondFromKey(String key) {
  final parts = key.split('-');
  return Diamond(
    lotId: parts[0],
    carat: double.tryParse(parts[1]),
    size: parts[2],
    shape: parts[3],
    color: parts[4],
    clarity: parts[5],
    cut: parts[6],
    polish: parts[7],
    symmetry: parts[8],
    fluorescence: parts[9],
  );
}

class CartState {
  final Map<String, Diamond> cartItems; // { compositeKey: Diamond }

  CartState({required this.cartItems});

  factory CartState.fromJson(Map<String, dynamic> json) {
    final cartMap = (json['cartItems'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, Diamond.fromJson(value)),
    );
    return CartState(cartItems: cartMap);
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItems': cartItems.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  CartState copyWith({Map<String, Diamond>? cartItems}) {
    return CartState(cartItems: cartItems ?? this.cartItems);
  }

  /// **Cart Summary Computation**
  double get totalCarat => cartItems.values
      .fold(0, (sum, item) => sum + (item.carat ?? 0) * item.qty);
  double get totalPrice => cartItems.values
      .fold(0, (sum, item) => sum + (item.finalAmount ?? 0) * item.qty);
  double get averagePrice =>
      cartItems.isNotEmpty ? totalPrice / cartItems.length : 0;
  double get averageDiscount => cartItems.isNotEmpty
      ? (cartItems.values
              .fold(0.0, (double sum, item) => sum + (item.discount ?? 0))) /
          cartItems.length
      : 0.0;
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(cartItems: {})) {
    _loadCart();
  }

  /// Load cart data from SharedPreferences
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString('cart_data');
    if (cartJson != null) {
      emit(CartState.fromJson(jsonDecode(cartJson)));
    }
  }

  /// Save cart data to SharedPreferences (only if state changes)
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final newCartData = jsonEncode(state.toJson());
    if (prefs.getString('cart_data') != newCartData) {
      await prefs.setString('cart_data', newCartData);
    }
  }

  /// **Add item to cart with composite key**
  void addToCart(Diamond diamond, BuildContext context) {
    final updatedCart = Map<String, Diamond>.from(state.cartItems);
    final key = generateDiamondKey(diamond);

    if (updatedCart.containsKey(key)) {
      updatedCart[key] =
          updatedCart[key]!.copyWith(quantity: getQuantity(diamond) + 1);
    } else {
      updatedCart[key] = diamond.copyWith(quantity: 1);
    }

    emit(state.copyWith(cartItems: updatedCart));
    _saveCart();
    _showToast(context, "Added to cart");
  }

  /// **Remove item from cart using composite key**
  void removeFromCart(Diamond diamond, BuildContext context) {
    final updatedCart = Map<String, Diamond>.from(state.cartItems);
    final key = generateDiamondKey(diamond);

    if (updatedCart.containsKey(key)) {
      final newQty = getQuantity(diamond) - 1;
      if (newQty > 0) {
        updatedCart[key] = updatedCart[key]!.copyWith(quantity: newQty);
      } else {
        updatedCart.remove(key);
      }
      emit(state.copyWith(cartItems: updatedCart));
      _saveCart();
    }
  }

  /// **Remove item completely from cart using composite key**
  void deleteFromCart(Diamond diamond, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Item"),
          content: const Text(
              "Are you sure you want to remove this item from the cart?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final updatedCart = Map<String, Diamond>.from(state.cartItems);
                final key = generateDiamondKey(diamond);

                if (updatedCart.containsKey(key)) {
                  updatedCart
                      .remove(key); // Remove the item entirely from the cart
                  emit(state.copyWith(cartItems: updatedCart));
                  _saveCart();
                  _showToast(context, "Deleted from cart");
                }

                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Get the quantity of a specific diamond in the cart
  int getQuantity(Diamond diamond) {
    final key = generateDiamondKey(diamond);
    return state.cartItems[key]?.qty ?? 0;
  }

  /// Get total item count in the cart
  int getTotalItems() {
    return state.cartItems.values
        .fold(0, (total, diamond) => total + diamond.qty);
  }

  /// Clear cart
  Future<void> clearCart() async {
    emit(CartState(cartItems: {}));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_data');
  }

  /// Show toast notification using Overlay
  void _showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100.0, // Position near the bottom
        left: MediaQuery.of(context).size.width * 0.2,
        child: Material(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () => overlayEntry.remove());
  }
}
