import 'package:flutter/material.dart';
import '../../models/gleba_model.dart';
import '../../services/gleba_service.dart';

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

  final GlebaService _glebaService = GlebaService();

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
        await _glebaService.addGleba(gleba);
      } else {
        await _glebaService.updateGleba(gleba);
      }

      Navigator.pop(context);
    }
  }

  void _confirmDeleteGleba() async {
    if (widget.gleba != null) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Você tem certeza que deseja excluir esta Gleba?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await _glebaService.deleteGleba(widget.gleba!.id!);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gleba == null ? 'Adicionar Gleba' : 'Editar Gleba'),
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
                    return 'Informe um nome!';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Área (ha)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a área';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _confirmDeleteGleba,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Excluir'),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saveGleba,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Salvar'),
                    ),
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
