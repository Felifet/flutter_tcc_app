import 'package:flutter/material.dart';
import '../../models/cultivar_model.dart';
import '../../controllers/cultivar_controller.dart';

class CultivarEditScreen extends StatefulWidget {
  final Cultivar?
      cultivar; // Pode ser nulo se estivermos adicionando uma nova cultivar

  CultivarEditScreen({this.cultivar});

  @override
  _CultivarEditScreenState createState() => _CultivarEditScreenState();
}

class _CultivarEditScreenState extends State<CultivarEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final CultivarController _cultivarController = CultivarController();

  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador de texto com o nome da cultivar se estivermos editando
    _nomeController = TextEditingController(
      text: widget.cultivar != null ? widget.cultivar!.nome : '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _saveCultivar() async {
    if (_formKey.currentState!.validate()) {
      if (widget.cultivar == null) {
        // Criar uma nova cultivar
        Cultivar newCultivar = Cultivar(nome: _nomeController.text);
        await _cultivarController.saveCultivar(newCultivar);
      } else {
        // Atualizar a cultivar existente
        Cultivar updatedCultivar = Cultivar(
          id: widget.cultivar!.id,
          nome: _nomeController.text,
        );
        await _cultivarController.saveCultivar(updatedCultivar);
      }

      Navigator.pop(context); // Volta para a lista após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.cultivar == null ? 'Adicionar Cultivar' : 'Editar Cultivar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Cultivar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da cultivar';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCultivar,
                child: Text(widget.cultivar == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
