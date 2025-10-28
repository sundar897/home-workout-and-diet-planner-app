class AppUser {
final String id;
final String name;
final String email;


AppUser({required this.id, required this.name, required this.email});


Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email};


static AppUser fromMap(Map<String, dynamic> m) {
return AppUser(id: m['id'] ?? '', name: m['name'] ?? '', email: m['email'] ?? '');
}
}