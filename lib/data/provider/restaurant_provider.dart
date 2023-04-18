import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resto_app/data/api/service.dart';
import 'package:resto_app/data/model/restaurant.dart';

enum ResultStateRestaurant { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  
  final ApiService apiService;
  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late RestaurantsList _restaurantsList;
  late ResultStateRestaurant _state;
  String _message = '';
  String get message => _message;
  RestaurantsList get result => _restaurantsList;
  ResultStateRestaurant get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultStateRestaurant.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurant();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultStateRestaurant.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateRestaurant.hasData;
        notifyListeners();
        return _restaurantsList = restaurant;
      }
    } catch (e) {
      _state = ResultStateRestaurant.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
