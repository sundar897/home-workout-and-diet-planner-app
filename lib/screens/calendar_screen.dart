import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../services/workout_service.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();
  Map<String, List<String>> events = {}; // date -> list of workout ids

  List<String> _eventsFor(DateTime d) {
    final key = d.toIso8601String().split('T').first;
    return events[key] ?? [];
  }

  void _scheduleWorkout(DateTime date, String workoutId) {
    final key = date.toIso8601String().split('T').first;
    final list = events[key] ?? [];
    list.add(workoutId);
    events[key] = list;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ws = Provider.of<WorkoutService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focused,
            selectedDayPredicate: (day) => isSameDay(day, _selected),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selected = selectedDay;
                _focused = focusedDay;
              });
            },
            eventLoader: _eventsFor,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: ws.workouts
                        .map(
                          (w) => DropdownMenuItem(
                            value: w.id,
                            child: Text(w.title),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        _scheduleWorkout(_selected, val);
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Schedule workout'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: _eventsFor(_selected).map((id) {
                final w = ws.getById(id);
                final title = w?.title ?? 'Workout';
                return Card(
                  child: ListTile(title: Text(title)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
