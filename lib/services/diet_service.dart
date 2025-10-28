import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diet_plan.dart';

class DietService extends ChangeNotifier {
  static const String _dietKey = 'local_diets';
  List<DietPlan> diets = [];

  DietService();

  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_dietKey);
    if (jsonStr != null) {
      final list = jsonDecode(jsonStr) as List;
      diets = list.map((e) => DietPlan.fromMap(Map<String, dynamic>.from(e))).toList();
      notifyListeners();
      return;
    }
    diets = [
      DietPlan(
        id: 'd1',
        name: 'Balance (2000 kcal)',
        meals: [
          {'time': '08:00', 'title': 'Oatmeal + Banana', 'calories': 350},
          {'time': '12:30', 'title': 'Grilled Chicken Salad', 'calories': 500},
          {'time': '16:00', 'title': 'Yogurt + Nuts', 'calories': 250},
          {'time': '19:30', 'title': 'Baked Fish + Veggies', 'calories': 600},
        ],
      ),
      DietPlan(
        id: 'd2',
        name: 'Low Carb (1700 kcal)',
        meals: [
          {'time': '08:00', 'title': 'Scrambled Eggs', 'calories': 300},
          {'time': '12:30', 'title': 'Chicken & Broccoli', 'calories': 450},
          {'time': '16:00', 'title': 'Protein Shake', 'calories': 200},
          {'time': '19:30', 'title': 'Salmon + Salad', 'calories': 600},
        ],
      ),
    ];
    await prefs.setString(_dietKey, jsonEncode(diets.map((d) => d.toMap()).toList()));
    notifyListeners();
  }

  Future<void> addDiet(DietPlan d) async {
    diets.add(d);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dietKey, jsonEncode(diets.map((d) => d.toMap()).toList()));
    notifyListeners();
  }

  DietPlan? getById(String id) =>
    diets.where((d) => d.id == id).cast<DietPlan?>().firstOrNull;

}
