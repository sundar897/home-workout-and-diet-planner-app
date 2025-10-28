class DietPlan {
final String id;
final String name;
final List<Map<String, dynamic>> meals; // each meal: {time, title, calories}


DietPlan({required this.id, required this.name, required this.meals});


Map<String, dynamic> toMap() => {'id': id, 'name': name, 'meals': meals};


static DietPlan fromMap(Map<String, dynamic> m) => DietPlan(
id: m['id'] ?? '',
name: m['name'] ?? '',
meals: List<Map<String, dynamic>>.from(m['meals'] ?? []),
);
}