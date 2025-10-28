class Workout {
final String id;
final String title;
final String description;
final int durationMin;
final String videoUrl;
final String level; // Beginner/Intermediate/Advanced


Workout({
required this.id,
required this.title,
required this.description,
required this.durationMin,
required this.videoUrl,
required this.level,
});


Map<String, dynamic> toMap() => {
'id': id,
'title': title,
'description': description,
'durationMin': durationMin,
'videoUrl': videoUrl,
'level': level
};


static Workout fromMap(Map<String, dynamic> m) => Workout(
id: m['id'] ?? '',
title: m['title'] ?? '',
description: m['description'] ?? '',
durationMin: (m['durationMin'] is int) ? m['durationMin'] : int.tryParse('${m['durationMin']}') ?? 10,
videoUrl: m['videoUrl'] ?? '',
level: m['level'] ?? 'Beginner',
);
}