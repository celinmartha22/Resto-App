import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resto_app/data/api/service.dart';
import 'package:resto_app/data/model/detail_resto.dart';

enum ResultStateDetailResto { loading, noData, hasData, error }

class DetailRestoProvider extends ChangeNotifier {
  
  final ApiService apiService;
  final String id;
  DetailRestoProvider(this.id,{required this.apiService}) {
    _fetchAllDetailResto(id);
  }

  late DetailResto _detailResto;
  late ResultStateDetailResto _state;
  String _message = '';
  String get message => _message;
  DetailResto get result => _detailResto;
  ResultStateDetailResto get state => _state;

  Future<dynamic> _fetchAllDetailResto(String id) async {
    try {
      _state = ResultStateDetailResto.loading;
      notifyListeners();
      final detailResto = await apiService.getDetailResto(id);
      if (detailResto.error) {
        _state = ResultStateDetailResto.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDetailResto.hasData;
        notifyListeners();
        return _detailResto = detailResto;
      }
    } catch (e) {
      _state = ResultStateDetailResto.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
