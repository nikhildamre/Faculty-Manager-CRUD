import 'package:flutter/material.dart';
import '../models/faculty_model.dart';
import '../services/api_service.dart';

class EditFacultyScreen extends StatefulWidget {
  final Faculty faculty;
  const EditFacultyScreen({super.key, required this.faculty});

  @override
  State<EditFacultyScreen> createState() => _EditFacultyScreenState();
}

class _EditFacultyScreenState extends State<EditFacultyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController name     = TextEditingController(text: widget.faculty.name);
  late final TextEditingController email    = TextEditingController(text: widget.faculty.email);
  late final TextEditingController dob      = TextEditingController(text: widget.faculty.dateOfBirth);
  late final TextEditingController contact  = TextEditingController(text: widget.faculty.contact);
  late final TextEditingController dept     = TextEditingController(text: widget.faculty.department);
  late final TextEditingController desig    = TextEditingController(text: widget.faculty.designation);
  late final TextEditingController address  = TextEditingController(text: widget.faculty.address);

  void _submit() async {
  if (_formKey.currentState!.validate()) {
    final updated = widget.faculty.copyWith(
      name: name.text,
      email: email.text,
      dateOfBirth: dob.text,
      contact: contact.text,
      department: dept.text,
      designation: desig.text,
      address: address.text,
    );

    await ApiService.updateFaculty(updated); // sends PUT request

    if (mounted) Navigator.pop(context, updated); // ✅ returns updated object
  }
}


  @override
  Widget build(BuildContext context) {
    InputDecoration _dec(String label) => InputDecoration(labelText: label, border: const OutlineInputBorder());
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Faculty')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: name,     decoration: _dec('Name'),        validator: (v)=>v!.isEmpty? 'Required':null),
              const SizedBox(height:12),
              TextFormField(controller: email,    decoration: _dec('Email'),       validator: (v)=>v!.isEmpty? 'Required':null),
              const SizedBox(height:12),
              TextFormField(controller: dob,      decoration: _dec('Date of Birth')),
              const SizedBox(height:12),
              TextFormField(controller: contact,  decoration: _dec('Contact')),
              const SizedBox(height:12),
              TextFormField(controller: dept,     decoration: _dec('Department')),
              const SizedBox(height:12),
              TextFormField(controller: desig,    decoration: _dec('Designation')),
              const SizedBox(height:12),
              TextFormField(controller: address,  decoration: _dec('Address')),
              const SizedBox(height:24),
              ElevatedButton(onPressed: _submit, child: const Text('Save changes'))
            ],
          ),
        ),
      ),
    );
  }
}
