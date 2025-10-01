// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/user/become_driver_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/user/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isAuthenticated = authProvider.isAuthenticated && user!= null;

    Widget _buildDriverStatusTile() {
      if (user == null || user.role == 'chauffeur') {
        return SizedBox.shrink(); // Ne rien afficher si on est déjà chauffeur ou pas connecté
      }

      switch (user.chauffeurRequestStatus) {
        case 'pending':
          return ListTile(
            leading: Icon(Icons.hourglass_top),
            title: Text('Demande en cours'),
            subtitle: Text('Votre demande est en cours de validation.'),
            enabled: false,
          );
        case 'rejected':
          return ListTile(
            leading: Icon(Icons.error_outline, color: Colors.red),
            title: Text('Devenir Chauffeur'),
            subtitle: Text('Votre dernière demande a été rejetée. Cliquez pour réessayer.'),
            onTap: () {
              Navigator.of(context).pop(); // Ferme le drawer
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => BecomeDriverScreen()));
            },
          );
        default: // 'none'
          return ListTile(
            leading: Icon(Icons.drive_eta),
            title: Text('Devenir Chauffeur'),
            onTap: () {
              Navigator.of(context).pop(); // Ferme le drawer
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => BecomeDriverScreen()));
            },
          );
      }
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(isAuthenticated ? 'Bonjour ${user!.nom}' : 'Menu Co-Trajet'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () => Navigator.of(context).pop(),
          ),
          if (isAuthenticated)
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Mon Profil'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
            ),
          if (isAuthenticated) Divider(),
          _buildDriverStatusTile(),
          if (isAuthenticated && user.role == '')
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Tableau de Bord Admin'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminDashboardScreen()));
              },
            ),
          Divider(),
          Expanded(child: Container()), // Pousse le logout en bas
          ListTile(
            leading: Icon(isAuthenticated ? Icons.exit_to_app : Icons.login),
            title: Text(isAuthenticated ? 'Déconnexion' : 'Connexion / Inscription'),
            onTap: () {
              Navigator.of(context).pop();
              if (isAuthenticated) {
                authProvider.logout(context);
              } else {
                Navigator.of(context).pushNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
