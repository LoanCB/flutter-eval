import 'package:flutter/foundation.dart';

import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _authService.isLoggedIn;
  User? get user => _authService.user;
  String? get token => _authService.token;

  // Initialize
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _authService.initialize();
      _clearError();
      print(
        '🔐 [PROVIDER] Initialisation terminée - isLoggedIn: ${_authService.isLoggedIn}',
      );
      if (_authService.isLoggedIn) {
        print('🔐 [PROVIDER] Utilisateur trouvé: ${_authService.user?.email}');
      }
    } catch (e) {
      print('🔐 [PROVIDER] Erreur d\'initialisation: $e');
      _setError('Erreur d\'initialisation: $e');
    }
    _setLoading(false);
  }

  // Login
  Future<bool> login(String email, String password) async {
    print('🔐 [PROVIDER] Début login pour: $email');
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(email: email, password: password);
      print('🔐 [PROVIDER] Appel du service login...');
      await _authService.login(request);
      _clearError();
      print('🔐 [PROVIDER] Login réussi !');
      notifyListeners();
      return true;
    } catch (e) {
      print('🔐 [PROVIDER] Erreur login: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<bool> register(
    String email,
    String password,
    String confirmPassword,
    String firstName,
    String lastName,
  ) async {
    print('📝 [PROVIDER] Début inscription pour: $email');
    _setLoading(true);
    _clearError();

    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
      );
      print('📝 [PROVIDER] Appel du service register...');
      await _authService.register(request);
      _clearError();
      print('📝 [PROVIDER] Inscription réussie !');
      notifyListeners();
      return true;
    } catch (e) {
      print('📝 [PROVIDER] Erreur inscription: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Erreur lors de la déconnexion: $e');
    }
    _setLoading(false);
  }

  // Test de connectivité
  Future<bool> testConnection() async {
    print('🌐 [PROVIDER] Test de connectivité...');
    _setLoading(true);

    try {
      final isConnected = await _authService.testConnection();
      print('🌐 [PROVIDER] Résultat du test: $isConnected');
      return isConnected;
    } catch (e) {
      print('🌐 [PROVIDER] Erreur test connectivité: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user data
  Future<void> refreshUser() async {
    _setLoading(true);
    try {
      await _authService.getCurrentUser();
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Erreur lors de la mise à jour du profil: $e');
    }
    _setLoading(false);
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
