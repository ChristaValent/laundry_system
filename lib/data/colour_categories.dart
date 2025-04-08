import 'package:flutter/material.dart';
import 'package:laundry_system/models/colour_category.dart';

const colourCategories = {
  Colour.dark: ColourCategory(
    name: 'Dark',
    color: Color.fromARGB(255, 0, 0, 0),
  ),
  Colour.light: ColourCategory(
    name: 'Light',
    color: Color.fromARGB(255, 255, 255, 255),
  ),
  Colour.colorful: ColourCategory(
    name: 'Colorful',
    color: Color.fromARGB(255, 255, 0, 0),
  )
};