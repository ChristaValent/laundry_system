import 'package:flutter/material.dart';

enum Colour { dark, light, colorful }

class ColourCategory {
  const ColourCategory({ required this.name, required this.color});

  final String name;
  final Color color;
}
