import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/faculty_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3001/faculty';

  static Future<List<Faculty>> getFacultyList() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Faculty.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  static Future<void> addFaculty(Faculty faculty) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(faculty.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add faculty');
    }
  }

  static Future<void> updateFaculty(Faculty faculty) async {
  final res = await http.put(
    Uri.parse('$baseUrl/${faculty.id}'),
    headers: {'Content-Type':'application/json'},
    body: jsonEncode(faculty.toJson()),
  );
  if (res.statusCode >= 400) throw Exception('Failed to update');
}

static Future<void> deleteFaculty(String id) async {
  final res = await http.delete(Uri.parse('$baseUrl/$id'));
  if (res.statusCode >= 400) throw Exception('Failed to delete');
}

}
