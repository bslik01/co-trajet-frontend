// lib/models/trip.dart
import 'user_trip.dart';

class MyTrip {
  final String id;
  final String villeDepart;
  final String villeArrivee;
  final DateTime dateDepart;
  final int placesDisponibles;
  final double prix;
  final String conducteur;

  MyTrip({
    required this.id,
    required this.villeDepart,
    required this.villeArrivee,
    required this.dateDepart,
    required this.placesDisponibles,
    required this.prix,
    required this.conducteur,
  });

  factory MyTrip.fromJson(Map<String, dynamic> json) {
    return MyTrip(
      id: json['_id'],
      villeDepart: json['villeDepart'],
      villeArrivee: json['villeArrivee'],
      dateDepart: DateTime.parse(json['dateDepart']),
      placesDisponibles: json['placesDisponibles'],
      prix: (json['prix'] as num).toDouble(), // Conversion sécurisée en double
      conducteur: json['conducteur'],
    );
  }
}
