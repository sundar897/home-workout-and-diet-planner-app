import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/workout_service.dart';
import '../widgets/workout_card.dart';
import '../services/auth_service.dart';
import 'workout_detail_screen.dart';


class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});
@override
Widget build(BuildContext context) {
final ws = Provider.of<WorkoutService>(context);
final auth = Provider.of<AuthService>(context);
return Scaffold(
appBar: AppBar(
title: const Text('Home'),
actions: [
IconButton(onPressed: () => Navigator.pushNamed(context, '/calendar'), icon: const Icon(Icons.calendar_month)),
PopupMenuButton<String>(
onSelected: (v) {
if (v == 'profile') Navigator.pushNamed(context, '/profile');
if (v == 'settings') Navigator.pushNamed(context, '/settings');
if (v == 'logout') {
auth.logout();
Navigator.pushReplacementNamed(context, '/login');
}
},
itemBuilder: (_) => const [
PopupMenuItem(value: 'profile', child: Text('Profile')),
PopupMenuItem(value: 'settings', child: Text('Settings')),
PopupMenuItem(value: 'logout', child: Text('Logout')),
],
)
],
),
body: Padding(
padding: const EdgeInsets.all(12),
child: Column(children: [
const SizedBox(height: 8),
Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
const Text('Recommended workouts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
TextButton(onPressed: () => Navigator.pushNamed(context, '/plans'), child: const Text('View all'))
]),
const SizedBox(height: 8),
Expanded(
child: ListView.builder(
itemCount: ws.workouts.length,
itemBuilder: (context, i) {
final w = ws.workouts[i];
return WorkoutCard(
workout: w,
onTap: () => Navigator.push(
context,
MaterialPageRoute(
builder: (_) => WorkoutDetailScreen(workoutId: w.id))),
);
},
),
)
]),
),
bottomNavigationBar: BottomNavigationBar(
onTap: (i) {
if (i == 0) Navigator.pushReplacementNamed(context, '/home');
if (i == 1) Navigator.pushNamed(context, '/diet');
if (i == 2) Navigator.pushNamed(context, '/progress');
},
items: const [
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Diet'),
BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
],
),
);
}
}