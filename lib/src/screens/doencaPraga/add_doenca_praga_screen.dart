import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/doenca_praga_model.dart';
import '../../services/db_helper.dart';

class AddDoencaPragaScreen extends StatefulWidget {
  final DoencaPraga? doencaPraga;

  const AddDoencaPragaScreen({Key? key, this.doencaPraga}) : super(key: key);

  @override
  _AddDoencaPragaScreenState createState() => _AddDoencaPragaScreenState();
}

class _AddDoencaPragaScreenState extends State<AddDoencaPragaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoCurtaController = TextEditingController();
  final _descricaoLongaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.doencaPraga != null) {
      _descricaoCurtaController.text = widget.doencaPraga!.descricaoCurta;
      _descricaoLongaController.text = widget.doencaPraga!.descricaoLonga ?? '';
    }
  }

  Future<void> _saveDoencaPraga() async {
    if (_formKey.currentState?.validate() ?? false) {
      final descricaoCurta = _descricaoCurtaController.text;
      final descricaoLonga = _descricaoLongaController.text.isNotEmpty
          ? _descricaoLongaController.text
          : null;

      final doencaPraga = DoencaPraga(
        id: widget.doencaPraga?.id,
        descricaoCurta: descricaoCurta,
        descricaoLonga: descricaoLonga,
      );

      if (doencaPraga.id == null) {
        // Add new DoencaPraga
        await DBHelper().insertDoencaPraga(doencaPraga);
      } else {
        // Update existing DoencaPraga
        await DBHelper().updateDoencaPraga(doencaPraga);
      }

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
              children: [
                TextFormField(
                  controller: _descricaoCurtaController,
                  decoration:
                      const InputDecoration(labelText: 'Descrição Curta'),
                  style: const TextStyle(fontSize: 20.0),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição curta';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descricaoLongaController,
                  decoration:
                      const InputDecoration(labelText: 'Descrição Longa'),
                  style: const TextStyle(fontSize: 20.0),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveDoencaPraga,
                  child:
                      Text(widget.doencaPraga == null ? 'Adicionar' : 'Salvar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor:
                        widget.doencaPraga == null ? Colors.blue : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
