import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resto_app/data/model/detail_resto.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/data/model/search_resto.dart';

class ApiService {
  final String apiUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantsList> getRestaurant() async {
    final response = await http.get(Uri.parse('$apiUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantsList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Restaurants List');
    }
  }

  Future<DetailResto> getDetailResto(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/detail/$id'));
    if (response.statusCode == 200) {
      return DetailResto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Detail Restaurant');
    }
  }

  Future<SearchResto> getSearchResto(String key) async {
    final response = await http.get(Uri.parse('$apiUrl/search?q=$key'));
    if (response.statusCode == 200) {
      return SearchResto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Search Results');
    }
  }
}