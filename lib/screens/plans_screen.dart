import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/workout_service.dart';
import '../widgets/workout_card.dart';
import 'workout_detail_screen.dart';


class PlansScreen extends StatelessWidget {
const PlansScreen({super.key});
@override
Widget build(BuildContext context) {
final ws = Provider.of<WorkoutService>(context);
return Scaffold(
appBar: AppBar(title: const Text('All Plans')),
body: Padding(
padding: const EdgeInsets.all(12),
child: ListView.builder(
itemCount: ws.workouts.length,
itemBuilder: (context, i) {
final w = ws.workouts[i];
return WorkoutCard(
workout: w,
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutDetailScreen(workoutId: w.id))),
);
},
),
),
);
}
}