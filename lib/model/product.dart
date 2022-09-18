import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFav(bool oldState) {
    isFavorite = oldState;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    var url = Uri.https(
        'flutter-shopping-app-5f0b7-default-rtdb.firebaseio.com',
        '/product/$id.json');
    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        _setFav(oldState);
      }
    } catch (e) {
      _setFav(oldState);
    }
  }
}
