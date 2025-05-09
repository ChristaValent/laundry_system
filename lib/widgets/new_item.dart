import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_system/app_colours.dart';
import 'package:laundry_system/data/colour_categories.dart';
import 'package:laundry_system/models/colour_category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:laundry_system/models/laundry_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = "";
  var _enteredImageUrl = "";
  var _enteredCategory = colourCategories[Colour.dark];

  var isSendingData = false;

  File? _selectedImage;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Request permission if on Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Function to pick an image from the camera
  // It requests camera permission and if granted, opens the camera to take a picture.
  Future _pickImageFormCamera() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (returnedImage == null) return;

      setState(() {
        _selectedImage = File(returnedImage.path);
      });
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required to take a picture.'),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Camera permission is permanently denied. Please enable it in settings.'),
        ),
      );
    }
  }

  // Function to handle the form submission
  // It validates the form, saves the data, and sends it to the server.
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isSendingData = true;
      });

      final url = Uri.https(
          'cvlaundryapp-default-rtdb.europe-west1.firebasedatabase.app',
          'laundry.json');

      String? imageUrl;

      if (_selectedImage != null) {
        final imageBytes = await _selectedImage!.readAsBytes();
        imageUrl = base64Encode(imageBytes);
      }

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _enteredName,
            'image': imageUrl,
            'category': _enteredCategory!.name
          }));

      Map<String, dynamic> responseData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      // Show a notification after the item is added
      await flutterLocalNotificationsPlugin.show(
        0,
        'Item Added',
        'Successfully added $_enteredName to your laundry!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'laundry_channel', // channel id
            'Laundry Notifications', // channel name
            channelDescription: 'Notifies when a laundry item is added',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      Navigator.of(context).pop(LaundryItem(
          id: responseData["name"],
          name: _enteredName,
          imageUrl: _enteredImageUrl.isEmpty ? null : _enteredImageUrl,
          category: _enteredCategory!));
    }
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
            title: const Text('Add New Item'),
          ),
          body: isSendingData
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(
                                color:
                                    AppColors.charcoal), // Set input text color
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredName = value!;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<ColourCategory>(
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(
                                color: AppColors
                                    .charcoal), // Set dropdown text color
                            items: colourCategories.entries
                                .map((category) =>
                                    DropdownMenuItem<ColourCategory>(
                                      value: category.value,
                                      child: Text(
                                        category.value.name,
                                        style: const TextStyle(
                                            color: AppColors
                                                .charcoal), // Set item text color
                                      ),
                                    ))
                                .toList(),
                            onChanged: (selectedCategory) {
                              setState(() {
                                _enteredCategory = selectedCategory!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: MaterialButton(
                              onPressed: _pickImageFormCamera,
                              color: AppColors.mintGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Take picture",
                                style: TextStyle(
                                  color: AppColors.charcoal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          _selectedImage != null
                              ? Image.file(_selectedImage!)
                              : const SizedBox(),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              child: const Text('Add Item'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
