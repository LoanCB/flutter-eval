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
  final DateTime date;
  final String time;
  final int numberOfGuests;
  final String status;
  final String? specialRequests;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.date,
    required this.time,
    required this.numberOfGuests,
    required this.status,
    this.specialRequests,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      numberOfGuests: json['numberOfGuests'],
      status: json['status'],
      specialRequests: json['specialRequests'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
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
