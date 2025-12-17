import 'package:flutter/material.dart';
import '../models/fitness_models.dart';
import '../services/mock_ai_service.dart';

class FitnessProvider with ChangeNotifier {
  UserStats _userStats = MockAIService.getUserStats();
  WorkoutPlan? _todaysWorkout;
  bool _isLoading = false;

  UserStats get userStats => _userStats;
  WorkoutPlan? get todaysWorkout => _todaysWorkout;
  bool get isLoading => _isLoading;

  FitnessProvider() {
    _generateDailyPlan();
  }

  void _generateDailyPlan() {
    _isLoading = true;
    notifyListeners();

    // Simulate network/AI processing delay
    Future.delayed(const Duration(seconds: 1), () {
      _todaysWorkout = MockAIService.generateDailyWorkout(_userStats.goal);
      _isLoading = false;
      notifyListeners();
    });
  }

  void completeWorkout() {
    // Logic to update stats would go here
    _userStats = UserStats(
      name: _userStats.name,
      streakDays: _userStats.streakDays + 1,
      workoutsCompleted: _userStats.workoutsCompleted + 1,
      currentWeight: _userStats.currentWeight,
      goal: _userStats.goal,
    );
    notifyListeners();
  }
}
