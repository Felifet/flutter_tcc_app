import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficosScreen extends StatefulWidget {
  @override
  _GraficosScreenState createState() => _GraficosScreenState();
}

class _GraficosScreenState extends State<GraficosScreen> {
  // Simular dados para o gráfico de aplicações de herbicida em diferentes datas
  final Map<String, int> herbicideApplications = {
    '01/10/2024': 3,
    '02/10/2024': 5,
    '03/10/2024': 2,
    '04/10/2024': 4,
    '05/10/2024': 6,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos de Aplicações de Herbicida'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Permite rolagem
        scrollDirection: Axis.horizontal, // Rolagem horizontal
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            // Adiciona um Container com largura fixa
            width: 800, // Defina um valor que caiba no seu layout
            child: BarChart(
              BarChartData(
                barGroups: _createBarGroups(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        // Mapear o número de aplicações para o eixo y
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        // Mapear as datas para o eixo x
                        return Text(
                          herbicideApplications.keys.elementAt(value.toInt()),
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
                barTouchData:
                    BarTouchData(enabled: false), // Desativar interações
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    // Criar grupos de barras a partir dos dados simulados
    return herbicideApplications.entries.map((entry) {
      final index = herbicideApplications.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 30,
          ),
        ],
      );
    }).toList();
  }
}
