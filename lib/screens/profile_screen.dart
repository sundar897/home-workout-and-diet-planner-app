import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/workout_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final ws = Provider.of<WorkoutService>(context);
    final u = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: u == null
          ? const Center(child: Text('No user'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.deepPurple.shade50,
                          child: Text(
                            u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U',
                            style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(u.email, style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Edit'))
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Stats Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem('Workouts', '${ws.workouts.length}'),
                            _statItem('Completed', '0'),
                            _statItem('Minutes', '${ws.workouts.fold<int>(0, (p, e) => p + e.durationMin)}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fitness Goals Section
                    const Text('Fitness Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _goalItem('Weight Goal', '70 kg', Icons.monitor_weight),
                            const Divider(),
                            _goalItem('Workout Days', '5 days/week', Icons.calendar_today),
                            const Divider(),
                            _goalItem('Daily Exercise', '30 minutes', Icons.timer),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Body Measurements
                    const Text('Body Measurements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _measurementItem('Height', '175 cm'),
                            _measurementItem('Weight', '68 kg'),
                            _measurementItem('BMI', '22.2'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Achievement Badges
                    const Text('Achievements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _achievementBadge('Beginner', Icons.emoji_events, Colors.brown),
                            _achievementBadge('Early Bird', Icons.wb_sunny, Colors.amber),
                            _achievementBadge('Consistent', Icons.repeat, Colors.green),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () => auth.logout().then((_) => Navigator.pushReplacementNamed(context, '/login')),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statItem(String title, String value) => Column(
        children: [
          Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      );

  Widget _goalItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _measurementItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _achievementBadge(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}