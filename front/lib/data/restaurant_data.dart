import '../models/restaurant_models.dart';

class RestaurantData {
  static final Restaurant restaurant = Restaurant(
    name: "La Table Nomade",
    description: "Un restaurant français authentique au cœur de la ville",
    totalTables: 20,
    openingHours: [
      "11:30",
      "12:00",
      "12:30",
      "13:00",
      "13:30",
      "14:00",
      "19:00",
      "19:30",
      "20:00",
      "20:30",
      "21:00",
      "21:30",
    ],
  );

  // Données fictives de réservations existantes
  static final List<Reservation> existingReservations = [
    Reservation(
      id: "1",
      date: DateTime.now(),
      timeSlot: "12:00",
      customerName: "Jean Dupont",
      customerPhone: "0123456789",
      numberOfGuests: 4,
      status: 'confirmed',
    ),
    Reservation(
      id: "2",
      date: DateTime.now(),
      timeSlot: "12:00",
      customerName: "Marie Martin",
      customerPhone: "0987654321",
      numberOfGuests: 2,
      status: 'confirmed',
    ),
    Reservation(
      id: "3",
      date: DateTime.now(),
      timeSlot: "19:30",
      customerName: "Pierre Durand",
      customerPhone: "0147258369",
      numberOfGuests: 6,
      status: 'confirmed',
    ),
    Reservation(
      id: "4",
      date: DateTime.now().add(const Duration(days: 1)),
      timeSlot: "20:00",
      customerName: "Sophie Leroy",
      customerPhone: "0165432198",
      numberOfGuests: 3,
      status: 'confirmed',
    ),
  ];

  static List<TimeSlot> getAvailableTimeSlots(
    DateTime selectedDate,
    int numberOfGuests,
  ) {
    // Calcule la disponibilité pour chaque créneau
    List<TimeSlot> timeSlots = [];

    for (String time in restaurant.openingHours) {
      // Compte les places occupées pour ce créneau à cette date
      int occupiedSeats = existingReservations
          .where(
            (reservation) =>
                reservation.date.year == selectedDate.year &&
                reservation.date.month == selectedDate.month &&
                reservation.date.day == selectedDate.day &&
                reservation.timeSlot == time &&
                reservation.status == 'confirmed',
          )
          .fold(0, (sum, reservation) => sum + reservation.numberOfGuests);

      // Capacité totale fictive par créneau (nombre de places disponibles)
      int totalSeatsForSlot = _getTotalSeatsForTimeSlot(time);
      int availableSeats = totalSeatsForSlot - occupiedSeats;

      timeSlots.add(
        TimeSlot(
          time: time,
          availableSeats: availableSeats,
          totalSeats: totalSeatsForSlot,
        ),
      );
    }

    return timeSlots;
  }

  static int _getTotalSeatsForTimeSlot(String time) {
    // Différentes capacités selon les créneaux (données fictives)
    switch (time) {
      case "11:30":
      case "12:00":
      case "12:30":
        return 40; // Service du midi moins chargé
      case "13:00":
      case "13:30":
      case "14:00":
        return 60; // Pic du déjeuner
      case "19:00":
      case "19:30":
      case "20:00":
        return 80; // Service du soir très demandé
      case "20:30":
      case "21:00":
      case "21:30":
        return 50; // Fin de service du soir
      default:
        return 40;
    }
  }

  static bool isRestaurantOpen(DateTime date) {
    // Fermé le dimanche et les jours fériés (logique simplifiée)
    return date.weekday != DateTime.sunday;
  }
}
