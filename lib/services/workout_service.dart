import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';

class WorkoutService extends ChangeNotifier {
  static const String _workoutsKey = 'local_workouts';
  List<Workout> workouts = [];

  WorkoutService();

  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_workoutsKey);
    if (jsonStr != null) {
      final list = jsonDecode(jsonStr) as List;
      workouts = list.map((e) => Workout.fromMap(Map<String, dynamic>.from(e))).toList();
      notifyListeners();
      return;
    }
    // initial seed data — more workouts and varied video URLs (network placeholders).
    workouts = [
      Workout(
        id: 'w1',
        title: 'Full Body Beginner',
        description: 'A basic full-body routine to get you started.',
        durationMin: 20,
        videoUrl: 'https://storage.googleapis.com/fitness-app-videos/workouts/full-body-warmup.mp4',
        level: 'Beginner',
      ),
      Workout(
        id: 'w2',
        title: 'Cardio Burn',
        description: 'High-intensity cardio to boost metabolism.',
        durationMin: 15,
        videoUrl: 'https://storage.googleapis.com/fitness-app-videos/workouts/cardio-hiit.mp4',
        level: 'Intermediate',
      ),
      Workout(
        id: 'w3',
        title: 'Core Strength',
        description: 'Focused on abs and lower back strength.',
        durationMin: 12,
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        level: 'Beginner',
      ),
      Workout(
        id: 'w4',
        title: 'Upper Body Strength',
        description: 'Push, pull and press moves to build upper body strength.',
        durationMin: 25,
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        level: 'Intermediate',
      ),
      Workout(
        id: 'w5',
        title: 'HIIT Express',
        description: 'Quick high-intensity intervals to maximize calorie burn.',
        durationMin: 10,
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        level: 'Advanced',
      ),
      Workout(
        id: 'w6',
        title: 'Flexibility & Mobility',
        description: 'Stretching and mobility routine to improve range of motion.',
        durationMin: 18,
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        level: 'Beginner',
      ),
    ];
    await prefs.setString(_workoutsKey, jsonEncode(workouts.map((w) => w.toMap()).toList()));
    notifyListeners();
  }

  Future<void> addWorkout(Workout w) async {
    workouts.add(w);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_workoutsKey, jsonEncode(workouts.map((w) => w.toMap()).toList()));
  }

 Workout? getById(String id) =>
    workouts.where((w) => w.id == id).cast<Workout?>().firstOrNull;

}
