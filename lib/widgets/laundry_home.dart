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
          child: Column(
            children: [
              _buildCategoryCard(context, 'Light', Icons.wb_sunny, Colors.yellow),
              const SizedBox(height: 20),
              _buildCategoryCard(context, 'Dark', Icons.nightlight_round, Colors.black87),
              const SizedBox(height: 20),
              _buildCategoryCard(context, 'Colourful', Icons.palette, Colors.teal),
            ],
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
