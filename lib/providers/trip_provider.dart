// lib/providers/trip_provider.dart
import 'package:flutter/material.dart';
import '../models/mytrip.dart';
import '../models/trip.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class TripProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final ApiService _apiService = ApiService();

  TripProvider(this._authProvider) {
    fetchTrips();
  }

  List<Trip> _trips = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<MyTrip> _myTrips = [];
  List<MyTrip> get myTrips => _myTrips;

  Future<void> fetchTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> tripData = await _apiService.getTrips();
      _trips = tripData.map((data) => Trip.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTrip({
    required String villeDepart,
    required String villeArrivee,
    required String dateDepart,
    required int placesDisponibles,
    required double prix,
  }) async
  {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.createTrip(
        villeDepart: villeDepart,
        villeArrivee: villeArrivee,
        dateDepart: dateDepart,
        placesDisponibles: placesDisponibles,
        prix: prix,
      );
      // Après une création réussie, rafraîchir la liste des trajets
      await fetchTrips();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchMyTrips() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<dynamic> tripData = await _apiService.getMyTrips();
      print(tripData);
      _myTrips = tripData.map((data) => MyTrip.fromJson(data)).toList();
      print(_myTrips);
    } catch (e) {
      print(e);
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}