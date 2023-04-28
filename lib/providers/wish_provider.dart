import 'package:flutter/foundation.dart';
import 'package:storeapp/providers/product_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWishitems => _list;
  int? get getlength => _list.length;

  void addWishItem(
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

  void clear() {
    _list.clear();
    notifyListeners();
  }

  void removeWithId(String documentId) {
    _list.removeWhere((element) => element.documentId == documentId);
    notifyListeners();
  }
  
}
