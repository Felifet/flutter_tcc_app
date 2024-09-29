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

class AddAplicacaoScreen extends StatefulWidget {
  @override
  _AddAplicacaoScreenState createState() => _AddAplicacaoScreenState();
}

class _AddAplicacaoScreenState extends State<AddAplicacaoScreen> {
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
  }

  void _loadDropdownData() async {
    // Carregar os dados para os comboboxes
    _glebas = await GlebaService().getGlebas();
    _produtos = await ProductService().getProducts();
    _doencasPragas = await DoencaPragaService().getDoencasPragas();
    _ciclos = await CicloService().getCiclos();
    setState(() {}); // Atualizar o estado para carregar os dados nos comboboxes
  }

  void _saveAplicacao() async {
    if (_selectedMotivo != null &&
        _selectedGleba != null &&
        _selectedProduto != null &&
        _selectedCiclo != null) {
      final aplicacao = Aplicacao(
        datetime: DateTime.parse(_datetimeController.text),
        volumeCalda: double.parse(_volumeCaldaController.text),
        volumeProduto: double.parse(_volumeProdutoController.text),
        motivo: _selectedMotivo!,
        glebaId: _selectedGleba!.id!,
        produtoId: _selectedProduto!.id!,
        doencaPragaId: _selectedDoencaPraga?.id, // Opcional
        cicloId: _selectedCiclo!.id!,
      );

      await AplicacaoService().insertAplicacao(aplicacao);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Aplicação'),
      ),
      body: SingleChildScrollView(
        // Adicionado para tornar a tela rolável
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _datetimeController,
                decoration: const InputDecoration(labelText: 'Data e Hora'),
              ),
              TextField(
                controller: _volumeCaldaController,
                decoration: const InputDecoration(labelText: 'Volume da Calda'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _volumeProdutoController,
                decoration:
                    const InputDecoration(labelText: 'Volume do Produto'),
                keyboardType: TextInputType.number,
              ),
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
              DropdownButtonFormField<DoencaPraga>(
                decoration: const InputDecoration(labelText: 'Doença/Praga'),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAplicacao,
                child: const Text('Salvar Aplicação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
