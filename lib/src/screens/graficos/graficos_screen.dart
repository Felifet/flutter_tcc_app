import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/services/aplicacao_service.dart';
import 'package:flutter_tcc_app/src/services/gleba_service.dart';

class GraficosScreen extends StatefulWidget {
  @override
  _GraficosScreenState createState() => _GraficosScreenState();
}

class _GraficosScreenState extends State<GraficosScreen> {
  Gleba? _selectedGleba;
  List<Gleba> _glebas = [];
  List<Map<String, dynamic>> _dadosAgrupados = [];

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
      print("Selecionou a Gleba ID: ${_selectedGleba!.id}");

      // Chamando o serviço para buscar as aplicações por Gleba
      _dadosAgrupados = await AplicacaoService()
          .getAplicacoesAgrupadasPorTipo(_selectedGleba!.id!);

      print("Aplicações filtradas: $_dadosAgrupados");

      setState(() {});
    } else {
      print("Nenhuma gleba selecionada.");
    }
  }

  List<BarChartGroupData> _buildBarChartData() {
    int index = 0;
    return _dadosAgrupados.map((entry) {
      double vigencia = entry['totalVigencia'].toDouble();
      double carencia = entry['totalCarencia'].toDouble();

      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: vigencia,
            color: Colors.blue,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: carencia,
            color: Colors.green,
            width: 12,
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
              child: _dadosAgrupados.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        barGroups: _buildBarChartData(),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10,
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
                                if (value.toInt() < _dadosAgrupados.length) {
                                  String tipoProduto =
                                      _dadosAgrupados[value.toInt()]
                                          ['tipoProduto'];
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
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding: const EdgeInsets.all(8),
                            tooltipMargin: 5,
                            tooltipRoundedRadius: 10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String tipoProduto =
                                  _dadosAgrupados[group.x.toInt()]
                                      ['tipoProduto'];
                              String rodName =
                                  rodIndex == 0 ? 'Vigência' : 'Carência';
                              return BarTooltipItem(
                                '$tipoProduto\n$rodName: ${rod.toY.toStringAsFixed(2)}',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                          'Nenhuma aplicação encontrada para a Gleba selecionada.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
