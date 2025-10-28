import 'package:flutter/material.dart';
import '../models/workout.dart';


class WorkoutCard extends StatelessWidget {
final Workout workout;
final VoidCallback onTap;
const WorkoutCard({super.key, required this.workout, required this.onTap});


@override
Widget build(BuildContext context) {
return Card(
elevation: 4,
margin: const EdgeInsets.symmetric(vertical: 8),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: ListTile(
onTap: onTap,
contentPadding: const EdgeInsets.all(12),
leading: Container(
	width: 64,
	height: 64,
	decoration: BoxDecoration(
		borderRadius: BorderRadius.circular(8),
		color: Colors.deepPurple.shade50,
	),
	child: Stack(alignment: Alignment.center, children: [
		const Icon(Icons.fitness_center, size: 34, color: Colors.deepPurple),
		// subtle play overlay to hint there's a video
		Positioned(
			right: 4,
			bottom: 4,
			child: Container(
				decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(6)),
				padding: const EdgeInsets.all(2),
				child: const Icon(Icons.play_arrow, size: 14, color: Colors.deepPurple),
			),
		)
	]),
),
title: Text(workout.title, style: const TextStyle(fontWeight: FontWeight.bold)),
subtitle: Text('${workout.level} • ${workout.durationMin} min'),
trailing: const Icon(Icons.arrow_forward_ios, size: 16),
),
);
}
}