import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/diet_service.dart';


class DietPlansScreen extends StatelessWidget {
const DietPlansScreen({super.key});
@override
Widget build(BuildContext context) {
final ds = Provider.of<DietService>(context);
return Scaffold(
appBar: AppBar(title: const Text('Diet Plans')),
body: ListView.builder(
padding: const EdgeInsets.all(12),
itemCount: ds.diets.length,
itemBuilder: (context, i) {
final d = ds.diets[i];
return Card(
margin: const EdgeInsets.symmetric(vertical: 8),
child: ExpansionTile(
title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold)),
children: d.meals.map((m) {
return ListTile(
title: Text(m['title']),
subtitle: Text('${m['time']} • ${m['calories']} kcal'),
);
}).toList(),
),
);
},
),
);
}
}