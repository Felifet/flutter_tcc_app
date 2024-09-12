import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/estagiofenologico_service.dart';

class EstagioFenologicoEditScreen extends StatefulWidget {
  final int estagioId; // O ID do estágio a ser editado

  const EstagioFenologicoEditScreen({Key? key, required this.estagioId})
      : super(key: key);

  @override
  _EstagioFenologicoEditScreenState createState() =>
      _EstagioFenologicoEditScreenState();
}

class _EstagioFenologicoEditScreenState
    extends State<EstagioFenologicoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController();
    _loadEstagioFenologico();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _loadEstagioFenologico() async {
    final estagio = await EstagioFenologicoService()
        .getEstagioFenologicoById(widget.estagioId);
    if (estagio != null) {
      setState(() {
        _descricaoController.text = estagio.descricao;
      });
    }
  }

  void _saveEstagioFenologico() async {
    if (_formKey.currentState!.validate()) {
      final estagioFenologico = EstagioFenologico(
        id: widget.estagioId,
        descricao: _descricaoController.text,
      );

      await EstagioFenologicoService()
          .updateEstagioFenologico(estagioFenologico);
      Navigator.pop(context);
    }
  }

  void _confirmDeleteEstagioFenologico() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text(
            'Você tem certeza de que deseja excluir este estágio fenológico?'),
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

    if (shouldDelete == true) {
      await EstagioFenologicoService()
          .deleteEstagioFenologico(widget.estagioId);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Estágio Fenológico'),
      ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _confirmDeleteEstagioFenologico,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Excluir'),
                  ),
                  ElevatedButton(
                    onPressed: _saveEstagioFenologico,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
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
