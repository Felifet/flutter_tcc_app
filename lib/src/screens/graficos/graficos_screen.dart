import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
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
  final ScrollController _scrollController = ScrollController();

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
      _dadosAgrupados = await AplicacaoService()
          .getAplicacoesAgrupadasPorTipo(_selectedGleba!.id!);
      setState(() {});
    }
  }

  List<LineChartBarData> _buildLineBarsData() {
    List<LineChartBarData> barDataList = [];
    for (int i = 0; i < _dadosAgrupados.length; i++) {
      final aplicacao = _dadosAgrupados[i];
      final dataAplicacao = aplicacao['dataAplicacao'];
      final carencia = aplicacao['carencia'];

      if (dataAplicacao != null && carencia != null && carencia.isFinite) {
        final double startX = dataAplicacao.millisecondsSinceEpoch.toDouble();
        final double endX = startX + carencia;

        barDataList.add(
          LineChartBarData(
            spots: [FlSpot(startX, i.toDouble()), FlSpot(endX, i.toDouble())],
            isCurved: false,
            barWidth: 4,
            color: Colors.blue,
          ),
        );
      }
    }
    return barDataList;
  }

  Widget _buildChart() {
    final double minX = DateTime(2024, 10, 1).millisecondsSinceEpoch.toDouble();
    final double maxX =
        DateTime(2024, 10, 30).millisecondsSinceEpoch.toDouble();

    return Container(
      width: 800, // Largura fixa para evitar erro de layout
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: _dadosAgrupados.length.toDouble(),
          lineBarsData: _buildLineBarsData(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (value.toInt() < _dadosAgrupados.length) {
                    return Text(_dadosAgrupados[value.toInt()]['tipoProduto'],
                        style: TextStyle(fontSize: 12));
                  }
                  return Text('');
                },
                reservedSize: 80,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  // Converter o valor para a semana correspondente
                  final int weekNumber =
                      ((DateTime.fromMillisecondsSinceEpoch(value.toInt()).day -
                                      1) /
                                  7)
                              .floor() +
                          1;
                  return Text('Semana $weekNumber',
                      style: TextStyle(fontSize: 10));
                },
                interval: (maxX - minX) /
                    4, // Intervalo de uma semana aproximadamente
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
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
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: _buildChart(),
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
