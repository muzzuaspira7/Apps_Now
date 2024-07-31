class myCart {
  final String name;
  final String id;
  final String retailer;

  int count;
  int price;

  myCart(
      {required this.name,
      required this.id,
      required this.count,
      required this.price,
      required this.retailer});
}
