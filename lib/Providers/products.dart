import 'package:flutter/Material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  List<Product> get showFavoritesItem {
    return _items.where((element) => element.isFavorite).toList();
  }
  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    const url =
        "https://flutter-shop-app-2b69a-default-rtdb.firebaseio.com/products.json";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> update(String id, Product newProduct) async {
    final url =
        "https://flutter-shop-app-2b69a-default-rtdb.firebaseio.com/products/" +
            id +
            "/.json";
    try {
      await http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      final prodIndex = _items.indexWhere((element) => element.id == id);
      if (prodIndex >= 0) {
        _items[prodIndex] = newProduct;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://flutter-shop-app-2b69a-default-rtdb.firebaseio.com/products/" +
            id +
            "/.json";
    final _existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? _existingProduct = _items[_existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(_existingProductIndex, _existingProduct);
      notifyListeners();
      throw HttpException(message: 'Could not delete');
    }
    _existingProduct = null;
  }

  Future<void> fetchAndSetProduct() async {
    const url =
        "https://flutter-shop-app-2b69a-default-rtdb.firebaseio.com/products.json";
    try {
      final respose = await http.get(Uri.parse(url));
      final extractedData = json.decode(respose.body) as Map<String, dynamic>;
      List<Product> loadedProduct = [];
      extractedData.forEach((key, value) {
        loadedProduct.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
