// lib/screens/trips/create_trip_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _villeDepartController = TextEditingController();
  final _villeArriveeController = TextEditingController();
  final _placesController = TextEditingController();
  final _prixController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _villeDepartController.dispose();
    _villeArriveeController.dispose();
    _placesController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs et sélectionner une date.')),
      );
      return;
    }

    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final success = await tripProvider.createTrip(
      villeDepart: _villeDepartController.text,
      villeArrivee: _villeArriveeController.text,
      dateDepart: _selectedDate!.toIso8601String(),
      placesDisponibles: int.parse(_placesController.text),
      prix: double.parse(_prixController.text),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trajet publié avec succès !'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(); // Retour à l'écran d'accueil
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tripProvider.errorMessage ?? 'Erreur de publication'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Publier un trajet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _villeDepartController,
                  decoration: InputDecoration(labelText: 'Ville de départ'),
                  validator: (v) => v!.isEmpty ? 'Champ requis' : null,
                ),
                TextFormField(
                  controller: _villeArriveeController,
                  decoration: InputDecoration(labelText: 'Ville d\'arrivée'),
                  validator: (v) => v!.isEmpty ? 'Champ requis' : null,
                ),
                TextFormField(
                  controller: _placesController,
                  decoration: InputDecoration(labelText: 'Places disponibles'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Champ requis' : null,
                ),
                TextFormField(
                  controller: _prixController,
                  decoration: InputDecoration(labelText: 'Prix par place (FCFA)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Champ requis' : null,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Aucune date sélectionnée'
                            : 'Date : ${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text('Choisir la date'),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Consumer<TripProvider>(
                  builder: (ctx, tripProvider, _) => tripProvider.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          child: Text('Publier le trajet'),
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
