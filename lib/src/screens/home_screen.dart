import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/services/home_service.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchAplicacoesAgrupadas() async {
    final homeService = HomeService();
    return await homeService.getAplicacoesPorTipoAgrupado();
  }

  // Definindo cores diferentes para cada tipo de produto
  Color getColorForProduto(String tipoProduto) {
    switch (tipoProduto) {
      case 'Herbicida':
        return Colors.red;
      case 'Fungicida':
        return Colors.green;
      case 'Inseticida':
        return Colors.blue;
      default:
        return Colors.grey; // Cor padrão
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insumos para Videiras'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 94, 105),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), fontSize: 22),
        iconTheme: const IconThemeData(color: Color(0xFF3C8C81)),
        automaticallyImplyLeading: false, // Remove o botão de voltar
        toolbarHeight: 56, // Ajuste a altura da AppBar superior
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAplicacoesAgrupadas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma aplicação encontrada.'));
          } else {
            final data = snapshot.data!;
            final groupedData = <String,
                Map<String,
                    Map<String, int>>>{}; // {ciclo: {gleba: {tipo: total}}}

            for (var item in data) {
              final cicloDescricao = item['ciclo_descricao'];
              final glebaNome = item['gleba_nome'];
              final produtoTipo = item['produto_tipo'];
              final total = item['total'];

              final cicloKey = '$cicloDescricao';

              if (!groupedData.containsKey(cicloKey)) {
                groupedData[cicloKey] = {};
              }

              if (!groupedData[cicloKey]!.containsKey(glebaNome)) {
                groupedData[cicloKey]![glebaNome] = {};
              }

              groupedData[cicloKey]![glebaNome]![produtoTipo] = total;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      // Centraliza o texto
                      child: Text(
                        'Ciclo X Gleba X Aplicações',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  for (var ciclo in groupedData.entries)
                    for (var gleba in ciclo.value.entries)
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Ciclo: ${ciclo.key}', // Mostra a descrição do ciclo
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('Gleba: ${gleba.key}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: gleba.value.entries.map((entry) {
                                      return PieChartSectionData(
                                        value: entry.value.toDouble(),
                                        title: entry.value.toString(),
                                        color: getColorForProduto(entry
                                            .key), // Cor personalizada para cada tipo de produto
                                        badgeWidget: Text(
                                          entry.value.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                    centerSpaceRadius:
                                        40, // Raio do espaço central
                                    sectionsSpace: 5, // Espaço entre as seções
                                  ),
                                ),
                              ),
                              // Adicionando a legenda
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: gleba.value.entries.map((entry) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          color: getColorForProduto(entry
                                              .key), // Cor personalizada para a legenda
                                        ),
                                        const SizedBox(width: 8),
                                        Text('${entry.key} (${entry.value})'),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 5, 94, 105),
        child: Container(
          height: 20, // Ajuste a altura da BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.list),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MenuScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app_sharp),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
