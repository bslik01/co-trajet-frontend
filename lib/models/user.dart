// lib/models/user.dart

class User {
  final String id;
  final String nom;
  final String email;
  final String role;
  final bool isChauffeurVerified;
  final String chauffeurRequestStatus;

  User({
    required this.id,
    required this.nom,
    required this.email,
    required this.role,
    required this.isChauffeurVerified,
    required this.chauffeurRequestStatus,
  });

  // Factory constructor pour créer une instance de User depuis une map JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'], // Gère les deux cas (_id ou id)
      nom: json['nom'],
      email: json['email'],
      role: json['role'],
      isChauffeurVerified: json['isChauffeurVerified'] ?? false,
      chauffeurRequestStatus: json['chauffeurRequestStatus'] ?? 'none',
    );
  }
}