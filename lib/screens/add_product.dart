import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../database/DBHelper.dart';
import '../models/categoriesss_item.dart';
import '../models/product_item.dart';



class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();

}

class _AddProductsState extends State<AddProducts> {

  BuildContext? _context;  //
  final _formKey = GlobalKey<FormState>();
  List<CategoriesssItem> _categories = [];
  List<ProductItem> _products = [];
  CategoriesssItem? _selectedCategory;
  String? selectedImageFullPath;
  ProductItem? _editProduct;


  final title = TextEditingController();
  final subtitle = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final section = TextEditingController();

  String? selectedImage;

  @override
  void dispose() {
    title.dispose();
    subtitle.dispose();
    description.dispose();
    price.dispose();
    section.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  Future<void> _loadCategories() async {
    final categories = await DBHelper.instance.getAllCategories(); // return List<CategoriesssItem>
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
        final directory = await getApplicationDocumentsDirectory();
        final fileName = basename(file.path);
        final savedFile = await file.copy('${directory.path}/$fileName');

        setState(() {
          selectedImage = fileName;
          selectedImageFullPath = savedFile.path;
        });
        print('Image saved as: $fileName');
    }
  }

  Future<String?> _getFullImagePath(String? filename) async {
    if (filename == null) return null;
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename';
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = ProductItem(
        title: title.text.trim(),
        imageUrl: selectedImage ?? '',
        subtitle: subtitle.text.trim(),
        description: description.text.trim(),
        c_id: _selectedCategory?.id.toString() ?? '',
        price: double.tryParse(price.text.trim()) ?? 0.0,
        section: section.text.trim(),
      );

      await DBHelper.instance.insertProduct(product);
      await _loadProducts();

      if (mounted) {
        // _context != null?
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(content: Text('Product added successfully')),
           );
          //         : print("object");
      }
      setState(() {
        title.clear();
        subtitle.clear();
        description.clear();
        price.clear();
        section.clear();
        selectedImage = null;
      });

    }
  }

  Future<void> _loadProducts() async {
    final products = await DBHelper.instance.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  Future<void> updateProduct() async {
    if (_formKey.currentState!.validate() && editProduct != null) {
      final updatedProduct = ProductItem(
        p_id: _editProduct!.p_id,
        title: title.text.trim(),
        subtitle: subtitle.text.trim(),
        description: description.text.trim(),
        imageUrl: selectedImage ?? '',
        c_id: _selectedCategory?.id.toString() ?? '',
        price: double.tryParse(price.text.trim()) ?? 0.0,
        section: section.text.trim(),
      );

      await DBHelper.instance.updateProduct(updatedProduct);
      await _loadProducts();

      if (mounted) {
        ScaffoldMessenger.of(_context!).showSnackBar(const SnackBar(content: Text('Product updated successfully')),);
      }

      setState(() {
        _editProduct = null;
        title.clear();
        subtitle.clear();
        description.clear();
        price.clear();
        section.clear();
        selectedImage = null;
        selectedImageFullPath = null;
      });
    }
  }

  Future<void> _deleteProduct(int id) async {
    await DBHelper.instance.deleteProduct(id);
    await _loadProducts();

    if (mounted) {
      ScaffoldMessenger.of(_context!).showSnackBar(const SnackBar(content: Text('Product deleted')),);
    }
  }

  void deleteproduct(int id) {
    showDialog(
      context: _context!,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteProduct(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void editProduct(ProductItem product) async {
    final fullPath = await _getFullImagePath(product.imageUrl);

    setState(() {
      _editProduct = product;
      title.text = product.title;
      subtitle.text = product.subtitle;
      description.text = product.description;
      price.text = product.price.toString();
      section.text = product.section;
      selectedImage = product.imageUrl;
      selectedImageFullPath = fullPath;
      _selectedCategory = _categories.firstWhere(
            (cat) => cat.id.toString() == product.c_id,
        orElse: () => _categories.first,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              TextFormField(
                controller: subtitle,
                decoration: const InputDecoration(labelText: 'Subtitle'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: price,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<CategoriesssItem>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.c_name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Category'),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: section,
                decoration: const InputDecoration(labelText: 'Section (e.g., popular, new)'),
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

              // const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _editProduct != null ? updateProduct : _saveProduct,
                child: Text(_editProduct != null ? 'Update Product' : 'Add Product'),
              ),

              const SizedBox(height: 20),
              const Text(
                'Added Products:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    child: ListTile(
                      leading: FutureBuilder<String?>(
                        future: _getFullImagePath(product.imageUrl),
                        builder: (context, snapshot) {
                          final imagePath = snapshot.data;
                          return (imagePath != null && File(imagePath).existsSync())
                              ? Image.file(File(imagePath),
                              width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported);
                        },
                      ),
                      title: Text(product.title),
                      subtitle: Text('Price: ₹${product.price.toStringAsFixed(2)}\nCategory ID: ${product.c_id}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => editProduct(product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteproduct(product.p_id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}