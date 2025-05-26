import 'package:flutter/material.dart';
import '../models/restaurant_models.dart';
import '../data/restaurant_data.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  int numberOfGuests = 2; // Valeur par défaut
  List<TimeSlot> availableTimeSlots = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pré-sélectionner la date d'aujourd'hui
    selectedDate = DateTime.now();
    _loadTimeSlots();
  }

  void _loadTimeSlots() {
    if (selectedDate == null) return;

    setState(() {
      isLoading = true;
    });

    // Simulation d'un appel API avec un délai
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        availableTimeSlots = RestaurantData.getAvailableTimeSlots(
          selectedDate!,
          numberOfGuests,
        );
        isLoading = false;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      helpText: 'Sélectionner une date',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadTimeSlots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          RestaurantData.restaurant.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du restaurant
            _buildRestaurantHeader(),
            const SizedBox(height: 24),

            // Sélection de la date
            _buildDateSelector(),
            const SizedBox(height: 16),

            // Sélection du nombre de personnes
            _buildGuestSelector(),
            const SizedBox(height: 24),

            // Créneaux horaires disponibles
            if (selectedDate != null) ...[_buildTimeSlotsSection()],
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, color: Colors.orange[700], size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  RestaurantData.restaurant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            RestaurantData.restaurant.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sélectionnez une date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.orange[50],
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? _formatDate(selectedDate!)
                          : 'Choisir une date',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            selectedDate != null
                                ? Colors.black87
                                : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.orange[700]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nombre de personnes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Bouton diminuer
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed:
                      numberOfGuests > 1
                          ? () {
                            setState(() {
                              numberOfGuests--;
                            });
                            _loadTimeSlots();
                          }
                          : null,
                  icon: const Icon(Icons.remove),
                  color: numberOfGuests > 1 ? Colors.orange[700] : Colors.grey,
                ),
              ),

              // Affichage du nombre
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        '$numberOfGuests ${numberOfGuests == 1 ? 'personne' : 'personnes'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bouton augmenter
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed:
                      numberOfGuests < 12
                          ? () {
                            setState(() {
                              numberOfGuests++;
                            });
                            _loadTimeSlots();
                          }
                          : null,
                  icon: const Icon(Icons.add),
                  color: numberOfGuests < 12 ? Colors.orange[700] : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Maximum 12 personnes par réservation',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsSection() {
    if (!RestaurantData.isRestaurantOpen(selectedDate!)) {
      return _buildClosedMessage();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Créneaux disponibles pour $numberOfGuests ${numberOfGuests == 1 ? 'personne' : 'personnes'}\nle ${_formatDate(selectedDate!)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            _buildTimeSlotsList(),
        ],
      ),
    );
  }

  Widget _buildClosedMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Désolé, le restaurant est fermé ce jour-là.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: availableTimeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = availableTimeSlots[index];
        return _buildTimeSlotCard(timeSlot);
      },
    );
  }

  Widget _buildTimeSlotCard(TimeSlot timeSlot) {
    final bool hasEnoughSeats = timeSlot.availableSeats >= numberOfGuests;
    final bool isAvailable = timeSlot.isAvailable && hasEnoughSeats;

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    String statusText;

    if (!timeSlot.isAvailable) {
      backgroundColor = Colors.red[50]!;
      borderColor = Colors.red[300]!;
      textColor = Colors.red[700]!;
      statusText = 'Complet';
    } else if (!hasEnoughSeats) {
      backgroundColor = Colors.orange[50]!;
      borderColor = Colors.orange[300]!;
      textColor = Colors.orange[700]!;
      statusText =
          'Pas assez de places\n(${timeSlot.availableSeats} disponibles)';
    } else {
      backgroundColor = Colors.green[50]!;
      borderColor = Colors.green[300]!;
      textColor = Colors.green[700]!;
      statusText = '${timeSlot.availableSeats} places disponibles';
    }

    return InkWell(
      onTap: isAvailable ? () => _onTimeSlotSelected(timeSlot) : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow:
              isAvailable
                  ? [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timeSlot.time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 11,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _onTimeSlotSelected(TimeSlot timeSlot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Réservation'),
          content: Text(
            'Vous avez sélectionné le créneau ${timeSlot.time} pour $numberOfGuests ${numberOfGuests == 1 ? 'personne' : 'personnes'} le ${_formatDate(selectedDate!)}.\n\n'
            'Places disponibles : ${timeSlot.availableSeats}\n'
            'Places nécessaires : $numberOfGuests',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Naviguer vers le formulaire de réservation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Créneau ${timeSlot.time} sélectionné pour $numberOfGuests ${numberOfGuests == 1 ? 'personne' : 'personnes'} !',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const List<String> weekdays = [
      '',
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    const List<String> months = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];

    return '${weekdays[date.weekday]} ${date.day} ${months[date.month]} ${date.year}';
  }
}
