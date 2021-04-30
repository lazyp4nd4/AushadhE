import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/models/Message.dart';
import 'package:shop_app/services/sharedPreferences.dart';

class DatabaseServices {
  Future<bool> createUser(String email, String password, String uid) async {
    if (uid != null)
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid)
          .set({'email': email, 'password': password, 'uid': uid});
    else
      return false;
    bool ans1 = await SharedFunctions.saveUserEmail(email);
    bool ans3 = await SharedFunctions.saveUserUid(uid);

    return (ans1 && ans3);
  }

  Future<void> addDetails(
      String name, String address, String phoneNumber, String uid) async {
    print(name);
    await FirebaseFirestore.instance.collection('profiles').doc(uid).update({
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'cartTotal': 0,
      'cartTotalItems': 0,
      'isAdmin': false
    });
    Timestamp t = Timestamp.fromDate(DateTime.now());

    await createChat(uid, name, t);

    await SharedFunctions.saveUserName(name);
    await SharedFunctions.saveUserAdminStatus(false);
  }

  createChat(String uid, String name, Timestamp t) async {
    await FirebaseFirestore.instance.collection('chats').doc(uid).set({
      'uid': uid,
      'adminId': "gjxRnsoMZtVsbLzgPHAJ0eInwDF2",
      'userName': name,
      'lastMessage': t,
      'hasMessage': false,
    });
  }

  addToCart(String uid, String productId, int quantity, int price) async {
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .set({'productId': productId, 'quantity': quantity, 'price': price});

    int cartTotalItems;
    int cartTotal;
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .get()
        .then((value) {
      cartTotal = value['cartTotal'];
      cartTotalItems = value['cartTotalItems'];
    });

    cartTotal += (quantity * price);
    cartTotalItems += quantity;

    FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .update({'cartTotal': cartTotal, 'cartTotalItems': cartTotalItems});
  }

  removeFromCart(String uid, String productId, int price, int quantity) async {
    print("beginning delete");
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .delete();
    print("finished deleting");

    await FirebaseFirestore.instance.collection('profiles').doc(uid).update({
      'cartTotal': FieldValue.increment(-1 * (price * quantity)),
      'cartTotalItems': FieldValue.increment(-1 * quantity)
    });
  }

  addProduct(String title, String description, int price, int rating,
      String imageUrl, bool isPopular) async {
    int id;
    await FirebaseFirestore.instance
        .collection('constants')
        .doc('details')
        .get()
        .then((value) {
      id = value['products'];
    });
    await FirebaseFirestore.instance
        .collection('constants')
        .doc('details')
        .update({'products': FieldValue.increment(1)});

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('products').doc();
    List<String> images = [imageUrl];

    await docRef.set({
      'title': title,
      'description': description,
      'isPopular': isPopular,
      'price': price,
      'id': id + 1,
      'productId': docRef.id,
      'images': images,
      'rating': rating
    });
  }

  placeOrder(String uid, int amount, int numberOfItems,
      List<Map<String, dynamic>> products) async {
    int orders;
    await FirebaseFirestore.instance
        .collection('constants')
        .doc('details')
        .get()
        .then((value) {
      orders = value['orders'];
    });
    await FirebaseFirestore.instance
        .collection('constants')
        .doc('details')
        .update({'orders': FieldValue.increment(1)});
    // await FirebaseFirestore.instance
    //     .collection('profiles')
    //     .doc(uid)
    //     .update({'cartTotal': 0.5, 'cartTotalItems': 0});
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('orders').doc();
    docRef.set({
      'orderId': docRef.id,
      'amount': amount,
      'uid': uid,
      'numberOfItems': numberOfItems,
      'products': products,
      'orderNumber': orders + 1,
      'status': "Ordered"
    });

    for (var product in products) {
      print(product['productId']);
      print("price: ");
      print(product['price']);
      await removeFromCart(
          uid, product['productId'], product['price'], product['quantity']);
      print("finished");
    }
  }

  removeItem() {}

  sendMessage(Message message, String uid) async {
    FirebaseFirestore.instance.collection('chats').doc(uid).update({
      'lastMessage': message.time,
      'hasMessage': true,
    });

    DocumentReference docRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(uid)
        .collection('messages')
        .doc();
    await docRef.set({
      'from': message.from,
      'to': message.to,
      'message': message.message,
      'time': message.time
    });
  }
}
