import 'package:laundry_system/data/colour_categories.dart';
import 'package:laundry_system/models/colour_category.dart';

import '../models/laundry_item.dart';

final List<LaundryItem> dummyLaundryItems = [
  LaundryItem(
    id: '1',
    name: 'White Shirt',
    imageUrl: null,
    category: colourCategories[Colour.light]!),
  LaundryItem(
    id: '1',
    name: 'Dark Blue Shirt',
    imageUrl: null,
    category: colourCategories[Colour.dark]!),
  LaundryItem(
    id: '1',
    name: 'pink jumper',
    imageUrl: null,
    category: colourCategories[Colour.colourful]!),
];
