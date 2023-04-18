import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:resto_app/data/model/favorite_resto.dart';
import 'package:resto_app/helper/database_helper.dart';

enum ResultStateDb { loading, noData, hasData, error }

class DbProvider extends ChangeNotifier {
  List<FavoriteResto> _favoriteResto = [];
  late DatabaseHelper _dbHelper;

  late ResultStateDb _state;
  String _message = '';
  String get message => _message;
  List<FavoriteResto> get result => _favoriteResto;
  ResultStateDb get state => _state;

  List<FavoriteResto> get favorites => _favoriteResto;
  DbProvider() {
    _dbHelper = DatabaseHelper();
    _fetchAllFavoriteResto();
  }

  Future<dynamic> _fetchAllFavoriteResto() async {
    try {
      _state = ResultStateDb.loading;
      notifyListeners();
      final favoriteResto = await _dbHelper.getFavoriteResto();
      if (favoriteResto.isEmpty) {
        _state = ResultStateDb.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDb.hasData;
        notifyListeners();
        return _favoriteResto = favoriteResto;
      }
    } catch (e) {
      _state = ResultStateDb.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<FavoriteResto> getFavoriteRestoById(String id) async {
    return await _dbHelper.getFavoriteRestoById(id);
  }

  Future<void> addFavoriteResto(FavoriteResto favoriteResto) async {
    await _dbHelper.insertFavoriteResto(favoriteResto);
    _fetchAllFavoriteResto();
  }

  Future<void> updateFavoriteResto(FavoriteResto favoriteResto) async {
    await _dbHelper.updateFavoriteResto(favoriteResto);
    _fetchAllFavoriteResto();
  }

  void deleteFavoriteResto(String id) async {
    await _dbHelper.deleteFavoriteResto(id);
    _fetchAllFavoriteResto();
  }
}
