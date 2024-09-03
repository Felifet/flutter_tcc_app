import 'package:flutter/material.dart';
import '../../models/gleba_model.dart';
import '../../services/db_helper.dart';

class GlebaEditScreen extends StatefulWidget {
  final Gleba? gleba;

  const GlebaEditScreen({super.key, this.gleba});

  @override
  _GlebaEditScreenState createState() => _GlebaEditScreenState();
}

class _GlebaEditScreenState extends State<GlebaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _areaController;

  @override
  void initState() {
    super.initState();
    _nomeController =
        TextEditingController(text: widget.gleba?.nomeIdentificador ?? '');
    _areaController =
        TextEditingController(text: widget.gleba?.area.toString() ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _saveGleba() async {
    if (_formKey.currentState!.validate()) {
      final gleba = Gleba(
        id: widget.gleba?.id,
        nomeIdentificador: _nomeController.text,
        area: double.tryParse(_areaController.text) ?? 0,
      );

      if (widget.gleba == null) {
        await DBHelper().insertGleba(gleba);
      } else {
        await DBHelper().updateGleba(gleba);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gleba == null ? 'Add Gleba' : 'Edit Gleba'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration:
                    const InputDecoration(labelText: 'Nome Identificador'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Área (ha)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an area';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGleba,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
