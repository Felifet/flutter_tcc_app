import 'package:flutter/material.dart';
import '../../services/ciclo_service.dart';
import '../../models/ciclo_model.dart';

class AddCicloScreen extends StatefulWidget {
  const AddCicloScreen({Key? key}) : super(key: key);

  @override
  _AddCicloScreenState createState() => _AddCicloScreenState();
}

class _AddCicloScreenState extends State<AddCicloScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();

  void _saveCiclo() async {
    if (_formKey.currentState!.validate()) {
      final ciclo = Ciclo(descricao: _descricaoController.text);
      await CicloService().insertCiclo(ciclo);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Ciclo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma descrição!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCiclo,
                child: const Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
