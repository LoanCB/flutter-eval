import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/restaurant_models.dart';
import '../providers/reservation_provider.dart';
import '../providers/auth_provider.dart';
import 'daily_reservations_screen.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Charger les réservations au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ReservationProvider>(context, listen: false);
      provider.loadUserReservations();
      provider.loadTodayReservations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isHost = authProvider.user?.role == 'host';

    return Consumer<ReservationProvider>(
      builder: (context, reservationProvider, child) {
        if (reservationProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mes réservations'),
            backgroundColor: Colors.orange[700],
            elevation: 0,
            actions: [
              if (isHost)
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DailyReservationsScreen(),
                      ),
                    );
                  },
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await reservationProvider.loadUserReservations();
              await reservationProvider.loadTodayReservations();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Reservations Section
                    const Text(
                      'Réservations du jour',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTodayReservations(reservationProvider),
                    const SizedBox(height: 24),

                    // Future Reservations Section
                    const Text(
                      'Réservations à venir',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFutureReservations(reservationProvider),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showNewReservationDialog(context, reservationProvider),
            backgroundColor: Colors.orange[700],
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildTodayReservations(ReservationProvider reservationProvider) {
    if (reservationProvider.todayReservations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Aucune réservation aujourd\'hui',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      children: reservationProvider.todayReservations
          .map((reservation) => _ReservationCard(
                reservation: reservation,
                onCancel: () => _cancelReservation(
                  reservation.id,
                  reservationProvider,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildFutureReservations(ReservationProvider reservationProvider) {
    final now = DateTime.now();
    final futureReservations = reservationProvider.reservations
        .where((res) {
          final resDate = DateTime(
            res.date.year,
            res.date.month,
            res.date.day,
          );
          final today = DateTime(
            now.year,
            now.month,
            now.day,
          );
          return resDate.isAfter(today);
        })
        .toList()
      ..sort((a, b) {
        final dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;
        return a.time.compareTo(b.time);
      });

    if (futureReservations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Aucune réservation future',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      children: futureReservations
          .map((reservation) => _ReservationCard(
                reservation: reservation,
                onCancel: () => _cancelReservation(
                  reservation.id,
                  reservationProvider,
                ),
              ))
          .toList(),
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

    switch (reservation.status.toLowerCase()) {
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

    final dateFormatter = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    final formattedDate = dateFormatter.format(reservation.date);

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(statusIcon, size: 16, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onCancel != null &&
                    reservation.status.toLowerCase() != 'cancelled')
                  TextButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel, size: 20),
                    label: const Text('Annuler'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(Icons.access_time, 'Heure : ${reservation.time}'),
            const SizedBox(height: 8),
            _InfoRow(Icons.people,
                '${reservation.numberOfGuests} ${reservation.numberOfGuests > 1 ? 'personnes' : 'personne'}'),
            if (reservation.specialRequests != null &&
                reservation.specialRequests!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(Icons.note, 'Note : ${reservation.specialRequests}'),
            ],
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
