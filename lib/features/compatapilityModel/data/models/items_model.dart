import 'package:flutter/material.dart';

class Item {
  final String label;
  final IconData icon;
  final bool optional;
  final String apiKey; // Maps to API field name

  const Item({
    required this.label,
    required this.icon,
    required this.apiKey,
    this.optional = false,
  });
}

const List<Item> items = [
  Item(label: 'Top',       icon: Icons.checkroom_rounded,       apiKey: 'Top'),
  Item(label: 'Bottom',    icon: Icons.airline_seat_legroom_normal_rounded, apiKey: 'Bottom'),
  Item(label: 'Shoes',     icon: Icons.directions_walk_rounded,  apiKey: 'Shoe'),
  Item(label: 'Accessory', icon: Icons.watch_rounded,            apiKey: 'Accessory', optional: true),
  Item(label: 'Bag',       icon: Icons.shopping_bag_rounded,     apiKey: 'Bag',       optional: true),
];