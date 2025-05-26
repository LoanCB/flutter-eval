import 'package:flutter/material.dart';

class ReservationFormData {
  final String name;
  final String phone;
  final String email;
  final int numberOfGuests;
  final DateTime date;
  final TimeOfDay time;
  String status;

  ReservationFormData({
    required this.name,
    required this.phone,
    required this.email,
    required this.numberOfGuests,
    required this.date,
    required this.time,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'numberOfGuests': numberOfGuests,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'status': status,
    };
  }
}
