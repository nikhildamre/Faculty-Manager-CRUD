import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/faculty_model.dart';
import '../services/api_service.dart';
import 'add_faculty_screen.dart';
import 'edit_faculty_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Faculty> _facultyList = [];
  List<Faculty> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFaculty();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFaculty() async {
    final data = await ApiService.getFacultyList();
    setState(() {
      _facultyList = data;
      _filteredList = data;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredList = _facultyList.where((f) {
        return f.name.toLowerCase().contains(query) ||
            f.department.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _confirmDelete(Faculty faculty) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${faculty.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.deleteFaculty(faculty.id);
      setState(() {
        _facultyList.removeWhere((f) => f.id == faculty.id);
        _filteredList.removeWhere((f) => f.id == faculty.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Manager"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or department',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _filteredList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school_outlined, size: 80, color: Colors.black26),
                        SizedBox(height: 12),
                        Text('No faculty found',
                            style: TextStyle(fontSize: 16, color: Colors.black54)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredList.length,
                    itemBuilder: (context, index) {
                      final faculty = _filteredList[index];
                      return Slidable(
                        key: ValueKey(faculty.id),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditFacultyScreen(faculty: faculty),
                                  ),
                                );
                                if (updated != null && updated is Faculty) {
                                  setState(() {
                                    final i = _facultyList.indexWhere((f) => f.id == updated.id);
                                    if (i != -1) _facultyList[i] = updated;
                                    _onSearchChanged(); // refresh filtered list too
                                  });
                                }
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.blue,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => _confirmDelete(faculty),
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(faculty.name),
                            subtitle: Text(faculty.department),
                            trailing: Text(faculty.designation),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFacultyScreen()),
          );

          if (result != null && result is Faculty) {
            setState(() {
              _facultyList.add(result);
              _onSearchChanged(); // refresh filtered list
            });
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
