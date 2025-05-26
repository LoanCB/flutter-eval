import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/reservation_provider.dart';
import '../models/restaurant_models.dart';

class ReservationsListScreen extends StatefulWidget {
  const ReservationsListScreen({super.key});

  @override
  State<ReservationsListScreen> createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final provider = Provider.of<ReservationProvider>(context, listen: false);
    await provider.loadTodayReservations();
    await provider.loadUserReservations();
  }
  Widget _buildReservationCard(Reservation reservation) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final date = DateTime.parse(reservation.date.toString());
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Réservation pour ${reservation.numberOfGuests} personne(s)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(reservation.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(reservation.status),
                style: TextStyle(
                  color: _getStatusColor(reservation.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today, dateFormat.format(date)),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.person, reservation.customerName),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.phone, reservation.customerPhone),
          ],
        ),
        trailing: reservation.status == 'pending'
            ? IconButton(
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Annuler la réservation'),
                      content: const Text('Voulez-vous vraiment annuler cette réservation ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Non'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Oui',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    final provider = Provider.of<ReservationProvider>(
                      context,
                      listen: false,
                    );
                    await provider.cancelReservation(int.parse(reservation.id));
                    await _loadReservations();
                  }
                },
              )
            : null,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
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
    switch (status) {
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
        title: const Text(
          'Mes réservations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[700],
      ),
      body: RefreshIndicator(
        onRefresh: _loadReservations,
        child: Consumer<ReservationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }

            return ListView(
              children: [
                // Today's reservations section
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Réservations du jour',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (provider.todayReservations.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Aucune réservation aujourd\'hui',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else                ...provider.todayReservations
                    .map(_buildReservationCard)
                    .toList(),

                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Réservations à venir',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...provider.reservations
                    .where((r) {
                      final reservationDate = DateTime.parse(r.date.toString());
                      final today = DateTime.now();
                      return reservationDate.isAfter(
                        DateTime(today.year, today.month, today.day + 1),
                      );
                    })
                    .where((r) => r.status != 'cancelled')
                    .toList()
                    .sorted((a, b) {
                      final dateA = DateTime.parse(a.date.toString());
                      final dateB = DateTime.parse(b.date.toString());
                      return dateA.compareTo(dateB);
                    })
                    .map(_buildReservationCard)
                    .toList(),

                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
