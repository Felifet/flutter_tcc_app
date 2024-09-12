import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/services/estagiofenologico_service.dart';
import '../../models/estagiofenologico_model.dart';

class AddEstagioFenologicoScreen extends StatefulWidget {
  const AddEstagioFenologicoScreen({Key? key}) : super(key: key);

  @override
  _AddEstagioFenologicoScreenState createState() =>
      _AddEstagioFenologicoScreenState();
}

class _AddEstagioFenologicoScreenState
    extends State<AddEstagioFenologicoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();

  void insertEstagioFenologico() async {
    if (_formKey.currentState!.validate()) {
      final estagioFenologico = EstagioFenologico(
        descricao: _descricaoController.text,
      );
      await EstagioFenologicoService().addEstagioFenologico(
        estagioFenologico,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Estágio Fenológico')),
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
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: insertEstagioFenologico,
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
