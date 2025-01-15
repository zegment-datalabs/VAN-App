import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Function to get the local directory path
Future<String> _getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// Function to save categories to a JSON file
Future<void> saveCategoriesToLocalFile(List<Map<String, dynamic>> newCategories) async {
  try {
    final path = await _getLocalPath();
    final file = File('$path/category.json');

    // Read existing categories from the file, if the file exists
    List<Map<String, dynamic>> existingCategories = [];
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(jsonString);
      existingCategories = jsonList.map((json) => json as Map<String, dynamic>).toList();
    }

    // Add new categories to the existing list
    existingCategories.addAll(newCategories);

    // Convert updated categories list to JSON and write to the file
    String updatedJsonString = jsonEncode(existingCategories);
    await file.writeAsString(updatedJsonString, mode: FileMode.write);
    print('Categories saved to local file: $updatedJsonString');
  } catch (e) {
    print("Error saving categories to local file: $e");
  }
}

// Function to read categories from local JSON file
Future<List<Map<String, dynamic>>> readCategoriesFromLocalFile() async {
  try {
    final path = await _getLocalPath();
    final file = File('$path/category.json');

    // Check if file exists, and if it does, read it
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => json as Map<String, dynamic>).toList();
    } else {
      print("category.json file does not exist.");
      return []; // Return an empty list if the file doesn't exist
    }
  } catch (e) {
    print("Error reading categories from local file: $e");
    return [];
  }
}
