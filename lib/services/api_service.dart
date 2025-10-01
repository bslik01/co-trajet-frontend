import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/auth_provider.dart';

class ApiService {
  late Dio _dio;
  String? _token;

  // Singleton pour une instance unique
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: 5000),
        receiveTimeout: Duration(milliseconds: 3000),
      ),
    );

    // Ajout de l'intercepteur
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null && _token!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options); // Continue la requête
      },
      onError: (DioException e, handler) {
        // Si l'erreur est une erreur 401 (non autorisé)
        if (e.response?.statusCode == 401) {
          // Utiliser le navigatorKey pour accéder au contexte global
          final context = navigatorKey.currentContext;
          if (context != null) {
            // Récupérer l'AuthProvider
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            // Vérifier si l'utilisateur était authentifié (pour ne pas déconnecter si déjà déconnecté)
            if (authProvider.isAuthenticated) {
              // Déconnecter et afficher le message "Session expirée"
              authProvider.handleSessionExpired(context);
            }
          }
        }
        return handler.next(e); // Continue la propagation de l'erreur
      },
    ));
  }

  // Méthode pour mettre à jour le token
  void setToken(String? token) {
    _token = token;
  }

  // Méthode pour l'inscription
  Future<Map<String, dynamic>> register({
    required String nom,
    required String email,
    required String motDePasse,
  }) async
  {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'nom': nom,
          'email': email,
          'motDePasse': motDePasse,
        },
      );
      return response.data; // Le backend renvoie { message, token, user }
    } on DioException catch (e) {
      // Gérer les erreurs de manière plus fine (ex: e.response.data['message'])
      throw Exception('Échec de l\'inscription: ${e.response?.data['message'] ?? e.message}');
    }
  }

  // Méthode pour la connexion
  Future<Map<String, dynamic>> login({
    required String email,
    required String motDePasse,
  }) async
  {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'motDePasse': motDePasse,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Échec de la connexion: ${e.response?.data['message'] ?? e.message}');
    }
  }

  // Méthode pour rechercher des trajets
  Future<List<dynamic>> getTrips({String? villeDepart, String? villeArrivee, String? dateDepart}) async
  {
    try {
      final response = await _dio.get(
        '/api/trips',
        queryParameters: {
          if (villeDepart != null) 'villeDepart': villeDepart,
          if (villeArrivee != null) 'villeArrivee': villeArrivee,
          if (dateDepart != null) 'dateDepart': dateDepart,
        },
      );
      return response.data['trips'];
    } on DioException catch (e) {
      throw Exception('Échec de la récupération des trajets: ${e.response?.data['message'] ?? e.message}');
    }
  }

  // Méthode pour créer un trajet
  Future<void> createTrip({
    required String villeDepart,
    required String villeArrivee,
    required String dateDepart,
    required int placesDisponibles,
    required double prix,
  })
  async {
    try {
      final response = await _dio.post('/api/trips', data: {
        'villeDepart': villeDepart,
        'villeArrivee': villeArrivee,
        'dateDepart': dateDepart,
        'placesDisponibles': placesDisponibles,
        'prix': prix,
      });
      print(response.data);
    } on DioException catch (e) {
      throw Exception('Échec de la création du trajet: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> requestChauffeurStatus({
    required String permisConduireUrl,
    required String carteGriseUrl,
  })
  async {
    try {
      final response = await _dio.put('/api/users/become-chauffeur', data: {
        'permisConduireUrl': permisConduireUrl,
        'carteGriseUrl': carteGriseUrl,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception('Échec de la demande: ${e.response?.data['errors'][0]['msg']}');
    }
  }

  Future<List<dynamic>> getChauffeurRequests() async {
    try {
      final response = await _dio.get('/api/admin/chauffeur-requests');
      return response.data['requests'];
    } on DioException catch (e) {
      throw Exception('Échec de la demande: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<void> approveChauffeurRequest(String userId) async {
    try {
      await _dio.put('/api/admin/chauffeur-requests/$userId/approve');
    } on DioException catch (e) { /* ... */ }
  }

  Future<void> rejectChauffeurRequest(String userId, String reason) async {
    try {
      await _dio.put('/api/admin/chauffeur-requests/$userId/reject', data: {'chauffeurRequestMessage': reason});
    } on DioException catch (e) { /* ... */ }
  }

  Future<List<dynamic>> getMyTrips() async {
    try {
      final response = await _dio.get('/api/users/me/trips');
      return response.data['trips'];
    } on DioException catch (e) {
      throw Exception('Échec de la demande: ${e.response?.data['message'] ?? e.message}');
    }
  }
}