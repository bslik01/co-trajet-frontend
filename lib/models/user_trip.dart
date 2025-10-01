// lib/models/user.dart

class UserTrip {
  final String id;
  final String nom;
  final String email;

  UserTrip({
    required this.id,
    required this.nom,
    required this.email,
  });

  factory UserTrip.fromJson(Map<String, dynamic> json) {
    return UserTrip(
      id: json['id'] ?? json['_id'], // Gère les deux cas (_id ou id)
      nom: json['nom'],
      email: json['email'],
    );
  }
}