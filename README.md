# Restaurant "Le Délice" - Application Flutter

Une application de restaurant complète avec un frontend Flutter et un backend NestJS, permettant la gestion des réservations et la consultation du menu.

## 📋 Table des matières

- [Structure du projet](#structure-du-projet)
- [Prérequis](#prérequis)
- [Installation et lancement](#installation-et-lancement)
- [Configuration](#configuration)
- [API Backend](#api-backend)
- [Application Flutter](#application-flutter)
- [Base de données](#base-de-données)
- [Fonctionnalités](#fonctionnalités)
- [Architecture](#architecture)
- [Mockups](#mockups)

## 🔧 Prérequis

### Pour le backend :

- [Node.js](https://nodejs.org/) (version 18+)
- [Docker](https://www.docker.com/) et Docker Compose
- [Make](https://www.gnu.org/software/make/) (pour utiliser le Makefile)

### Pour le frontend :

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.7.0+)
- [Dart SDK](https://dart.dev/get-dart) (inclus avec Flutter)
- Un émulateur Android/iOS ou un appareil physique

### IDE recommandés :

- [Visual Studio Code](https://code.visualstudio.com/) avec les extensions Flutter et Dart
- [Android Studio](https://developer.android.com/studio)

## 🚀 Installation et lancement

### 1. Backend (API NestJS)

```bash
# Aller dans le dossier backend
cd back

# Configuration initiale complète (recommandé pour la première fois)
make init
```

Cette commande va :

- Créer le fichier `.env` à partir de `.env.sample`
- Demander les informations de base de données
- Lancer les containers Docker
- Exécuter les migrations
- Créer un utilisateur initial

**Ou lancement manuel :**

```bash
# 1. Créer le fichier .env
make env

# 2. Lancer les services Docker
make start

# 3. Exécuter les migrations
make migrate

# 4. Créer un utilisateur initial
make create-user
```

**Commandes utiles :**

```bash
# Arrêter les services
make stop

# Voir les logs
docker-compose logs -f app

# Relancer seulement l'API
docker-compose restart app
```

### 2. Frontend (Application Flutter)

```bash
# Aller dans le dossier frontend
cd front

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

**Ou avec VS Code :**

- Ouvrir le dossier `front` dans VS Code
- Appuyer sur `F5` ou utiliser la palette de commandes (`Cmd+Shift+P`) → "Flutter: Run Flutter Application"

## ⚙️ Configuration

### Backend (.env)

Le fichier `.env` sera créé automatiquement avec `make env`. Principales variables :

```env
NODE_ENV=dev
API_VERSION=1
PORT=3010
APP_URL=http://localhost:3010

# Base de données PostgreSQL
POSTGRES_HOST=172.17.0.1
POSTGRES_PORT=5434
POSTGRES_USERNAME=votre_username
POSTGRES_PASSWORD=votre_password
POSTGRES_NAME=flutter_eval_back

# JWT
JWT_SECRET=clé_générée_automatiquement
JWT_DURATION=86400
```

### Frontend

La configuration de l'API est dans `front/lib/config/api_config.dart` :

```dart
static const String baseUrl = 'http://localhost:3010';
static const String apiBasePath = '/api/v1';
```

## 🔗 API Backend

### Endpoints principaux

- **Base URL :** `http://localhost:3010/api/v1`
- **Documentation Swagger :** `http://localhost:3010/api-docs`

### Modules disponibles :

#### 🔐 Authentification (`/auth`)

- `POST /auth/register` - Inscription
- `POST /auth/login` - Connexion
- `GET /auth/profile` - Profil utilisateur

#### 🍽️ Menu (`/menu`)

- `GET /menu` - Liste des plats
- `GET /menu/:id` - Détail d'un plat

#### 📅 Réservations (`/reservations`)

- `POST /reservations` - Créer une réservation
- `GET /reservations` - Liste des réservations
- `GET /reservations/available` - Créneaux disponibles

#### 👥 Utilisateurs (`/users`)

- Gestion des utilisateurs (admin)

## 📱 Application Flutter

### Fonctionnalités

1. **Écran d'accueil** - Présentation du restaurant
2. **Menu** - Consultation des plats par catégorie
3. **Réservations** - Système de réservation de tables
4. **Authentification** - Connexion/inscription
5. **Profil** - Gestion du compte utilisateur

### Dépendances principales

```yaml
dependencies:
  flutter: sdk
  http: ^1.2.0 # Requêtes API
  shared_preferences: ^2.2.2 # Stockage local
  provider: ^6.1.1 # Gestion d'état
  intl: ^0.18.0 # Formatage des dates
```

## 🗄️ Base de données

### PostgreSQL avec Docker

La base de données PostgreSQL est automatiquement configurée via Docker Compose.

**Structure principale :**

- `users` - Utilisateurs et rôles
- `menu_items` - Plats du menu
- `tables` - Tables du restaurant
- `time_slots` - Créneaux horaires
- `reservations` - Réservations
- `activity_logs` - Logs d'activité

### Migrations

```bash
# Exécuter les migrations
make migrate

# Créer une nouvelle migration
npm run migration:create --name=NomDeLaMigration

# Générer une migration automatique
npm run migration:generate --migrname=NomDeLaMigration
```

## ✨ Fonctionnalités

### 👤 Gestion des utilisateurs

- Inscription et connexion
- Trois rôles : Administrateur, Hôte, Client
- Profil utilisateur modifiable

### 🍽️ Système de menu

- Affichage des plats par catégorie
- Détails des plats (prix, description, disponibilité)
- Interface intuitive et moderne

### 📅 Système de réservation

- Sélection de la date et heure
- Choix du nombre de convives
- Attribution automatique ou manuelle des tables
- Gestion des créneaux disponibles

### 🔐 Sécurité

- Authentification JWT
- Garde d'autorisation par rôle
- Validation des données d'entrée
- Logs d'activité détaillés

## 🏗️ Architecture

### Backend (NestJS)

- **Modular** - Architecture modulaire par domaine
- **TypeORM** - ORM pour PostgreSQL
- **Guards** - Système d'autorisation
- **Interceptors** - Logging automatique
- **Swagger** - Documentation API automatique

### Frontend (Flutter)

- **Provider** - Gestion d'état réactive
- **Services** - Couche d'abstraction pour l'API
- **Responsive** - Interface adaptative
- **Material Design** - Design moderne et cohérent

## 🎨 Mockups

Les maquettes du projet sont disponibles sur Figma :
[Voir les mockups](https://www.figma.com/design/lpnpFS2QQ2xnHKd6VGLdFl/flutter-restaurant?node-id=0-1&t=xBtO9Dn4KgMCsIXG-1)

## 🔧 Développement

### Backend

```bash
# Mode développement avec hot reload
npm run start:dev

# Build de production
npm run build

# Tests
npm run test
```

### Frontend

```bash
# Mode développement
flutter run

# Build pour Android
flutter build apk

# Build pour iOS
flutter build ios

# Tests
flutter test
```

## 📝 Notes importantes

1. **Première utilisation :** Utilisez `make init` pour une configuration automatique complète
2. **Base de données :** Les containers Docker doivent être lancés avant l'API
3. **Migrations :** Exécutez les migrations après chaque pull du code
4. **Utilisateur initial :** Le script `create-user` permet de créer un compte administrateur
5. **Hot reload :** Les modifications du code sont automatiquement rechargées en mode développement

## 🚨 Dépannage

### Backend ne démarre pas

- Vérifiez que Docker est lancé
- Vérifiez le fichier `.env`
- Regardez les logs : `docker-compose logs app`

### Frontend ne se connecte pas à l'API

- Vérifiez que l'API est accessible sur `http://localhost:3010`
- Vérifiez la configuration dans `api_config.dart`
- En cas d'erreur CORS, l'API est configurée pour accepter toutes les origines en développement

### Problèmes de base de données

- Recréez les volumes : `docker-compose down -v && docker-compose up -d`
- Réexécutez les migrations : `make migrate`
