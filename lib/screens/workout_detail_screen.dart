import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/workout_service.dart';
import 'exercise_player_screen.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final String workoutId;
  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    final ws = Provider.of<WorkoutService>(context);
    final w = ws.getById(workoutId);

    if (w == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: const Center(child: Text('Not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(w.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              w.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${w.durationMin} min • ${w.level}'),
            const SizedBox(height: 12),
            Text(w.description),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExercisePlayerScreen(
                      videoUrl: w.videoUrl,
                      title: w.title,
                    ),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 720),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade600
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_fill,
                          size: 42, color: Colors.white),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Play Workout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${w.durationMin} min • ${w.level}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
