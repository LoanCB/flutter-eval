import 'package:flutter/material.dart';
import '../models/restaurant_models.dart';
import '../services/reservation_service.dart';

class DailyReservationsScreen extends StatefulWidget {
  const DailyReservationsScreen({super.key});

  @override
  State<DailyReservationsScreen> createState() => _DailyReservationsScreenState();
}

class _DailyReservationsScreenState extends State<DailyReservationsScreen> {
  final ReservationService _reservationService = ReservationService();
  List<Reservation> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final allReservations = await _reservationService.getUserReservations();
      final today = DateTime.now();
      final todayReservations = allReservations.where((reservation) {
        return reservation.date.year == today.year &&
            reservation.date.month == today.month &&
            reservation.date.day == today.day;
      }).toList();

      // Trier les réservations par heure
      todayReservations.sort((a, b) => a.time.compareTo(b.time));

      setState(() {
        _reservations = todayReservations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmée';
      case 'pending':
        return 'En attente';
      case 'cancelled':
        return 'Annulée';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservations du jour'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reservations.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune réservation pour aujourd\'hui',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadReservations,
                  child: ListView.builder(
                    itemCount: _reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = _reservations[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(reservation.status),
                            child: Text(
                              reservation.numberOfGuests.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            '${reservation.time} - ${reservation.numberOfGuests} personnes',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Statut: ${_getStatusText(reservation.status)}',
                                style: TextStyle(
                                  color: _getStatusColor(reservation.status),
                                ),
                              ),
                              if (reservation.specialRequests != null &&
                                  reservation.specialRequests!.isNotEmpty)
                                Text(
                                  'Note: ${reservation.specialRequests}',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
} 