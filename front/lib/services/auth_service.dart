import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/auth_models.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  User? _user;

  // Getters
  String? get token => _token;
  User? get user => _user;
  bool get isLoggedIn => _token != null && _user != null;

  // Initialize service - load stored token and user
  Future<void> initialize() async {
    print('🔐 [AUTH_SERVICE] Initialisation...');
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    print('🔐 [AUTH_SERVICE] Token trouvé: ${_token?.substring(0, 20)}...');

    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        _user = User.fromJson(json.decode(userJson));
        print('🔐 [AUTH_SERVICE] Utilisateur trouvé: ${_user?.email}');
      } catch (e) {
        print('🔐 [AUTH_SERVICE] Erreur parsing utilisateur: $e');
        // Si erreur de parsing, on supprime les données corrompues
        await logout();
      }
    } else {
      print('🔐 [AUTH_SERVICE] Aucun utilisateur sauvegardé');
    }

    // Vérifier si le token est encore valide
    if (_token != null && _user != null) {
      print('🔐 [AUTH_SERVICE] Validation du token...');
      final isValid = await _validateToken();
      if (!isValid) {
        print('🔐 [AUTH_SERVICE] Token invalide, déconnexion');
        await logout();
      } else {
        print('🔐 [AUTH_SERVICE] Token valide !');
      }
    }

    print(
      '🔐 [AUTH_SERVICE] Initialisation terminée - isLoggedIn: $isLoggedIn',
    );
  }

  // Login
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      print('🔐 [AUTH] Tentative de connexion...');
      print('🔐 [AUTH] URL: ${ApiConfig.loginUrl}');
      print('🔐 [AUTH] Headers: ${ApiConfig.defaultHeaders}');
      print('🔐 [AUTH] Body: ${json.encode(request.toJson())}');

      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(request.toJson()),
      );

      print('🔐 [AUTH] Status Code: ${response.statusCode}');
      print('🔐 [AUTH] Response Headers: ${response.headers}');
      print('🔐 [AUTH] Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final authResponse = AuthResponse.fromJson(data);

        // Stocker le token et l'utilisateur
        await _storeAuthData(authResponse.accessToken, authResponse.user);

        print('🔐 [AUTH] Connexion réussie !');
        return authResponse;
      } else {
        print('🔐 [AUTH] Erreur HTTP: ${response.statusCode}');
        final errorData = json.decode(response.body);
        throw AuthException(
          errorData['message'] ?? 'Erreur de connexion',
          response.statusCode,
        );
      }
    } catch (e) {
      print('🔐 [AUTH] Exception attrapée: $e');
      print('🔐 [AUTH] Type d\'exception: ${e.runtimeType}');
      if (e is AuthException) rethrow;
      throw AuthException('Erreur de connexion au serveur: $e', 500);
    }
  }

  // Register
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      print('📝 [AUTH] Tentative d\'inscription...');
      print('📝 [AUTH] URL: ${ApiConfig.registerUrl}');
      print('📝 [AUTH] Headers: ${ApiConfig.defaultHeaders}');
      print('📝 [AUTH] Body: ${json.encode(request.toJson())}');

      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(request.toJson()),
      );

      print('📝 [AUTH] Status Code: ${response.statusCode}');
      print('📝 [AUTH] Response Headers: ${response.headers}');
      print('📝 [AUTH] Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final authResponse = AuthResponse.fromJson(data);

        // Stocker le token et l'utilisateur
        await _storeAuthData(authResponse.accessToken, authResponse.user);

        print('📝 [AUTH] Inscription réussie !');
        return authResponse;
      } else {
        print('📝 [AUTH] Erreur HTTP: ${response.statusCode}');
        final errorData = json.decode(response.body);
        throw AuthException(
          errorData['message'] ?? 'Erreur lors de l\'inscription',
          response.statusCode,
        );
      }
    } catch (e) {
      print('📝 [AUTH] Exception attrapée: $e');
      print('📝 [AUTH] Type d\'exception: ${e.runtimeType}');
      if (e is AuthException) rethrow;
      throw AuthException('Erreur de connexion au serveur: $e', 500);
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    _token = null;
    _user = null;
  }

  // Get current user profile
  Future<User> getCurrentUser() async {
    if (_token == null) {
      throw AuthException('Non authentifié', 401);
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.profileUrl),
        headers: ApiConfig.authHeaders(_token!),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data);

        // Mettre à jour l'utilisateur stocké
        await _updateStoredUser(user);

        return user;
      } else {
        throw AuthException(
          'Erreur lors de la récupération du profil',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erreur de connexion au serveur', 500);
    }
  }

  // Private methods
  Future<void> _storeAuthData(String token, User user) async {
    print('🔐 [AUTH_SERVICE] Sauvegarde des données auth...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user.toJson()));
    _token = token;
    _user = user;
    print('🔐 [AUTH_SERVICE] Données sauvegardées: ${user.email}');
  }

  Future<void> _updateStoredUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    _user = user;
  }

  Future<bool> _validateToken() async {
    try {
      await getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Test de connectivité au backend
  Future<bool> testConnection() async {
    try {
      print('🌐 [TEST] Test de connectivité au backend...');
      print('🌐 [TEST] URL de test: ${ApiConfig.baseUrl}');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/v1/health'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(const Duration(seconds: 10));

      print('🌐 [TEST] Status Code: ${response.statusCode}');
      print('🌐 [TEST] Response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('🌐 [TEST] Erreur de connectivité: $e');
      print('🌐 [TEST] Type d\'erreur: ${e.runtimeType}');
      return false;
    }
  }
}

class AuthException implements Exception {
  final String message;
  final int statusCode;

  AuthException(this.message, this.statusCode);

  @override
  String toString() => message;
}
