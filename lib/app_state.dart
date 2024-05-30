import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _userDiet = '';
  String get userDiet => _userDiet;
  set userDiet(String value) {
    _userDiet = value;
  }

  List<String> _userAllergens = [];
  List<String> get userAllergens => _userAllergens;
  set userAllergens(List<String> value) {
    _userAllergens = value;
  }

  void addToUserAllergens(String value) {
    _userAllergens.add(value);
  }

  void removeFromUserAllergens(String value) {
    _userAllergens.remove(value);
  }

  void removeAtIndexFromUserAllergens(int index) {
    _userAllergens.removeAt(index);
  }

  void updateUserAllergensAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    _userAllergens[index] = updateFn(_userAllergens[index]);
  }

  void insertAtIndexInUserAllergens(int index, String value) {
    _userAllergens.insert(index, value);
  }

  List<String> _userIngredientDislikes = [];
  List<String> get userIngredientDislikes => _userIngredientDislikes;
  set userIngredientDislikes(List<String> value) {
    _userIngredientDislikes = value;
  }

  void addToUserIngredientDislikes(String value) {
    _userIngredientDislikes.add(value);
  }

  void removeFromUserIngredientDislikes(String value) {
    _userIngredientDislikes.remove(value);
  }

  void removeAtIndexFromUserIngredientDislikes(int index) {
    _userIngredientDislikes.removeAt(index);
  }

  void updateUserIngredientDislikesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    _userIngredientDislikes[index] = updateFn(_userIngredientDislikes[index]);
  }

  void insertAtIndexInUserIngredientDislikes(int index, String value) {
    _userIngredientDislikes.insert(index, value);
  }
}
