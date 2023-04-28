import 'package:flutter/foundation.dart';
import 'package:storeapp/providers/product_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getitems => _list;
  int? get getlength => _list.length;

  double get totalAmount {
    double total = 0.0;
    for (var element in _list) {
      total += element.price * element.qty;
    }
    return total;
  }

  // get totalcount of items in cart 
  int get totalcount {
    int total = 0;
    for (var element in _list) {
      total += element.qty;
    }
    return total;
  }

  void add(
    String name,
    double price,
    int qty,
    int qntty,
    List imagesUrl,
    String documentId,
    String supplierId,
  ) {
    _list.add(Product(
        name: name,
        price: price,
        qty: qty,
        qntty: qntty,
        imagesUrl: imagesUrl,
        documentId: documentId,
        supplierId: supplierId));
    notifyListeners();
  }

  bool contains(String documentId) {
    bool result = _list.any((element) => element.documentId == documentId);
    notifyListeners();
    return result;
  }

  void remove(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increment();
    notifyListeners();
  }

  void decrement(Product product) {
    product.decrement();
    notifyListeners();
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }
}
