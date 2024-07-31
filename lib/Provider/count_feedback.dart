import 'package:flutter/material.dart';

class CountFeedback extends ChangeNotifier {
  int cartCount = 0;
  void add(int count) {
    cartCount += count;
    notifyListeners();
    print("Added: ${cartCount}");
  }

  void decrement(int count) {
    if (cartCount >= count) {
      cartCount -= count;
      notifyListeners();
      print("Decremented: ${cartCount}");
    }
  }

  void reset() {
    cartCount = 0;
    notifyListeners();
    print("Resett: ${cartCount}");
  }
}
