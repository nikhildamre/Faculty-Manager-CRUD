import 'package:flutter/material.dart';
import '../models/faculty_model.dart';
import '../services/api_service.dart';

class AddFacultyScreen extends StatefulWidget {
  const AddFacultyScreen({super.key});

  @override
  State<AddFacultyScreen> createState() => _AddFacultyScreenState();
}

class _AddFacultyScreenState extends State<AddFacultyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Faculty newFaculty = Faculty(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // dummy id
        name: nameController.text,
        email: emailController.text,
        dateOfBirth: dobController.text,
        contact: contactController.text,
        department: departmentController.text,
        designation: designationController.text,
        address: addressController.text,
      );

      try {
        await ApiService.addFaculty(newFaculty);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Faculty added successfully")),
        );
        Navigator.pop(context, newFaculty); // go back to HomeScreen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Faculty")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: dobController,
                decoration: const InputDecoration(labelText: "Date of Birth"),
              ),
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: "Contact"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: designationController,
                decoration: const InputDecoration(labelText: "Designation"),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
