import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../theme/app_theme.dart';
import '../models/fitness_models.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentExerciseIndex = 0;
  final Map<String, List<bool>> _completedSets = {}; // Exercise ID -> List of completed sets

  @override
  void initState() {
    super.initState();
    // Initialize completion tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workout = Provider.of<FitnessProvider>(context, listen: false).todaysWorkout;
      if (workout != null) {
        for (var ex in workout.exercises) {
          _completedSets[ex.id] = List.filled(ex.targetSets, false);
        }
        setState(() {});
      }
    });
  }

  void _toggleSet(String exerciseId, int setIndex) {
    setState(() {
      _completedSets[exerciseId]![setIndex] = !_completedSets[exerciseId]![setIndex];
    });
  }

  bool _isWorkoutComplete() {
    return _completedSets.values.every((sets) => sets.every((completed) => completed));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final workout = provider.todaysWorkout;

    if (workout == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final currentExercise = workout.exercises[_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.title),
        actions: [
          TextButton(
            onPressed: () {
              // Finish workout logic
              provider.completeWorkout();
              Navigator.pop(context);
            },
            child: const Text('FINISH', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentExerciseIndex + 1) / workout.exercises.length,
            backgroundColor: AppTheme.surfaceColor,
            color: AppTheme.primaryColor,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Header
                  Text(
                    'EXERCISE ${_currentExerciseIndex + 1}/${workout.exercises.length}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentExercise.name,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentExercise.targetMuscle.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  
                  const SizedBox(height: 24),

                  // AI Coach Tip
                  if (currentExercise.coachTip != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.tips_and_updates, color: AppTheme.secondaryColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'COACH TIP: ${currentExercise.coachTip}',
                              style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Sets Tracker
                  Text(
                    'SETS & REPS',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentExercise.targetSets,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final isCompleted = _completedSets[currentExercise.id]?[index] ?? false;
                      
                      return InkWell(
                        onTap: () => _toggleSet(currentExercise.id, index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: isCompleted ? AppTheme.primaryColor.withOpacity(0.2) : AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCompleted ? AppTheme.primaryColor : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCompleted ? AppTheme.primaryColor : Colors.white10,
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isCompleted ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${currentExercise.targetReps} REPS',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 16),
                                  if (currentExercise.lastWeight != null)
                                    Text(
                                      '${currentExercise.lastWeight} LBS',
                                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    ),
                                ],
                              ),
                              if (isCompleted)
                                const Icon(Icons.check, color: AppTheme.primaryColor),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                if (_currentExerciseIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentExerciseIndex--;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('PREVIOUS', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                if (_currentExerciseIndex > 0)
                  const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentExerciseIndex < workout.exercises.length - 1) {
                        setState(() {
                          _currentExerciseIndex++;
                        });
                      } else {
                        // Finish workout
                        provider.completeWorkout();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      _currentExerciseIndex < workout.exercises.length - 1 ? 'NEXT EXERCISE' : 'COMPLETE WORKOUT',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
