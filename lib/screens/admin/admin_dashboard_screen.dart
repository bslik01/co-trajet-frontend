// lib/screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_drawer.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchChauffeurRequests();
    });
  }

  void _showRejectDialog(String userId) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Rejeter la demande'),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(hintText: 'Motif du rejet (optionnel)'),
        ),
        actions: [
          TextButton(child: Text('Annuler'), onPressed: () => Navigator.of(ctx).pop()),
          ElevatedButton(
            child: Text('Confirmer le rejet'),
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false)
                  .rejectRequest(userId, reasonController.text);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Demandes Chauffeurs'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
          )
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (ctx, adminProvider, _) {
          if (adminProvider.isLoading && adminProvider.pendingRequests.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          if (adminProvider.pendingRequests.isEmpty) {
            return Center(child: Text('Aucune demande en attente.'));
          }
          return ListView.builder(
            itemCount: adminProvider.pendingRequests.length,
            itemBuilder: (ctx, i) {
              final user = adminProvider.pendingRequests[i];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(user.nom),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => adminProvider.approveRequest(user.id),
                        tooltip: 'Approuver',
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _showRejectDialog(user.id),
                        tooltip: 'Rejeter',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
