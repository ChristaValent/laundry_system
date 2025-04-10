import 'package:flutter/material.dart';
import 'package:laundry_system/app_colours.dart';
import 'laundry_list.dart';

class LaundryHome extends StatelessWidget {
  const LaundryHome({super.key});

  void _openCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LaundryList(category: category),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final categories = [
    {'title': 'Light', 'icon': Icons.wb_sunny, 'color': Colors.yellow},
    {'title': 'Dark', 'icon': Icons.nightlight_round, 'color': Colors.black87},
    {'title': 'Colourful', 'icon': Icons.palette, 'color': Colors.teal},
  ];

  return Container(
    decoration: const BoxDecoration(
      gradient: AppColors.laundryBackgroundGradient,
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Laundry Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 1;

            if (constraints.maxWidth >= 900) {
              crossAxisCount = 3; // Wide screen: all in a row
            } else if (constraints.maxWidth >= 600) {
              crossAxisCount = 2; // Tablet/landscape: 2 columns
            }

            return GridView.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.5,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryCard(
                  context,
                  category['title'] as String,
                  category['icon'] as IconData,
                  category['color'] as Color,
                );
              },
            );
          },
        ),
      ),
    ),
  );
}

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _openCategory(context, title),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        color: AppColors.cream,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
