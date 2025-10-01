// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/admin_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'providers/trip_provider.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Le MultiProvider permet de fournir plusieurs providers à l'application
    return MultiProvider(
      providers: [
        // On encapsule AuthProvider dans un FutureProvider pour charger
        // l'état d'authentification au démarrage de l'app une seule fois.
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
        ChangeNotifierProxyProvider<AuthProvider, TripProvider>(
          create: (context) => TripProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previousTrips) => TripProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AdminProvider>(
          create: (context) => AdminProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previousAdmin) => AdminProvider(auth),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Co-Trajet',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(), // Démarrer directement sur l'écran d'accueil
        // Nous utiliserons un système de navigation pour les écrans d'authentification
        routes: {
          '/home': (ctx) => HomeScreen(),
          '/admin': (ctx) => AdminDashboardScreen(),
          '/login': (ctx) => LoginScreen(),
          '/register': (ctx) => RegisterScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Écoute les changements de l'AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);

    // Pour le premier chargement, on peut tenter une connexion auto
    // et afficher un écran de chargement.
    return FutureBuilder(
      future: authProvider.tryAutoLogin(),
      builder: (ctx, snapshot) {
        //if (snapshot.connectionState == ConnectionState.waiting) {
        //  return Scaffold(body: Center(child: CircularProgressIndicator()));
        //}

        // Après la tentative, on vérifie si l'utilisateur est authentifié
        if (authProvider.isAuthenticated) {
          if (authProvider.user?.role == 'admin') {
            return AdminDashboardScreen();
          } else {
            return HomeScreen();
          }
        } else {
          return LoginScreen();
        }
      },
    );
  }
}