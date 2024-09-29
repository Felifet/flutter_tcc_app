import 'package:flutter/material.dart';
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

  const EditAplicacaoScreen({super.key, required this.aplicacao});

  @override
  _EditAplicacaoScreenState createState() => _EditAplicacaoScreenState();
}

class _EditAplicacaoScreenState extends State<EditAplicacaoScreen> {
  final TextEditingController _datetimeController = TextEditingController();
  final TextEditingController _volumeCaldaController = TextEditingController();
  final TextEditingController _volumeProdutoController =
      TextEditingController();

  String? _selectedMotivo;
  Gleba? _selectedGleba;
  Product? _selectedProduto;
  DoencaPraga? _selectedDoencaPraga;
  Ciclo? _selectedCiclo;

  List<Gleba> _glebas = [];
  List<Product> _produtos = [];
  List<DoencaPraga> _doencasPragas = [];
  List<Ciclo> _ciclos = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
    _initializeFields();
  }

  void _loadDropdownData() async {
    _glebas = await GlebaService().getGlebas();
    _produtos = await ProductService().getProducts();
    _doencasPragas = await DoencaPragaService().getDoencasPragas();
    _ciclos = await CicloService().getCiclos();
    setState(() {});
  }

  void _initializeFields() {
    _datetimeController.text = widget.aplicacao.datetime.toIso8601String();
    _volumeCaldaController.text = widget.aplicacao.volumeCalda.toString();
    _volumeProdutoController.text = widget.aplicacao.volumeProduto.toString();
    _selectedMotivo = widget.aplicacao.motivo;
    _selectedGleba =
        _glebas.firstWhere((gleba) => gleba.id == widget.aplicacao.glebaId);
    _selectedProduto = _produtos
        .firstWhere((produto) => produto.id == widget.aplicacao.produtoId);
    _selectedDoencaPraga = widget.aplicacao.doencaPragaId != null
        ? _doencasPragas
            .firstWhere((doenca) => doenca.id == widget.aplicacao.doencaPragaId)
        : null;
    _selectedCiclo =
        _ciclos.firstWhere((ciclo) => ciclo.id == widget.aplicacao.cicloId);
  }

  void _updateAplicacao() async {
    if (_selectedMotivo != null &&
        _selectedGleba != null &&
        _selectedProduto != null &&
        _selectedCiclo != null) {
      final aplicacao = Aplicacao(
        id: widget.aplicacao.id,
        datetime: DateTime.parse(_datetimeController.text),
        volumeCalda: double.parse(_volumeCaldaController.text),
        volumeProduto: double.parse(_volumeProdutoController.text),
        motivo: _selectedMotivo!,
        glebaId: _selectedGleba!.id!,
        produtoId: _selectedProduto!.id!,
        doencaPragaId: _selectedDoencaPraga?.id, // Opcional
        cicloId: _selectedCiclo!.id!,
      );

      await AplicacaoService().updateAplicacao(aplicacao);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Aplicação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _datetimeController,
              decoration: InputDecoration(labelText: 'Data e Hora'),
            ),
            TextField(
              controller: _volumeCaldaController,
              decoration: InputDecoration(labelText: 'Volume da Calda'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _volumeProdutoController,
              decoration: InputDecoration(labelText: 'Volume do Produto'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Motivo'),
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
            DropdownButtonFormField<Gleba>(
              decoration: InputDecoration(labelText: 'Gleba'),
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
            DropdownButtonFormField<Product>(
              decoration: InputDecoration(labelText: 'Produto'),
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
            DropdownButtonFormField<DoencaPraga>(
              decoration: InputDecoration(labelText: 'Doença/Praga'),
              value: _selectedDoencaPraga,
              items: _doencasPragas.map((doencaPraga) {
                return DropdownMenuItem(
                  value: doencaPraga,
                  child: Text(doencaPraga.descricaoCurta),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDoencaPraga = value;
                });
              },
            ),
            DropdownButtonFormField<Ciclo>(
              decoration: InputDecoration(labelText: 'Ciclo'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateAplicacao,
              child: Text('Atualizar Aplicação'),
            ),
          ],
        ),
      ),
    );
  }
}
