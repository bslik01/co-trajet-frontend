// lib/models/trip.dart
import 'user_trip.dart';

class Trip {
  final String id;
  final String villeDepart;
  final String villeArrivee;
  final DateTime dateDepart;
  final int placesDisponibles;
  final double prix;
  final UserTrip conducteur; // L'API renvoie l'objet conducteur imbriqué

  Trip({
    required this.id,
    required this.villeDepart,
    required this.villeArrivee,
    required this.dateDepart,
    required this.placesDisponibles,
    required this.prix,
    required this.conducteur,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'],
      villeDepart: json['villeDepart'],
      villeArrivee: json['villeArrivee'],
      dateDepart: DateTime.parse(json['dateDepart']),
      placesDisponibles: json['placesDisponibles'],
      prix: (json['prix'] as num).toDouble(), // Conversion sécurisée en double
      conducteur: UserTrip.fromJson(json['conducteur']),
    );
  }
}
