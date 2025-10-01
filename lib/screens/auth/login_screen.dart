// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (mounted) {
      if (success) {
        if (authProvider.user?.role == 'admin') {
          Navigator.of(context).pushNamed('/admin');
        } else {
          Navigator.of(context).pushNamed('/home');
        }
      }

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Une erreur est survenue.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Le mot de passe doit contenir au moins 8 caractères.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Consumer<AuthProvider>(
                builder: (ctx, auth, _) => auth.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submit,
                  child: Text('Se Connecter'),
                ),
              ),
              // Ajoutez un bouton pour naviguer vers l'écran d'inscription
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => RegisterScreen()),
                  );
                },
                child: Text('Pas de compte ? S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}