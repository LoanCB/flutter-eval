import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_models.dart';
import '../services/auth_service.dart';
import '../config/api_config.dart';

class ReservationService {
  final AuthService _authService = AuthService();

  // Données fictives pour simuler l'API
  static final List<Reservation> _mockReservations = [
    Reservation(
      id: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      numberOfGuests: 4,
      reservationDate: DateTime.now().add(const Duration(days: 2)).copyWith(hour: 12, minute: 0),
      status: 'CONFIRMED',
      user: {
        'id': 1,
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
      },
      table: {
        'id': 1,
        'tableNumber': '1',
        'capacity': 4,
      },
      timeSlot: {
        'id': 1,
        'start': DateTime.now().add(const Duration(days: 2)).copyWith(hour: 12, minute: 0).toIso8601String(),
        'end': DateTime.now().add(const Duration(days: 2)).copyWith(hour: 13, minute: 0).toIso8601String(),
        'availableSeats': 4,
      },
    ),
    Reservation(
      id: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      numberOfGuests: 2,
      reservationDate: DateTime.now().add(const Duration(days: 7)).copyWith(hour: 19, minute: 0),
      status: 'PENDING',
      user: {
        'id': 1,
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
      },
      table: {
        'id': 2,
        'tableNumber': '2',
        'capacity': 2,
      },
      timeSlot: {
        'id': 2,
        'start': DateTime.now().add(const Duration(days: 7)).copyWith(hour: 19, minute: 0).toIso8601String(),
        'end': DateTime.now().add(const Duration(days: 7)).copyWith(hour: 20, minute: 0).toIso8601String(),
        'availableSeats': 2,
      },
    ),
  ];

  // Obtenir toutes les réservations de l'utilisateur connecté
  Future<List<Reservation>> getUserReservations() async {
    if (!_authService.isLoggedIn) {
      throw ReservationException('Vous devez être connecté pour voir vos réservations');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiBasePath}/reservations/my-reservations');

    try {
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(_authService.token!),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        throw ReservationException('Erreur lors de la récupération des réservations');
      }
    } catch (e) {
      throw ReservationException('Erreur de connexion: ${e.toString()}');
    }
  }

  // Créer une nouvelle réservation
  Future<Reservation> createReservation(
    CreateReservationRequest request,
  ) async {
    if (!_authService.isLoggedIn) {
      throw ReservationException('Vous devez être connecté pour réserver');
    }

    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 800));

    // Simule une nouvelle réservation
    final startTime = DateTime.parse(request.time);
    final now = DateTime.now();
    final newReservation = Reservation(
      id: _mockReservations.length + 1,
      createdAt: now,
      updatedAt: now,
      numberOfGuests: request.numberOfGuests,
      reservationDate: request.date.copyWith(
        hour: startTime.hour,
        minute: startTime.minute,
      ),
      status: 'PENDING',
      user: {
        'id': 1,
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
      },
      table: {
        'id': 1,
        'tableNumber': '1',
        'capacity': request.numberOfGuests,
      },
      timeSlot: {
        'id': _mockReservations.length + 1,
        'start': request.date.copyWith(
          hour: startTime.hour,
          minute: startTime.minute,
        ).toIso8601String(),
        'end': request.date.copyWith(
          hour: startTime.hour + 1,
          minute: startTime.minute,
        ).toIso8601String(),
        'availableSeats': request.numberOfGuests,
      },
    );

    _mockReservations.add(newReservation);
    return newReservation;
  }

  // Annuler une réservation
  Future<void> cancelReservation(int reservationId) async {
    if (!_authService.isLoggedIn) {
      throw ReservationException('Vous devez être connecté');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // Trouve et met à jour le statut
    final index = _mockReservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      // Dans une vraie app, on recréerait l'objet avec le nouveau statut
      // Ici on simule juste la suppression
      _mockReservations.removeAt(index);
    }
  }

  // Obtenir les créneaux disponibles pour une date
  Future<List<String>> getAvailableTimeSlots(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Retourne des créneaux fictifs
    return [
      '12:00',
      '12:30',
      '13:00',
      '13:30',
      '14:00',
      '19:00',
      '19:30',
      '20:00',
      '20:30',
      '21:00',
      '21:30',
      '22:00',
    ];
  }

  // Obtenir les réservations pour une date spécifique
  Future<List<Reservation>> getReservationsForDate(DateTime date) async {
    // Simule la latence réseau
    await Future.delayed(const Duration(milliseconds: 500));

    // Filtre les réservations pour la date donnée et les trie par horaire
    return _mockReservations
        .where((reservation) =>
            reservation.date.year == date.year &&
            reservation.date.month == date.month &&
            reservation.date.day == date.day)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }
  
  // Obtenir les places disponibles
  Future<List<Map<String, dynamic>>> getAvailableSeats({
    required String date,
    int? seats,
  }) async {
    if (!_authService.isLoggedIn) {
      throw ReservationException('Vous devez être connecté pour voir les places disponibles');
    }

    // Construire l'URL avec les paramètres de requête
    final queryParams = <String, String>{
      'date': date,
    };
    if (seats != null) {
      queryParams['seats'] = seats.toString();
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiBasePath}/reservations/available')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(_authService.token!),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw ReservationException('Erreur lors de la récupération des places disponibles');
      }
    } catch (e) {
      throw ReservationException('Erreur de connexion: ${e.toString()}');
    }
  }

  // Créer une réservation avec horaire
  Future<Map<String, dynamic>> createReservationWithTime({
    required int tableId,
    required String startTime,
    required int numberOfGuests,
  }) async {
    if (!_authService.isLoggedIn) {
      throw ReservationException('Vous devez être connecté pour réserver');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiBasePath}/reservations/with-time');

    try {
      final response = await http.post(
        uri,
        headers: ApiConfig.authHeaders(_authService.token!),
        body: json.encode({
          'tableId': tableId,
          'startTime': startTime,
          'numberOfGuests': numberOfGuests,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw ReservationException('Erreur lors de la création de la réservation');
      }
    } catch (e) {
      throw ReservationException('Erreur de connexion: ${e.toString()}');
    }
  }

  // Dans une vraie implémentation, ces méthodes feraient des appels HTTP:

  /*
  Future<List<Reservation>> getUserReservations() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiBasePath}/reservations'),
      headers: ApiConfig.authHeaders(_authService.token!),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw ReservationException('Erreur lors de la récupération des réservations');
    }
  }

  Future<Reservation> createReservation(CreateReservationRequest request) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiBasePath}/reservations'),
      headers: ApiConfig.authHeaders(_authService.token!),
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return Reservation.fromJson(json.decode(response.body));
    } else {
      throw ReservationException('Erreur lors de la création de la réservation');
    }
  }
  */
}

class ReservationException implements Exception {
  final String message;

  ReservationException(this.message);

  @override
  String toString() => message;
}
