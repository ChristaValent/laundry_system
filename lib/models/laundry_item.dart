import 'package:flutter/material.dart';
import 'package:laundry_system/models/colour_category.dart';

class LaundryItem {
  const LaundryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
  });

  final String id;
  final String name;
  final Image? imageUrl;
  final ColourCategory category;
}