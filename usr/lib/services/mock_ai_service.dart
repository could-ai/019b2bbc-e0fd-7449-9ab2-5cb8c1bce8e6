import 'dart:math';
import '../models/fitness_models.dart';

class MockAIService {
  // Simulating AI generating a workout based on user state
  static WorkoutPlan generateDailyWorkout(String userGoal) {
    final random = Random();
    final isStrength = userGoal.toLowerCase().contains('strength');
    
    // Mock "AI" logic: varying the workout based on "analysis"
    if (isStrength) {
      return WorkoutPlan(
        id: 'w_strength_01',
        title: 'Hypertrophy Chest & Tris',
        description: 'AI Coach: "I noticed your bench press plateaued. We are increasing volume today to break through."',
        difficulty: 'Hard',
        durationMinutes: 60,
        exercises: [
          Exercise(
            id: 'e1',
            name: 'Barbell Bench Press',
            targetMuscle: 'Chest',
            targetSets: 4,
            targetReps: 6,
            lastWeight: 185.0,
            coachTip: 'Focus on explosive upward movement. Control the descent.',
          ),
          Exercise(
            id: 'e2',
            name: 'Incline Dumbbell Press',
            targetMuscle: 'Upper Chest',
            targetSets: 3,
            targetReps: 10,
            lastWeight: 60.0,
            coachTip: 'Keep elbows at 45 degrees to protect shoulders.',
          ),
          Exercise(
            id: 'e3',
            name: 'Tricep Rope Pushdown',
            targetMuscle: 'Triceps',
            targetSets: 4,
            targetReps: 12,
            lastWeight: 45.0,
            coachTip: 'Spread the rope at the bottom for maximum contraction.',
          ),
        ],
      );
    } else {
      return WorkoutPlan(
        id: 'w_cond_01',
        title: 'Metabolic Conditioning',
        description: 'AI Coach: "Your recovery rate is improving. Let\'s push the intensity with shorter rest periods."',
        difficulty: 'Medium',
        durationMinutes: 45,
        exercises: [
          Exercise(
            id: 'e4',
            name: 'Kettlebell Swings',
            targetMuscle: 'Full Body',
            targetSets: 4,
            targetReps: 20,
            coachTip: 'Drive through the hips, not the arms.',
          ),
          Exercise(
            id: 'e5',
            name: 'Box Jumps',
            targetMuscle: 'Legs',
            targetSets: 3,
            targetReps: 15,
            coachTip: 'Land softly to absorb impact.',
          ),
        ],
      );
    }
  }

  static UserStats getUserStats() {
    return UserStats(
      name: 'Alex',
      streakDays: 4,
      workoutsCompleted: 42,
      currentWeight: 175.5,
      goal: 'Build Muscle & Strength',
    );
  }
}
