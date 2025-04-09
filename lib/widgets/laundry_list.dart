import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_system/app_colours.dart';
import 'package:laundry_system/data/colour_categories.dart';
// import 'package:laundry_system/data/dummy_data.dart';
import 'package:laundry_system/models/laundry_item.dart';
import 'package:laundry_system/widgets/new_item.dart';

class LaundryList extends StatefulWidget {
  final String category;
  const LaundryList({super.key, required this.category});

  @override
  State<LaundryList> createState() => _LaundryListState();
}

class _LaundryListState extends State<LaundryList> {
  List<LaundryItem> _laundryItems = [];
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLaundry();
  }

  Future _loadLaundry() async {
    final url = Uri.https(
        'cvlaundryapp-default-rtdb.europe-west1.firebasedatabase.app',
        'laundry.json');

    final response = await http.get(url);

    final List<LaundryItem> loadedItems = [];
    final decoded = json.decode(response.body);

    if (decoded == null || decoded is! Map<String, dynamic> || decoded.isEmpty) {
    setState(() {
      isLoading = false;
      _laundryItems = []; // Optional: explicitly clear
    });
    return;
  }

  final Map<String, dynamic> laundryData = decoded;


    for (final item in laundryData.entries) {
      final selectedCategory = colourCategories.entries.firstWhere(
        (categoryItem) => categoryItem.value.name == item.value['category']).value;

      loadedItems.add(
        LaundryItem(
          id: (item.key),
          name: item.value['name'],
          imageUrl: item.value['image'],
          category: selectedCategory,
        ),
      );
    }

    setState(() {
      isLoading = false;
      _laundryItems = loadedItems;
    });
  }

  void removeItem(LaundryItem item) {
    final url = Uri.https(
        'cvlaundryapp-default-rtdb.europe-west1.firebasedatabase.app',
        'laundry/${item.id}.json');
    http.delete(url);

    setState(() {
      _laundryItems.remove(item);
    });
  }

  void _addItem() async {
    var newItem = await Navigator.of(context).push<LaundryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _laundryItems.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   final filtered = _laundryItems.where((item) => item.category.name == widget.category).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.laundryBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('${widget.category} Laundry'),
           actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: filtered.isEmpty
            ? const Center(child: Text('No items in this category.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final item = filtered[i];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(item.name),
                      leading: const Icon(Icons.checkroom),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
