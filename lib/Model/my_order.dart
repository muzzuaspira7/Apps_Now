import 'dart:ffi';

class myOrder {
  final String name;
  final String id;
  final String retailer;
  int count;
  int price;

  myOrder(
      {required this.name,
      required this.id,
      required this.count,
      required this.retailer,
      required this.price});
}
