import 'package:flutter/material.dart';

import '../models/restaurant_models.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // Données fictives pour le menu
  static final List<MenuItem> _mockMenuItems = [
    MenuItem(
      id: 1,
      name: 'Salade César',
      description:
          'Salade fraîche avec croûtons, parmesan et sauce César maison',
      price: 14.90,
      category: 'Entrées',
      available: true,
    ),
    MenuItem(
      id: 2,
      name: 'Carpaccio de bœuf',
      description: 'Fines lamelles de bœuf, roquette, copeaux de parmesan',
      price: 18.50,
      category: 'Entrées',
      available: true,
    ),
    MenuItem(
      id: 3,
      name: 'Filet de saumon grillé',
      description: 'Saumon grillé, légumes de saison, sauce hollandaise',
      price: 26.90,
      category: 'Plats',
      available: true,
    ),
    MenuItem(
      id: 4,
      name: 'Côte de bœuf',
      description:
          'Côte de bœuf grillée, pommes de terre grenailles, sauce poivre',
      price: 32.90,
      category: 'Plats',
      available: true,
    ),
    MenuItem(
      id: 5,
      name: 'Risotto aux champignons',
      description: 'Risotto crémeux aux champignons de saison, truffe',
      price: 22.90,
      category: 'Plats',
      available: true,
    ),
    MenuItem(
      id: 6,
      name: 'Tiramisu maison',
      description: 'Tiramisu traditionnel fait maison',
      price: 8.90,
      category: 'Desserts',
      available: true,
    ),
    MenuItem(
      id: 7,
      name: 'Tarte aux fruits',
      description: 'Tarte saisonnière aux fruits frais',
      price: 9.90,
      category: 'Desserts',
      available: true,
    ),
    MenuItem(
      id: 8,
      name: 'Café gourmand',
      description: 'Café accompagné de petites douceurs',
      price: 11.90,
      category: 'Desserts',
      available: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories =
        _mockMenuItems.map((item) => item.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notre Menu'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryItems =
              _mockMenuItems
                  .where((item) => item.category == category)
                  .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 24),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 12),
              ...categoryItems.map((item) => _MenuItemCard(item)),
            ],
          );
        },
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const _MenuItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${item.price.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        item.available ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: item.available ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.available ? 'Disponible' : 'Non disponible',
                        style: TextStyle(
                          fontSize: 12,
                          color: item.available ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
