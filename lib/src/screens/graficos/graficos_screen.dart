import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_tcc_app/src/models/aplicacao_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/models/product_model.dart';
import 'package:flutter_tcc_app/src/services/aplicacao_service.dart';
import 'package:flutter_tcc_app/src/services/gleba_service.dart';
import 'package:flutter_tcc_app/src/services/product_service.dart';

class GraficosScreen extends StatefulWidget {
  @override
  _GraficosScreenState createState() => _GraficosScreenState();
}

class _GraficosScreenState extends State<GraficosScreen> {
  Gleba? _selectedGleba;
  List<Gleba> _glebas = [];
  List<Aplicacao> _aplicacoesFiltradas = [];
  Map<String, int> tipoProdutoCount = {};

  @override
  void initState() {
    super.initState();
    _loadGlebas();
  }

  Future<void> _loadGlebas() async {
    _glebas = await GlebaService().getGlebas();
    setState(() {});
  }

  Future<void> _filterAplicacoes() async {
    if (_selectedGleba != null) {
      _aplicacoesFiltradas =
          await AplicacaoService().getAplicacoesByGlebaId(_selectedGleba!.id!);
      await _countTiposDeProduto();
      setState(() {});
    }
  }

  Future<void> _countTiposDeProduto() async {
    tipoProdutoCount.clear();
    for (var aplicacao in _aplicacoesFiltradas) {
      Product? produto =
          await ProductService().getProductById(aplicacao.produtoId);
      if (produto != null) {
        String tipoProduto = produto.tipo;

        if (tipoProdutoCount.containsKey(tipoProduto)) {
          tipoProdutoCount[tipoProduto] = tipoProdutoCount[tipoProduto]! + 1;
        } else {
          tipoProdutoCount[tipoProduto] = 1;
        }
      }
    }
  }

  List<BarChartGroupData> _buildBarChartData() {
    int index = 0;
    return tipoProdutoCount.entries.map((entry) {
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos de Aplicações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Gleba>(
              decoration: const InputDecoration(labelText: 'Selecione a Gleba'),
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
                _filterAplicacoes();
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: _buildBarChartData(),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < tipoProdutoCount.length) {
                            String tipoProduto =
                                tipoProdutoCount.keys.elementAt(value.toInt());
                            return Text(
                              tipoProduto,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
