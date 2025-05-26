class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imageUrl;
  final bool available;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.available,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
      available: json['available'] ?? true,
    );
  }
}

class Reservation {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int numberOfGuests;
  final DateTime reservationDate;
  final String status;
  final Map<String, dynamic> user;
  final Map<String, dynamic> table;
  final Map<String, dynamic> timeSlot;

  Reservation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.numberOfGuests,
    required this.reservationDate,
    required this.status,
    required this.user,
    required this.table,
    required this.timeSlot,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      numberOfGuests: json['numberOfGuests'],
      reservationDate: DateTime.parse(json['reservationDate']),
      status: json['status'],
      user: json['user'],
      table: json['table'],
      timeSlot: json['timeSlot'],
    );
  }

  // Helper getters for backward compatibility
  DateTime get date => reservationDate;
  DateTime get start => DateTime.parse(timeSlot['start']);
  DateTime get end => DateTime.parse(timeSlot['end']);
  String get time => '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
}

class CreateReservationRequest {
  final DateTime date;
  final String time;
  final int numberOfGuests;
  final String? specialRequests;

  CreateReservationRequest({
    required this.date,
    required this.time,
    required this.numberOfGuests,
    this.specialRequests,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'time': time,
      'numberOfGuests': numberOfGuests,
      'specialRequests': specialRequests,
    };
  }
}
