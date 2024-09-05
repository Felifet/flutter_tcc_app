import 'package:flutter/material.dart';
import '../../models/doenca_praga_model.dart';
import '../../services/db_helper.dart';

class DoencaPragaEditScreen extends StatefulWidget {
  final DoencaPraga? doencaPraga;

  const DoencaPragaEditScreen({super.key, this.doencaPraga});

  @override
  _DoencaPragaEditScreenState createState() => _DoencaPragaEditScreenState();
}

class _DoencaPragaEditScreenState extends State<DoencaPragaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoCurtaController;
  late TextEditingController _descricaoLongaController;

  @override
  void initState() {
    super.initState();
    _descricaoCurtaController =
        TextEditingController(text: widget.doencaPraga?.descricaoCurta ?? '');
    _descricaoLongaController =
        TextEditingController(text: widget.doencaPraga?.descricaoLonga ?? '');
  }

  @override
  void dispose() {
    _descricaoCurtaController.dispose();
    _descricaoLongaController.dispose();
    super.dispose();
  }

  void _saveDoencaPraga() async {
    if (_formKey.currentState!.validate()) {
      final doencaPraga = DoencaPraga(
        id: widget.doencaPraga?.id,
        descricaoCurta: _descricaoCurtaController.text,
        descricaoLonga: _descricaoLongaController.text,
      );

      if (widget.doencaPraga == null) {
        await DBHelper().insertDoencaPraga(doencaPraga);
      } else {
        await DBHelper().updateDoencaPraga(doencaPraga);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _confirmDeleteDoencaPraga() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text(
              'Você tem certeza que deseja excluir esta Doença/Praga?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteDoencaPraga();
    }
  }

  Future<void> _deleteDoencaPraga() async {
    if (widget.doencaPraga != null) {
      await DBHelper().deleteDoencaPraga(widget.doencaPraga!.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doencaPraga == null
            ? 'Adicionar Doença/Praga'
            : 'Editar Doença/Praga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _descricaoCurtaController,
                  decoration:
                      const InputDecoration(labelText: 'Descrição Curta'),
                  style: const TextStyle(fontSize: 18.0),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma descrição curta!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descricaoLongaController,
                  decoration:
                      const InputDecoration(labelText: 'Descrição Longa'),
                  style: const TextStyle(fontSize: 18.0),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.doencaPraga != null)
                      ElevatedButton(
                        onPressed: _confirmDeleteDoencaPraga,
                        child: const Text('Excluir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(120, 50),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _saveDoencaPraga,
                      child: const Text('Salvar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(120, 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
