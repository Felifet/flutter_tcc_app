import 'package:flutter/material.dart';
import '../../models/gleba_model.dart';
import '../../controllers/gleba_controller.dart';

class GlebaEditScreen extends StatefulWidget {
  final Gleba? gleba;

  const GlebaEditScreen({super.key, this.gleba});

  @override
  _GlebaEditScreenState createState() => _GlebaEditScreenState();
}

class _GlebaEditScreenState extends State<GlebaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlebaController _controller = GlebaController();
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

      await _controller.saveGleba(gleba);
      Navigator.pop(context);
    }
  }

  void _deleteGleba() async {
    if (widget.gleba != null) {
      await _controller.deleteGleba(widget.gleba!.id!);
      Navigator.pop(context); // Volta após excluir
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.gleba != null)
                    ElevatedButton(
                      onPressed: _deleteGleba,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Excluir'),
                    ),
                  ElevatedButton(
                    onPressed: _saveGleba,
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
