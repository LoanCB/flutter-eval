class TimeSlot {
  final String time;
  final int availableSeats;
  final int totalSeats;

  TimeSlot({
    required this.time,
    required this.availableSeats,
    required this.totalSeats,
  });

  bool get isAvailable => availableSeats > 0;

  double get occupancyRate => (totalSeats - availableSeats) / totalSeats;
}

class Restaurant {
  final String name;
  final String description;
  final int totalTables;
  final List<String> openingHours;

  Restaurant({
    required this.name,
    required this.description,
    required this.totalTables,
    required this.openingHours,
  });
}

class Reservation {
  final String id;
  final DateTime date;
  final String timeSlot;
  final String customerName;
  final String customerPhone;
  final int numberOfGuests;
  final String status; // 'pending', 'confirmed', 'cancelled'

  Reservation({
    required this.id,
    required this.date,
    required this.timeSlot,
    required this.customerName,
    required this.customerPhone,
    required this.numberOfGuests,
    this.status = 'pending',
  });
}
