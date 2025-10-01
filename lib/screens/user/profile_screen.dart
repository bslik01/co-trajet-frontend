import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/mytrip_card.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _myTripsFuture = Future.value();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _myTripsFuture = Provider.of<TripProvider>(context, listen: false).fetchMyTrips();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user!;

    return Scaffold(
      appBar: AppBar(title: Text('Mon Profil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.nom, style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 8),
              Text(user.email, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16),
              Chip(
                label: Text(user.role == 'chauffeur' ? 'Chauffeur' : user.role == 'passager' ? 'Passager' : 'Administrateur'),
                backgroundColor: user.role == 'chauffeur' ? Colors.teal[100] : Colors.grey[200],
              ),
              Divider(height: 40),
              if (user.role == 'chauffeur' && user.isChauffeurVerified)
                _buildMyTripsSection(context)
              else if (user.role == 'passager' && user.chauffeurRequestStatus != 'none')
                _buildDriverStatusSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyTripsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mes Trajets Publiés', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 10),
        FutureBuilder(
          future: _myTripsFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Consumer<TripProvider>(
              builder: (ctx, tripData, child) => tripData.myTrips.isEmpty
                  ? Text('Vous n\'avez publié aucun trajet.')
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tripData.myTrips.length,
                itemBuilder: (ctx, i) => MyTripCard(trip: tripData.myTrips[i]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDriverStatusSection(BuildContext context) {
    final status = Provider.of<AuthProvider>(context, listen: false).user!.chauffeurRequestStatus;
    switch (status) {
      case 'pending':
        return Text('Statut Chauffeur : Demande en cours de validation.');
      case 'rejected':
        return Text('Statut Chauffeur : Votre dernière demande a été rejetée.');
      default:
        return Text('Statut Chauffeur : Vous n\'êtes pas encore chauffeur.');
    }
  }
}
