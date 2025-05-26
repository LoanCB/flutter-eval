import 'package:flutter/foundation.dart';

import '../models/restaurant_models.dart';
import '../services/reservation_service.dart';

class ReservationProvider extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();

  List<Reservation> _reservations = [];
  List<Reservation> _todayReservations = [];
  bool _isLoading = false;
  String? _error;

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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reservations = await _reservationService.getUserReservations();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTodayReservations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todayReservations = await _reservationService.getTodayReservations();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer une nouvelle réservation
  Future<bool> createReservation(CreateReservationRequest request) async {
    try {
      await _reservationService.createReservation(request);
      await loadUserReservations(); // Recharger les réservations
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Annuler une réservation
  Future<bool> cancelReservation(int reservationId) async {
    try {
      await _reservationService.cancelReservation(reservationId);
      await loadUserReservations(); // Recharger les réservations
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Obtenir les créneaux disponibles
  Future<List<String>> getAvailableTimeSlots(DateTime date) async {
    try {
      return await _reservationService.getAvailableTimeSlots(date);
    } catch (e) {
      _error = 'Erreur lors de la récupération des créneaux: $e';
      notifyListeners();
      return [];
    }
  }

  // Réinitialiser les données (utile lors de la déconnexion)
  void clear() {
    _reservations = [];
    _todayReservations = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
