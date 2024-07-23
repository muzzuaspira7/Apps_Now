import 'dart:ffi';

class myOrder {
  final String name;
  final String id;
  int count;
  int price;

  myOrder(
      {required this.name,
      required this.id,
      required this.count,
      required this.price});
}
