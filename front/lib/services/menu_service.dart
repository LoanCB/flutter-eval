import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/menu_item.dart';

class MenuService {
  // Singleton pattern
  static final MenuService _instance = MenuService._internal();
  factory MenuService() => _instance;
  MenuService._internal();

  // Get all menu items
  Future<List<MenuItem>> getMenuItems() async {
    try {
      print('🍽️ [MENU_SERVICE] Récupération des éléments du menu...');

      final response = await http.get(
        Uri.parse(ApiConfig.menuUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('🍽️ [MENU_SERVICE] Statut de réponse: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<MenuItem> menuItems =
            jsonData.map((item) => MenuItem.fromJson(item)).toList();

        print(
          '🍽️ [MENU_SERVICE] ${menuItems.length} éléments du menu récupérés',
        );
        return menuItems;
      } else {
        print(
          '❌ [MENU_SERVICE] Erreur lors de la récupération du menu: ${response.statusCode}',
        );
        throw Exception('Impossible de récupérer le menu');
      }
    } catch (e) {
      print('❌ [MENU_SERVICE] Exception: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      print(
        '🍽️ [MENU_SERVICE] Récupération des éléments du menu par catégorie: $category',
      );

      final response = await http.get(
        Uri.parse('${ApiConfig.menuUrl}?category=$category'),
        headers: {'Content-Type': 'application/json'},
      );

      print('🍽️ [MENU_SERVICE] Statut de réponse: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<MenuItem> menuItems =
            jsonData.map((item) => MenuItem.fromJson(item)).toList();

        print(
          '🍽️ [MENU_SERVICE] ${menuItems.length} éléments trouvés pour la catégorie $category',
        );
        return menuItems;
      } else {
        print(
          '❌ [MENU_SERVICE] Erreur lors de la récupération du menu par catégorie: ${response.statusCode}',
        );
        throw Exception('Impossible de récupérer le menu par catégorie');
      }
    } catch (e) {
      print('❌ [MENU_SERVICE] Exception: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Get menu item by ID
  Future<MenuItem> getMenuItemById(int id) async {
    try {
      print('🍽️ [MENU_SERVICE] Récupération de l\'élément du menu ID: $id');

      final response = await http.get(
        Uri.parse('${ApiConfig.menuUrl}/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      print('🍽️ [MENU_SERVICE] Statut de réponse: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final MenuItem menuItem = MenuItem.fromJson(jsonData);

        print('🍽️ [MENU_SERVICE] Élément du menu récupéré: ${menuItem.name}');
        return menuItem;
      } else {
        print(
          '❌ [MENU_SERVICE] Erreur lors de la récupération de l\'élément du menu: ${response.statusCode}',
        );
        throw Exception('Impossible de récupérer l\'élément du menu');
      }
    } catch (e) {
      print('❌ [MENU_SERVICE] Exception: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
}
