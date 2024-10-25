import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tcc_app/src/models/aplicacao_model.dart';
import 'package:flutter_tcc_app/src/services/aplicacao_service.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/models/doenca_praga_model.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/services/gleba_service.dart';
import 'package:flutter_tcc_app/src/services/doenca_praga_service.dart';
import 'package:flutter_tcc_app/src/services/ciclo_service.dart';
import 'package:flutter_tcc_app/src/models/product_model.dart';
import 'package:flutter_tcc_app/src/services/product_service.dart';

class EditAplicacaoScreen extends StatefulWidget {
  final Aplicacao aplicacao;

  const EditAplicacaoScreen({Key? key, required this.aplicacao})
      : super(key: key);

  @override
  _EditAplicacaoScreenState createState() => _EditAplicacaoScreenState();
}

class _EditAplicacaoScreenState extends State<EditAplicacaoScreen> {
  final AplicacaoService _aplicacaoService = AplicacaoService();

  final TextEditingController _datetimeController = TextEditingController();
  final TextEditingController _volumeCaldaController = TextEditingController();
  final TextEditingController _volumeProdutoController =
      TextEditingController();

  String? _selectedMotivo;
  String? _selectedTipoProduto;
  Gleba? _selectedGleba;
  Product? _selectedProduto;
  DoencaPraga? _selectedDoencaPraga;
  Ciclo? _selectedCiclo;

  double? _concentracao;
  List<Gleba> _glebas = [];
  List<Product> _produtos = [];
  List<DoencaPraga> _doencasPragas = [];
  List<Ciclo> _ciclos = [];
  List<String> _tiposProdutos = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
    _datetimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(widget.aplicacao.datetime);
    _volumeCaldaController.text = widget.aplicacao.volumeCalda.toString();
    _volumeProdutoController.text = widget.aplicacao.volumeProduto.toString();
    _selectedMotivo = widget.aplicacao.motivo;
  }

  Future<void> _loadDropdownData() async {
    _glebas = await GlebaService().getGlebas();
    _produtos = await ProductService().getProducts();
    _doencasPragas = await DoencaPragaService().getDoencasPragas();
    _ciclos = await CicloService().getCiclos();
    _tiposProdutos = await ProductService().getDistinctProductTypes();
    setState(() {});
  }

  void _updateConcentration() {
    if (_volumeProdutoController.text.isNotEmpty &&
        _volumeCaldaController.text.isNotEmpty) {
      final double volumeProduto = double.parse(_volumeProdutoController.text);
      final double volumeCalda = double.parse(_volumeCaldaController.text);
      setState(() {
        _concentracao = volumeProduto / volumeCalda;
      });
    }
  }

  void _updateAplicacao() async {
    if (_selectedMotivo != null &&
        _selectedGleba != null &&
        _selectedProduto != null &&
        _selectedCiclo != null) {
      final aplicacao = widget.aplicacao;
      aplicacao.datetime = DateTime.parse(_datetimeController.text);
      aplicacao.volumeCalda = double.parse(_volumeCaldaController.text);
      aplicacao.volumeProduto = double.parse(_volumeProdutoController.text);
      aplicacao.motivo = _selectedMotivo!;
      aplicacao.glebaId = _selectedGleba!.id!;
      aplicacao.produtoId = _selectedProduto!.id!;
      aplicacao.doencaPragaId = _selectedDoencaPraga?.id;
      aplicacao.cicloId = _selectedCiclo!.id!;

      await _aplicacaoService.updateAplicacao(aplicacao);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Aplicação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateAplicacao,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _datetimeController,
                decoration: InputDecoration(
                  labelText: 'Data e Hora',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      // Implement date picker functionality here
                    },
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _volumeCaldaController,
                decoration:
                    const InputDecoration(labelText: 'Volume da Calda (L)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _updateConcentration(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _volumeProdutoController,
                decoration:
                    const InputDecoration(labelText: 'Volume do Produto (ml)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _updateConcentration(),
              ),
              const SizedBox(height: 16),
              if (_concentracao != null)
                Text(
                  'Concentração: ${_concentracao!.toStringAsFixed(2)} ml/L',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Gleba>(
                decoration: const InputDecoration(labelText: 'Gleba'),
                value: _selectedGleba,
                items: _glebas.map((gleba) {
                  return DropdownMenuItem(
                    value: gleba,
                    child: Text(gleba.nomeIdentificador),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGleba = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Motivo'),
                value: _selectedMotivo,
                items: [
                  'Doença (Prevenção)',
                  'Doença (Remediação)',
                  'Praga',
                  'Estímulo para brotação',
                  'Adubação Foliar',
                  'Vegetação de cobertura'
                ].map((motivo) {
                  return DropdownMenuItem(
                    value: motivo,
                    child: Text(motivo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMotivo = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Ciclo>(
                decoration: const InputDecoration(labelText: 'Ciclo'),
                value: _selectedCiclo,
                items: _ciclos.map((ciclo) {
                  return DropdownMenuItem(
                    value: ciclo,
                    child: Text(ciclo.descricao),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCiclo = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de Produto'),
                value: _selectedTipoProduto,
                items: _tiposProdutos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    _selectedTipoProduto = value;
                    _selectedProduto = null;
                  });
                  _produtos = await ProductService().getProductsByType(value!);
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Product>(
                decoration: const InputDecoration(labelText: 'Produto'),
                value: _selectedProduto,
                items: _produtos.map((produto) {
                  return DropdownMenuItem(
                    value: produto,
                    child: Text(produto.nomeComercial),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProduto = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateAplicacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Salvar Aplicação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
