// lib/utils/constants.dart
import 'dart:io' show Platform;

// Détermine l'URL de base de l'API en fonction de la plateforme
final String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:5000' : 'http://localhost:5000';