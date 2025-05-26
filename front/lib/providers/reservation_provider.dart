import 'package:flutter/foundation.dart';

import '../models/restaurant_models.dart';
import '../services/reservation_service.dart';

class ReservationProvider extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();

  List<Reservation> _reservations = [];
  List<Reservation> _todayReservations = [];
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();

  // Getters
  List<Reservation> get reservations => _reservations;
  List<Reservation> get todayReservations => _todayReservations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Statistiques
  int get totalReservations => _reservations.length;
  int get confirmedReservations =>
      _reservations.where((r) => r.status == 'confirmed').length;
  int get pendingReservations =>
      _reservations.where((r) => r.status == 'pending').length;

  // Charger les réservations de l'utilisateur
  Future<void> loadUserReservations() async {
    _setLoading(true);
    _clearError();

    try {
      _reservations = await _reservationService.getUserReservations();
      _clearError();
    } catch (e) {
      _setError('Erreur lors du chargement des réservations: $e');
    }

    _setLoading(false);
  }

  // Créer une nouvelle réservation
  Future<bool> createReservation(CreateReservationRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final newReservation = await _reservationService.createReservation(
        request,
      );
      _reservations.add(newReservation);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Erreur lors de la création de la réservation: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Annuler une réservation
  Future<bool> cancelReservation(int reservationId) async {
    _setLoading(true);
    _clearError();

    try {
      await _reservationService.cancelReservation(reservationId);
      _reservations.removeWhere((r) => r.id == reservationId);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Erreur lors de l\'annulation de la réservation: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Obtenir les créneaux disponibles
  Future<List<String>> getAvailableTimeSlots(DateTime date) async {
    try {
      return await _reservationService.getAvailableTimeSlots(date);
    } catch (e) {
      _setError('Erreur lors de la récupération des créneaux: $e');
      return [];
    }
  }

  // Charger les réservations pour la date sélectionnée
  Future<void> loadTodayReservations() async {
    _setLoading(true);
    _clearError();

    try {
      _todayReservations = await _reservationService.getReservationsForDate(
        _selectedDate,
      );
      _clearError();
    } catch (e) {
      _setError('Erreur lors du chargement des réservations du jour: $e');
    }

    _setLoading(false);
  }

  // Changer la date sélectionnée
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    loadTodayReservations();
  }

  // Réinitialiser les données (utile lors de la déconnexion)
  void clear() {
    _reservations = [];
    _todayReservations = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Méthodes privées
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
