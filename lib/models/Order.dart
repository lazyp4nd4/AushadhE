class Order {
  String orderId;
  String uid;
  String status;
  int orderNumber;
  int numberOfItems;
  int amount;
  List<dynamic> products;

  Order(
      {this.amount,
      this.numberOfItems,
      this.orderId,
      this.products,
      this.orderNumber,
      this.status,
      this.uid});
}
