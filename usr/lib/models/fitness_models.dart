class Exercise {
  final String id;
  final String name;
  final String targetMuscle;
  final int targetSets;
  final int targetReps;
  final double? lastWeight;
  final String? coachTip;

  Exercise({
    required this.id,
    required this.name,
    required this.targetMuscle,
    required this.targetSets,
    required this.targetReps,
    this.lastWeight,
    this.coachTip,
  });
}

class WorkoutPlan {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final int durationMinutes;
  final List<Exercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.durationMinutes,
    required this.exercises,
  });
}

class UserStats {
  final String name;
  final int streakDays;
  final int workoutsCompleted;
  final double currentWeight;
  final String goal;

  UserStats({
    required this.name,
    required this.streakDays,
    required this.workoutsCompleted,
    required this.currentWeight,
    required this.goal,
  });
}
