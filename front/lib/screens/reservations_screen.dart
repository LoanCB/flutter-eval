import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant_models.dart';
import '../providers/reservation_provider.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les réservations au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReservationProvider>(
        context,
        listen: false,
      ).loadUserReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationProvider>(
      builder: (context, reservationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mes Réservations'),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Quick stats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.calendar_today,
                          label: 'Réservations',
                          value: '${reservationProvider.totalReservations}',
                        ),
                        _StatItem(
                          icon: Icons.check_circle,
                          label: 'Confirmées',
                          value: '${reservationProvider.confirmedReservations}',
                        ),
                        _StatItem(
                          icon: Icons.pending,
                          label: 'En attente',
                          value: '${reservationProvider.pendingReservations}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Error message
                if (reservationProvider.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      reservationProvider.error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),

                // Loading or Reservations list
                Expanded(
                  child:
                      reservationProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : reservationProvider.reservations.isEmpty
                          ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Aucune réservation',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            itemCount: reservationProvider.reservations.length,
                            itemBuilder: (context, index) {
                              final reservation =
                                  reservationProvider.reservations[index];
                              return _ReservationCard(
                                reservation: reservation,
                                onCancel:
                                    () => _cancelReservation(
                                      reservation.id,
                                      reservationProvider,
                                    ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed:
                () => _showNewReservationDialog(context, reservationProvider),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Nouvelle réservation'),
          ),
        );
      },
    );
  }

  void _cancelReservation(
    int reservationId,
    ReservationProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Annuler la réservation'),
            content: const Text(
              'Êtes-vous sûr de vouloir annuler cette réservation ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Non'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Oui, annuler'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final success = await provider.cancelReservation(reservationId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation annulée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showNewReservationDialog(
    BuildContext context,
    ReservationProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => _NewReservationDialog(provider: provider),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onCancel;

  const _ReservationCard({required this.reservation, this.onCancel});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (reservation.status) {
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'Confirmée';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'En attente';
        statusIcon = Icons.pending;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Annulée';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Inconnue';
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Réservation #${reservation.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              Icons.calendar_today,
              '${reservation.date.day}/${reservation.date.month}/${reservation.date.year}',
            ),
            const SizedBox(height: 8),
            _InfoRow(Icons.access_time, reservation.time),
            const SizedBox(height: 8),
            _InfoRow(Icons.people, '${reservation.numberOfGuests} personne(s)'),
            if (reservation.specialRequests != null) ...[
              const SizedBox(height: 8),
              _InfoRow(Icons.note, reservation.specialRequests!),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (reservation.status == 'pending' ||
                    reservation.status == 'confirmed')
                  TextButton(onPressed: onCancel, child: const Text('Annuler')),
                if (reservation.status == 'confirmed')
                  ElevatedButton(
                    onPressed: () {
                      // Modifier la réservation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Modifier'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

class _NewReservationDialog extends StatefulWidget {
  final ReservationProvider provider;

  const _NewReservationDialog({required this.provider});

  @override
  State<_NewReservationDialog> createState() => _NewReservationDialogState();
}

class _NewReservationDialogState extends State<_NewReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedTime;
  int _numberOfGuests = 2;
  final _specialRequestsController = TextEditingController();

  final List<String> _availableTimes = [
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle réservation'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date selection
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _selectedDate == null
                      ? 'Sélectionner une date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
              ),

              // Time selection
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Heure',
                  prefixIcon: Icon(Icons.access_time),
                ),
                value: _selectedTime,
                items:
                    _availableTimes.map((time) {
                      return DropdownMenuItem(value: time, child: Text(time));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une heure';
                  }
                  return null;
                },
              ),

              // Number of guests
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.people),
                  const SizedBox(width: 12),
                  const Text('Nombre de convives:'),
                  const Spacer(),
                  IconButton(
                    onPressed:
                        _numberOfGuests > 1
                            ? () => setState(() => _numberOfGuests--)
                            : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_numberOfGuests'),
                  IconButton(
                    onPressed:
                        _numberOfGuests < 10
                            ? () => setState(() => _numberOfGuests++)
                            : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              // Special requests
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialRequestsController,
                decoration: const InputDecoration(
                  labelText: 'Demandes spéciales (optionnel)',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submitReservation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Réserver'),
        ),
      ],
    );
  }

  void _submitReservation() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final request = CreateReservationRequest(
        date: _selectedDate!,
        time: _selectedTime!,
        numberOfGuests: _numberOfGuests,
        specialRequests:
            _specialRequestsController.text.isNotEmpty
                ? _specialRequestsController.text
                : null,
      );

      final success = await widget.provider.createReservation(request);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation créée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.provider.error ?? 'Erreur lors de la création',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }
}
