// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> login(String email, String motDePasse) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiService.login(email: email, motDePasse: motDePasse);
      _user = User.fromJson(response['user']);
      _token = response['token'];
      _apiService.setToken(_token); // Mettre à jour le token dans le service

      await _storage.write(key: 'jwt_token', value: _token);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout([BuildContext? context]) async {
    _user = null;
    _token = null;
    _apiService.setToken(null);
    await _storage.delete(key: 'jwt_token');

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Déconnexion réussie.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    }

    notifyListeners();
  }

  // Ajoutez la méthode register de la même manière
  Future<bool> register({required String nom, required String email, required String motDePasse}) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiService.register(nom: nom, email: email, motDePasse: motDePasse);
      _user = User.fromJson(response['user']);
      _token = response['token'];
      _apiService.setToken(_token); // Mettre à jour le token dans le service

      await _storage.write(key: 'jwt_token', value: _token);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Méthode pour tenter de se connecter automatiquement au démarrage de l'app
  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      return;
    }
    // Ici, vous devriez idéalement vérifier la validité du token
    // en faisant un appel à une route protégée comme /api/users/me.
    // Pour le MVP, on fait confiance au token s'il existe.
    _token = token;
    _apiService.setToken(_token); // Mettre à jour le token dans le service
    // Vous pourriez aussi stocker les infos de l'utilisateur dans le secure storage
    // et les recharger ici pour éviter un appel API au démarrage.
    notifyListeners();
  }

  Future<bool> requestChauffeurStatus({
    required String permisUrl,
    required String carteGriseUrl,
  }) async {
    final token = await _storage.read(key: 'jwt_token');
    _token = token;
    _apiService.setToken(_token);
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiService.requestChauffeurStatus(
        permisConduireUrl: permisUrl,
        carteGriseUrl: carteGriseUrl,
      );
      _user = User.fromJson(response['user']);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> handleSessionExpired(BuildContext context) async {
    _user = null;
    _token = null;
    _apiService.setToken(null);
    await _storage.delete(key: 'jwt_token');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Session expirée. Veuillez vous reconnecter.'),
          backgroundColor: Colors.orange,
        ),
      );
    }

    notifyListeners();
  }
}