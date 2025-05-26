import '../models/restaurant_models.dart';
import '../services/auth_service.dart';

class ReservationService {
  final AuthService _authService = AuthService();

  // Données fictives pour simuler l'API
  static final List<Reservation> _mockReservations = [
    Reservation(
      id: 1,
      date: DateTime.now().add(const Duration(days: 2)),
      time: '19:30',
      numberOfGuests: 4,
      status: 'confirmed',
      specialRequests: 'Table près de la fenêtre',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Reservation(
      id: 2,
      date: DateTime.now().add(const Duration(days: 7)),
      time: '20:00',
      numberOfGuests: 2,
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    // Ajout de réservations pour aujourd'hui
    Reservation(
      id: 3,
      date: DateTime.now(),
      time: '12:30',
      numberOfGuests: 3,
      status: 'confirmed',
      specialRequests: 'Allergie aux fruits de mer',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Reservation(
      id: 4,
      date: DateTime.now(),
      time: '19:00',
      numberOfGuests: 6,
      status: 'pending',
      specialRequests: 'Table pour anniversaire',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Reservation(
      id: 5,
      date: DateTime.now(),
      time: '20:30',
      numberOfGuests: 2,
      status: 'confirmed',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Obtenir toutes les réservations de l'utilisateur connecté
  Future<List<Reservation>> getUserReservations() async {
    // Pour l'instant, retourne des données fictives
    // Dans une vraie app, on ferait un appel API
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simule la latence réseau
    return _mockReservations;
  }

  // Obtenir toutes les réservations du jour
  Future<List<Reservation>> getTodayReservations() async {
    if (!_authService.isLoggedIn) {
      throw ReservationException('Vous devez être connecté pour voir les réservations');
    }

    // Vérifier si l'utilisateur est un hôte
    if (_authService.user?.role != 'host') {
      throw ReservationException('Accès réservé aux hôtes');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    final today = DateTime.now();
    final todayReservations = _mockReservations.where((reservation) {
      return reservation.date.year == today.year &&
          reservation.date.month == today.month &&
          reservation.date.day == today.day;
    }).toList();

    // Trier les réservations par heure
    todayReservations.sort((a, b) => a.time.compareTo(b.time));

    return todayReservations;
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
    final newReservation = Reservation(
      id: _mockReservations.length + 1,
      date: request.date,
      time: request.time,
      numberOfGuests: request.numberOfGuests,
      status: 'pending',
      specialRequests: request.specialRequests,
      createdAt: DateTime.now(),
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
