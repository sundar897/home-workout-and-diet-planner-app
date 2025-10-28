import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProgressTrackerScreen extends StatefulWidget {
const ProgressTrackerScreen({super.key});
@override
State<ProgressTrackerScreen> createState() => _ProgressTrackerScreenState();
}


class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {
double progress = 0.25; // example progress, you can wire this to persistent store


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Progress')),
body: Padding(
padding: const EdgeInsets.all(16),
					child: Column(children: [
				Text('Weekly Goal Progress', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
				const SizedBox(height: 16),
				Card(
					child: Padding(
						padding: const EdgeInsets.all(12),
						child: Row(children: [
							Expanded(
								child: Column(children: [
									SizedBox(
										height: 120,
										child: Center(
											child: Stack(alignment: Alignment.center, children: [
												SizedBox(
													width: 110,
													height: 110,
													child: CircularProgressIndicator(value: progress, strokeWidth: 10),
												),
												Text('${(progress * 100).toStringAsFixed(0)}%', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
											]),
										),
									),
									const SizedBox(height: 8),
									ElevatedButton(
										onPressed: () {
											setState(() {
												progress += 0.1;
												if (progress > 1) progress = 1;
											});
										},
										child: const Text('Mark progress'),
									),
								]),
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
									Text('Goal: 3 workouts', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
									const SizedBox(height: 8),
									Text('Completed 1 of 3', style: TextStyle(color: Colors.grey.shade600)),
									const SizedBox(height: 12),
									const Divider(),
									const SizedBox(height: 8),
									Text('Recent', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
									const SizedBox(height: 8),
									_activityItem('Full Body Beginner', '20 min'),
									_activityItem('Cardio Burn', '15 min'),
								]),
							)
						]),
					),
				),
				const SizedBox(height: 20),
				Text('History', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
				const SizedBox(height: 8),
				Expanded(
					child: ListView(children: [
						ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: const Text('Completed Cardio Burn'), subtitle: const Text('2 days ago')),
						ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: const Text('Completed Core Strength'), subtitle: const Text('5 days ago')),
					]),
				)
			]),
),
);
}

Widget _activityItem(String title, String subtitle) => ListTile(contentPadding: EdgeInsets.zero, title: Text(title), subtitle: Text(subtitle));
}