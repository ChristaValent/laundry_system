import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_system/data/colour_categories.dart';
import 'package:laundry_system/models/laundry_item.dart';
import 'package:laundry_system/models/colour_category.dart';

class LaundryList extends StatefulWidget {
  const LaundryList({Key? key}) : super(key: key);

  @override
  State<LaundryList> createState() => _LaundryListState();
}

class _LaundryListState extends State<LaundryList> {
  List<LaundryItem> _laundryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLaundry();
  }

  Future _loadLaundry() async {
    final url = Uri.https(
        'cvlaundryapp-default-rtdb.europe-west1.firebasedatabase.app/',
        'laundry.json');
    final response = await http.get(url);

    final List<LaundryItem> loadedItems = [];

    final Map<String, dynamic> laundryData = json.decode(response.body);

    for (final item in laundryData.entries) {
      final selelctCategory = colourCategories.entries
          .firstWhere((categoryItem) =>
              categoryItem.value.name == item.value['category'])
          .value;

      loadedItems.add(
        LaundryItem(
            id: item.key,
            name: item.value['name'],
            imageUrl: item.value['imageUrl'],
            category: selelctCategory),
      );
    }

    setState(() {
      _isLoading = false;
      _laundryItems = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
