import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/db_helper.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _nomeComercialController =
      TextEditingController();
  final TextEditingController _principioAtivoController =
      TextEditingController();
  final TextEditingController _classificacaoToxicologicaController =
      TextEditingController();
  final TextEditingController _formulacaoController = TextEditingController();
  final TextEditingController _dosagemComercialController =
      TextEditingController();
  final TextEditingController _intervaloDeSegurancaController =
      TextEditingController();
  final TextEditingController _vigenciaController = TextEditingController();

  void _saveProduct() async {
    final String tipo = _tipoController.text;
    final String nomeComercial = _nomeComercialController.text;
    final String principioAtivo = _principioAtivoController.text;
    final String? classificacaoToxicologica =
        _classificacaoToxicologicaController.text.isNotEmpty
            ? _classificacaoToxicologicaController.text
            : null;
    final String? formulacao = _formulacaoController.text.isNotEmpty
        ? _formulacaoController.text
        : null;
    final double? dosagemComercial =
        double.tryParse(_dosagemComercialController.text);
    final int intervaloDeSeguranca =
        int.tryParse(_intervaloDeSegurancaController.text) ?? 0;
    final int? vigencia = int.tryParse(_vigenciaController.text);

    if (tipo.isNotEmpty &&
        nomeComercial.isNotEmpty &&
        principioAtivo.isNotEmpty &&
        intervaloDeSeguranca > 0) {
      final product = Product(
        tipo: tipo,
        nomeComercial: nomeComercial,
        principioAtivo: principioAtivo,
        classificacaoToxicologica: classificacaoToxicologica,
        formulacao: formulacao,
        dosagemComercial: dosagemComercial,
        intervaloDeSeguranca: intervaloDeSeguranca,
        vigencia: vigencia,
      );
      await DBHelper().insertProduct(product.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _tipoController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _nomeComercialController,
              decoration: const InputDecoration(labelText: 'Commercial Name'),
            ),
            TextField(
              controller: _principioAtivoController,
              decoration: const InputDecoration(labelText: 'Active Ingredient'),
            ),
            TextField(
              controller: _classificacaoToxicologicaController,
              decoration: const InputDecoration(
                  labelText: 'Toxicological Classification'),
            ),
            TextField(
              controller: _formulacaoController,
              decoration: const InputDecoration(labelText: 'Formulation'),
            ),
            TextField(
              controller: _dosagemComercialController,
              decoration: const InputDecoration(labelText: 'Commercial Dosage'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _intervaloDeSegurancaController,
              decoration: const InputDecoration(labelText: 'Safety Interval'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _vigenciaController,
              decoration: const InputDecoration(labelText: 'Duration (Days)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
