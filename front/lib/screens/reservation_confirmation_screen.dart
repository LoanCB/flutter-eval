import 'package:flutter/material.dart';
import '../models/reservation.dart';
import 'package:intl/intl.dart';

class ReservationConfirmationScreen extends StatelessWidget {
  final ReservationFormData reservation;

  const ReservationConfirmationScreen({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirmation de réservation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Merci pour votre réservation !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailsCard(context),
            const SizedBox(height: 24),
            const Text(
              'Un e-mail de confirmation vous a été envoyé.',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nom', reservation.name),
            const SizedBox(height: 8),
            _buildDetailRow('Téléphone', reservation.phone),
            const SizedBox(height: 8),
            _buildDetailRow('Email', reservation.email),
            const SizedBox(height: 8),
            _buildDetailRow('Nombre de couverts', '${reservation.numberOfGuests}'),
            const SizedBox(height: 8),
            _buildDetailRow('Date', dateFormat.format(reservation.date)),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Heure',
              '${reservation.time.hour}:${reservation.time.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Statut : ${reservation.status}',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}
