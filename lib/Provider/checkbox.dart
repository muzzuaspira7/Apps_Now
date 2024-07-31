import 'package:flutter/cupertino.dart';
import '../Model/my_cart.dart';

class CheckboxStatus extends ChangeNotifier {
  Set<String> selectedItems = {};

  void initializeSelection(List<String> items) {
    selectedItems = items.toSet();
    notifyListeners();
  }

  void toggleSelection(String id) {
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }
    notifyListeners();
  }

  bool isSelected(String id) {
    return selectedItems.contains(id);
  }

  bool areAllSelected(List<myCart> cartItems) {
    return cartItems.every((cart) => selectedItems.contains(cart.id));
  }

  void clearSelections() {
    selectedItems.clear();
    notifyListeners();
  }
}
