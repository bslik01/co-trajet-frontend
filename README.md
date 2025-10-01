# co_trajet

co_trajet est une application mobile Flutter dédiée au covoiturage et à la gestion de trajets. Elle propose une expérience utilisateur moderne et intuitive pour organiser, rechercher et réserver des trajets partagés.

## Sommaire
- [Fonctionnalités](#fonctionnalités)
- [Captures d'écran](#captures-décran)
- [Prise en main](#prise-en-main)
- [Structure du projet](#structure-du-projet)
- [Dépendances](#dépendances)
- [Compilation & Exécution](#compilation--exécution)
- [Contribuer](#contribuer)
- [Licence](#licence)
- [Contact](#contact)

## Fonctionnalités
- Authentification et gestion de profil utilisateur
- Création, recherche et réservation de trajets
- Notifications en temps réel
- Interface utilisateur ergonomique
- Gestion des trajets favoris

## Captures d'écran
_Ajoutez ici des captures d'écran de l'application_

## Prise en main

### Prérequis
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/)
- Un appareil ou émulateur Android/iOS

### Installation
1. **Cloner le dépôt :**
   ```bash
   git clone https://github.com/votre-utilisateur/co_trajet.git
   cd co_trajet
   ```
2. **Installer les dépendances :**
   ```bash
   flutter pub get
   ```
3. **Lancer l'application :**
   ```bash
   flutter run
   ```

## Structure du projet

```
lib/
  ├── main.dart
  ├── screens/
  ├── widgets/
  ├── providers/
  ├── models/
  └── ...
android/
ios/
test/
```
- `screens/` : Écrans et pages de l'application
- `widgets/` : Composants UI réutilisables
- `providers/` : Gestion d'état (Provider)
- `models/` : Modèles de données

## Dépendances principales
- [provider](https://pub.dev/packages/provider)
- [http](https://pub.dev/packages/http)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [cupertino_icons](https://pub.dev/packages/cupertino_icons)

Consultez `pubspec.yaml` pour la liste complète.

## Compilation & Exécution
- **Android :**
  ```bash
  flutter run
  ```
- **iOS :**
  ```bash
  flutter run
  ```

## Contribuer
Les contributions sont les bienvenues !
1. Forkez le dépôt
2. Créez votre branche (`git checkout -b feature/MaFonctionnalite`)
3. Commitez vos modifications (`git commit -am 'Ajout d'une fonctionnalité'`)
4. Poussez la branche (`git push origin feature/MaFonctionnalite`)
5. Ouvrez une Pull Request

## Licence
Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus d'informations.

## Contact
Pour toute question ou suggestion, contactez : [votre.email@example.com](mailto:votre.email@example.com)
