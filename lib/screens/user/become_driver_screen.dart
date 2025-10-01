// lib/screens/user/become_driver_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class BecomeDriverScreen extends StatefulWidget {
  @override
  _BecomeDriverScreenState createState() => _BecomeDriverScreenState();
}

class _BecomeDriverScreenState extends State<BecomeDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _permisController = TextEditingController();
  final _carteGriseController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.requestChauffeurStatus(
      permisUrl: _permisController.text,
      carteGriseUrl: _carteGriseController.text,
    );
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Demande envoyée avec succès !'),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(authProvider.errorMessage ?? 'Erreur lors de l\'envoi'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  void dispose() {
    _permisController.dispose();
    _carteGriseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Devenir Chauffeur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Veuillez fournir les URLs de vos documents. Dans une version future, vous pourrez les télécharger directement.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _permisController,
                decoration: InputDecoration(labelText: 'URL du Permis de Conduire'),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _carteGriseController,
                decoration: InputDecoration(labelText: 'URL de la Carte Grise'),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              SizedBox(height: 30),
              Consumer<AuthProvider>(
                builder: (ctx, auth, _) => auth.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submit,
                        child: Text('Soumettre la demande'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
