import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resto_app/data/api/service.dart';
import 'package:resto_app/data/model/search_resto.dart';

enum ResultStateSearchResto { loading, noData, hasData, error }

class SearchRestoProvider extends ChangeNotifier {
  
  final ApiService apiService;
  final String key;
  SearchRestoProvider(this.key,{required this.apiService}) {
    _fetchAllSearchResto(key);
  }

  late SearchResto _searchResto;
  late ResultStateSearchResto _state;
  String _message = '';
  String get message => _message;
  SearchResto get result => _searchResto;
  ResultStateSearchResto get state => _state;

  Future<dynamic> _fetchAllSearchResto(String key) async {
    try {
      _state = ResultStateSearchResto.loading;
      notifyListeners();
      final searchResto = await apiService.getSearchResto(key);
      if (!searchResto.error) {
        _state = ResultStateSearchResto.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateSearchResto.hasData;
        notifyListeners();
        return _searchResto = searchResto;
      }
    } catch (e) {
      _state = ResultStateSearchResto.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
