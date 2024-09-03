import 'package:flutter/material.dart';
import '../../services/db_helper.dart';

class ProductEditScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductEditScreen({super.key, required this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _activePrincipleController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.product['nameComercial']);
    _typeController = TextEditingController(text: widget.product['type']);
    _activePrincipleController =
        TextEditingController(text: widget.product['principioAtivo']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _activePrincipleController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = {
        'id': widget.product['id'],
        'nameComercial': _nameController.text,
        'type': _typeController.text,
        'principioAtivo': _activePrincipleController.text,
      };

      print('Produto atualizado: $updatedProduct');

      await DBHelper().updateProduct(updatedProduct);

      if (mounted) {
        Navigator.pop(context, true); // Volta à lista de produtos
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Commercial Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the commercial name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _activePrincipleController,
                decoration:
                    const InputDecoration(labelText: 'Active Principle'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the active principle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
