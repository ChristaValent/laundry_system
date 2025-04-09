import 'package:laundry_system/data/colour_categories.dart';
import 'package:laundry_system/models/colour_category.dart';

import '../models/laundry_item.dart';

final List<LaundryItem> dummyLaundryItems = [
  LaundryItem(
    id: '1',
    name: 'White Shirt',
    imageUrl: '',
    category: colourCategories[Colour.light]!),
  LaundryItem(
    id: '1',
    name: 'Dark Blue Shirt',
    imageUrl: '',
    category: colourCategories[Colour.dark]!),
  LaundryItem(
    id: '1',
    name: 'pink jumper',
    imageUrl: '',
    category: colourCategories[Colour.colourful]!),
];
