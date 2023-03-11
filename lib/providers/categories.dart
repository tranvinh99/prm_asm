import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryItem {
  final String id;
  final String name;
  final String imgUrl;
  CategoryItem({@required this.id, @required this.name, @required this.imgUrl});
}

class Categories with ChangeNotifier {
  final String token;

  Categories(this.token);

  List<CategoryItem> _cList = [];

  List<CategoryItem> get cList {
    return [..._cList];
  }

  int get listSize {
    return _cList.length;
  }

  Future<void> fetchAndSetCategories() async {
    final url = Uri.parse(
        'https://my-shop-1c8d5-default-rtdb.asia-southeast1.firebasedatabase.app/categories?auth=$token');
    try {
      final res = await http.get(url);
      final loadedCategories = jsonDecode(res.body) as Map<String, dynamic>;
      if (loadedCategories == null) return;
      loadedCategories.forEach((cId, cData) {
        _cList.add(CategoryItem(
            id: cId, name: cData['name'], imgUrl: cData['imgUrl']));
      });
      print(_cList);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addCategories(CategoryItem item) async {
    final url = Uri.parse(
        'https://my-shop-1c8d5-default-rtdb.asia-southeast1.firebasedatabase.app/categories?auth=$token');
    try {
      final res = await http.post(url, body: jsonEncode({'name': item.name}));
      final newCg = CategoryItem(
          id: jsonDecode(res.body)['name'],
          name: item.name,
          imgUrl: item.imgUrl);
      _cList.add(newCg);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
