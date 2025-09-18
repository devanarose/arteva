import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../database/DBHelper.dart';
import '../models/categoriesss_item.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  BuildContext? _context;
  List<CategoriesssItem> _categories = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? selectedImage;
  CategoriesssItem? _editCategory;
  String? selectedImageFullPath;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ViewCategories();
  }

  Future<void> _ViewCategories() async {
    final categories = await DBHelper.instance.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false,);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final directory = await getApplicationDocumentsDirectory();
      final fileName = basename(file.path);
      final savedFile = await file.copy('${directory.path}/$fileName');

      setState(() {
        selectedImage = fileName;
        selectedImageFullPath = savedFile.path;
      });

      print("Image saved as: $fileName");
    }
  }


  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final category = CategoriesssItem(
        c_name: _nameController.text.trim(),
        imagePath: selectedImage ?? '',
      );

      await DBHelper.instance.insertCategory(category);
      await _ViewCategories();

      if (mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(content: Text('Category added successfully')),
        );
      }

      setState(() {
        _nameController.clear();
        selectedImage = null;
      });
    }
  }

  Future<void> _updateCategory() async {
    if (_formKey.currentState!.validate() && _editCategory != null) {
      final updatedCategory = CategoriesssItem(
        id: _editCategory!.id,
        c_name: _nameController.text.trim(),
        imagePath: selectedImage ?? '',
      );

      await DBHelper.instance.updateCategory(updatedCategory);
      await _ViewCategories();

      if (mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(content: Text('Category updated successfully')),
        );
      }

      setState(() {
        _editCategory = null;
        _nameController.clear();
        selectedImage = null;
      });
    }
  }

  Future<void> _deleteCategory(int id) async {
    await DBHelper.instance.deleteCategory(id);
    await _ViewCategories();

    if (mounted) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(content: Text('Category deleted')),
      );
    }
  }

  void _confirmDelete(int id) {
    showDialog(
      context: _context!,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteCategory(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  void _startEditCategory(CategoriesssItem category) {
    setState(() {
      _editCategory = category;
      _nameController.text = category.c_name;
      selectedImage = category.imagePath;
    });
  }

  Future<String?> _getFullImagePath(String? filename) async {
    if (filename == null) return null;
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename';
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 10),
              if (selectedImageFullPath != null && File(selectedImageFullPath!).existsSync())
                Image.file(
                  File(selectedImageFullPath!),
                  height: 100, width: 100,
                  fit: BoxFit.cover,
                )
              else
                const SizedBox.shrink(),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editCategory != null ? _updateCategory : _saveCategory,
                child: Text(_editCategory != null ? 'Update Category' : 'Add Category'),
              ),
              if (_editCategory != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _editCategory = null;
                      _nameController.clear();
                      selectedImage = null;
                      selectedImageFullPath = null;
                    });
                  },
                  child: const Text('Cancel Update'),
                ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'All Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _categories.isEmpty
                    ? const Center(child: Text('No categories added yet'))
                    : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return FutureBuilder<String?>(
                      future: _getFullImagePath(category.imagePath),
                      builder: (context, snapshot) {
                        final imagePath = snapshot.data;
                        return ListTile(
                          leading: (imagePath != null && File(imagePath).existsSync())
                              ? Image.file(
                            File(imagePath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.image_not_supported),
                          title: Text(category.c_name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _startEditCategory(category),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(category.id!),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
