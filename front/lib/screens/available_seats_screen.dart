import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/reservation_service.dart';

class AvailableSeatsScreen extends StatefulWidget {
  const AvailableSeatsScreen({super.key});

  @override
  State<AvailableSeatsScreen> createState() => _AvailableSeatsScreenState();
}

class _AvailableSeatsScreenState extends State<AvailableSeatsScreen> {
  final ReservationService _reservationService = ReservationService();
  DateTime? selectedDate;
  int? selectedSeats;
  bool isLoading = false;
  List<Map<String, dynamic>> availableSeats = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _loadAvailableSeats();
  }

  Future<void> _loadAvailableSeats() async {
    if (selectedDate == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Format date as YYYY-MM-DD
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      
      // Call the API with filters
      final seats = await _reservationService.getAvailableSeats(
        date: formattedDate,
        seats: selectedSeats,
      );
      
      setState(() {
        availableSeats = seats;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadAvailableSeats();
    }
  }

  String _formatTimeSlot(String start, String end) {
    final startTime = DateTime.parse(start).toLocal();
    final endTime = DateTime.parse(end).toLocal();
    return '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}';
  }

  Map<String, List<Map<String, dynamic>>> _groupByTimeSlot() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    
    for (final seat in availableSeats) {
      final timeSlot = _formatTimeSlot(seat['start'], seat['end']);
      if (!grouped.containsKey(timeSlot)) {
        grouped[timeSlot] = [];
      }
      grouped[timeSlot]!.add(seat);
    }
    
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedSeats = _groupByTimeSlot();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places disponibles'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filters section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                // Date picker
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.orange),
                        const SizedBox(width: 12),
                        Text(
                          selectedDate != null
                              ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                              : 'Sélectionner une date',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Seats selector
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.chair, color: Colors.orange),
                      const SizedBox(width: 12),
                      const Text('Nombre de places:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 12),
                      DropdownButton<int>(
                        value: selectedSeats,
                        hint: const Text('Sélectionner'),
                        items: List.generate(10, (index) => index + 1)
                            .map((seats) => DropdownMenuItem(
                                  value: seats,
                                  child: Text('$seats'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSeats = value;
                          });
                          _loadAvailableSeats();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results section
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : availableSeats.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune place disponible pour ces critères',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: groupedSeats.length,
                        itemBuilder: (context, index) {
                          final timeSlot = groupedSeats.keys.elementAt(index);
                          final seats = groupedSeats[timeSlot]!;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  timeSlot,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              ...seats.map((seat) => Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: const Icon(Icons.chair, color: Colors.orange),
                                  title: Text('Table ${seat['table']['tableNumber']}'),
                                  subtitle: Text('${seat['availableSeats']} places disponibles'),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      // Handle reservation
                                      Navigator.pop(context, seat);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Réserver'),
                                  ),
                                ),
                              )).toList(),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
} 