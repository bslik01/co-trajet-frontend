// lib/widgets/trip_card.dart
import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;

  const TripCard({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${trip.villeDepart} → ${trip.villeArrivee}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${trip.prix.toStringAsFixed(0)} FCFA', // Affiche le prix sans décimales
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  ""//DateFormat('EEE d MMM yyyy', 'fr_FR').format(trip.dateDepart), // Formatage de la date
                ),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  ""//DateFormat('HH:mm').format(trip.dateDepart), // Formatage de l'heure
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(trip.conducteur.nom),
                Spacer(),
                Icon(Icons.event_seat, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('${trip.placesDisponibles} places'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
