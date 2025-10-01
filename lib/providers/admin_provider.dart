// lib/providers/admin_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class AdminProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final ApiService _apiService = ApiService();

  AdminProvider(this._authProvider);

  List<User> _pendingRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChauffeurRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final List<dynamic> requestsData = await _apiService.getChauffeurRequests();
      _pendingRequests = requestsData.map((data) => User.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> approveRequest(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.approveChauffeurRequest(userId);
      // Retirer la demande de la liste locale et rafraîchir
      _pendingRequests.removeWhere((user) => user.id == userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectRequest(String userId, String reason) async {
    // ... Logique similaire à approveRequest
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.rejectChauffeurRequest(userId, reason);
      _pendingRequests.removeWhere((user) => user.id == userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
