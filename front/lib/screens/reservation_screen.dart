import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/restaurant_data.dart';
import '../models/reservation.dart';
import '../models/restaurant_models.dart';
import '../providers/auth_provider.dart';
import 'reservation_confirmation_screen.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numberOfGuests = 2;
  List<TimeSlot> availableTimeSlots = [];
  bool isLoading = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _loadTimeSlots();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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

  TimeOfDay _parseTimeSlot(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void _handleTimeSlotSelection(TimeSlot slot) {
    setState(() {
      selectedTime = _parseTimeSlot(slot.time);
    });
  }

  void _submitReservation() {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedDate == null || selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une date et une heure'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final reservation = ReservationFormData(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        numberOfGuests: numberOfGuests,
        date: selectedDate!,
        time: selectedTime!,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  ReservationConfirmationScreen(reservation: reservation),
        ),
      );
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre nom';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Téléphone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre numéro de téléphone';
              }
              // Add phone number validation if needed
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email';
              }
              if (!value.contains('@')) {
                return 'Veuillez entrer un email valide';
              }
              return null;
            },
          ),
        ],
      ),
    );
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
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onSelected: (value) async {
                  if (value == 'logout') {
                    await authProvider.logout();
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 8),
                            Text(authProvider.user?.fullName ?? 'Utilisateur'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Se déconnecter',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du restaurant
            _buildRestaurantHeader(),
            const SizedBox(height: 24),

            // Formulaire de réservation
            _buildForm(),
            const SizedBox(height: 24),

            // Sélection de la date
            _buildDateSelector(),
            const SizedBox(height: 16),

            // Sélection du nombre de personnes
            _buildGuestSelector(),
            const SizedBox(height: 24),

            // Créneaux horaires disponibles
            if (selectedDate != null) ...[_buildTimeSlotsSection()],

            // Bouton de confirmation
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedTime != null ? _submitReservation : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirmer la réservation'),
              ),
            ),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
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
          const Text(
            'Créneaux horaires disponibles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (availableTimeSlots.isEmpty)
            const Text(
              'Aucun créneau disponible pour cette date',
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  availableTimeSlots.map((slot) {
                    final isSelected =
                        selectedTime != null &&
                        selectedTime!.hour == _parseTimeSlot(slot.time).hour &&
                        selectedTime!.minute ==
                            _parseTimeSlot(slot.time).minute;

                    return ChoiceChip(
                      label: Text(slot.time),
                      selected: isSelected,
                      onSelected:
                          slot.isAvailable
                              ? (bool selected) {
                                if (selected) {
                                  _handleTimeSlotSelection(slot);
                                }
                              }
                              : null,
                      backgroundColor: Colors.grey[100],
                      selectedColor: Colors.orange[100],
                      labelStyle: TextStyle(
                        color:
                            slot.isAvailable
                                ? (isSelected
                                    ? Colors.orange[700]
                                    : Colors.black87)
                                : Colors.grey,
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
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
