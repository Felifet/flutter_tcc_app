import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_tcc_app/src/services/graficos_service.dart';

class GraficosScreen extends StatefulWidget {
  @override
  _GraficosScreenState createState() => _GraficosScreenState();
}

class _GraficosScreenState extends State<GraficosScreen> {
  int? glebaID;
  int? cicloID;
  List<Map<String, dynamic>> _dadosAgrupados = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Captura os parâmetros da navegação após a construção inicial do widget
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null) {
      // Verifica se os parâmetros são válidos antes de atribuir
      glebaID = arguments['gleba'] is int ? arguments['gleba'] as int : null;
      cicloID = arguments['ciclo'] is int ? arguments['ciclo'] as int : null;
    }
    _filterAplicacoes(); // Carrega as aplicações após a captura dos parâmetros
  }

  Future<void> _filterAplicacoes() async {
    if (glebaID != null && cicloID != null) {
      // Exibe a consulta SQL para conferência
      String sql = '''
      SELECT 
        p.tipo AS produto_tipo,              
        a.datetime AS data_aplicacao,       
        a.motivo AS motivo_aplicacao,       
        p.vigencia AS produto_vigencia,     
        p.intervaloDeSeguranca AS intervalo_seguranca 
      FROM Aplicacao a
      INNER JOIN products p ON a.produto_id = p.id
      INNER JOIN Gleba g ON a.gleba_id = g.id
      INNER JOIN Ciclo c ON a.ciclo_id = c.id
      WHERE a.gleba_id = $glebaID AND a.ciclo_id = $cicloID
      ''';
      _showSQLDialog(sql); // Exibe a SQL em um AlertDialog

      _dadosAgrupados = await GraficosService()
          .getAplicacoesPorGlebaECiclo(glebaID!, cicloID!);
      setState(() {});
    }
  }

  void _showSQLDialog(String sql) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Consulta SQL realizada'),
          content: SingleChildScrollView(
            child: Text(sql),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
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
                    return Text(_dadosAgrupados[value.toInt()]['produto_tipo'],
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

  List<LineChartBarData> _buildLineBarsData() {
    List<LineChartBarData> barDataList = [];
    for (int i = 0; i < _dadosAgrupados.length; i++) {
      final aplicacao = _dadosAgrupados[i];
      final dataAplicacao = aplicacao['data_aplicacao'];
      final carencia = aplicacao['intervalo_seguranca'];

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

  Widget _buildCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Produto: ${data['produto_tipo']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Motivo: ${data['motivo_aplicacao']}'),
            Text('Vigência: ${data['produto_vigencia']}'),
            Text('Data da aplicação: ${data['data_aplicacao']}'),
            Text('Intervalo de segurança: ${data['intervalo_seguranca']} dias'),
          ],
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
            if (glebaID != null && cicloID != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'ID Gleba: $glebaID\nID Ciclo: $cicloID',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (_dadosAgrupados.isNotEmpty)
              ..._dadosAgrupados.map((data) => _buildCard(data)),
            _dadosAgrupados.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: _buildChart(),
                    ),
                  )
                : const Center(
                    child: Text(
                        'Nenhuma aplicação encontrada para a Gleba e Ciclo selecionados.'),
                  ),
          ],
        ),
      ),
    );
  }
}
