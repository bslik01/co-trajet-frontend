// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/trip_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/trip_card.dart';
import 'trips/create_trip_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charge les trajets au démarrage de l'écran
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    //  Provider.of<TripProvider>(context, listen: false).fetchTrips();
    //});
  }

  @override
  Widget build(BuildContext context) {
    // Ici, on utilise Consumer pour reconstruire uniquement les parties qui dépendent de l'état de connexion
    return Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) {
          final isAuthenticated = authProvider.isAuthenticated;
          final isChauffeur = isAuthenticated &&
              authProvider.user?.role == 'chauffeur' &&
              authProvider.user!.isChauffeurVerified;

          return Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
              title: Text('Trajets Disponibles'),
              actions: [
                if (!isAuthenticated)
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child: Text('Connexion', style: TextStyle(color: Colors.white)),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      authProvider.logout(context);
                    },
                  )
              ],
            ),
            body: Consumer<TripProvider>(
              builder: (ctx, tripProvider, _) {
                if (tripProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (tripProvider.errorMessage != null) {
                  return Center(child: Text(tripProvider.errorMessage!));
                }
                if (tripProvider.trips.isEmpty) {
                  return Center(
                      child: Text('Aucun trajet disponible pour le moment.'));
                }
                return ListView.builder(
                  itemCount: tripProvider.trips.length,
                  itemBuilder: (ctx, index) =>
                      TripCard(trip: tripProvider.trips[index]),
                );
              },
            ),
            floatingActionButton: isChauffeur
                ? FloatingActionButton(
              onPressed: () {
                // Naviguer vers l'écran de création de trajet
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => CreateTripScreen()),
                );
              },
              child: Icon(Icons.add),
              tooltip: 'Publier un trajet',
            )
                : null, // Pas de bouton si l'utilisateur n'est pas un chauffeur vérifié
          );
        }
    );
  }
}