import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

import 'package:google_fonts/google_fonts.dart';


class SettingsScreen extends StatefulWidget {
const SettingsScreen({super.key});
@override
State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
@override
Widget build(BuildContext context) {
final theme = Provider.of<ThemeService>(context);
return Scaffold(
			appBar: AppBar(title: const Text('Settings')),
			body: ListView(padding: const EdgeInsets.all(12), children: [
				Text('Preferences', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
				const SizedBox(height: 8),
				Card(
					child: Column(children: [
						SwitchListTile(
							title: const Text('Dark Mode'),
							value: theme.isDark,
							onChanged: (v) => theme.setDark(v),
						),
						SwitchListTile(
							title: const Text('Enable Notifications'),
							value: true,
							onChanged: (v) {},
						),
						ListTile(title: const Text('Units'), subtitle: const Text('Metric'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
					]),
				),
				const SizedBox(height: 12),
				Text('Account', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
				const SizedBox(height: 8),
				Card(
					child: Column(children: [
						ListTile(title: const Text('Manage Account'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
						ListTile(title: const Text('Privacy'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
						ListTile(title: const Text('About'), subtitle: const Text('Home Workout & Diet Planner • v1.0.0')),
					]),
				),
			]),
		);
}
}