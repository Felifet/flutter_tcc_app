import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/services/home_service.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCiclo = "Todos";
  String? selectedGleba = "Todos";
  String? selectedProduto = "Todos";
  List<String> ciclos = ["Todos"];
  List<String> glebas = ["Todos"];
  List<String> produtos = ["Todos"];

  Future<List<Map<String, dynamic>>> fetchAplicacoesAgrupadas() async {
    final homeService = HomeService();
    return await homeService.getAplicacoesPorTipoAgrupado();
  }

  Color getColorForProduto(String tipoProduto) {
    switch (tipoProduto) {
      case 'Herbicida':
        return Colors.red;
      case 'Fungicida':
        return Colors.green;
      case 'Inseticida':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insumos para Videiras'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 94, 105),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        automaticallyImplyLeading: false,
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

            // Populando as listas de ciclos e glebas
            if (ciclos.length == 1 && glebas.length == 1) {
              for (var item in data) {
                if (!ciclos.contains(item['ciclo_descricao'])) {
                  ciclos.add(item['ciclo_descricao']);
                }
                if (!glebas.contains(item['gleba_nome'])) {
                  glebas.add(item['gleba_nome']);
                }
              }
              ciclos.sort((a, b) => b.compareTo(a)); // Ordenando ciclos
            }

            // Extraindo tipos de produtos disponíveis
            if (produtos.length == 1) {
              for (var item in data) {
                if (!produtos.contains(item['produto_tipo'])) {
                  produtos.add(item['produto_tipo']);
                }
              }
            }

            // Filtrando dados de acordo com os filtros
            final filteredData = data.where((item) {
              final cicloMatch = selectedCiclo == "Todos" ||
                  item['ciclo_descricao'] == selectedCiclo;
              final glebaMatch = selectedGleba == "Todos" ||
                  item['gleba_nome'] == selectedGleba;
              final produtoMatch = selectedProduto == "Todos" ||
                  item['produto_tipo'] == selectedProduto;
              return cicloMatch && glebaMatch && produtoMatch;
            }).toList();

            // Agrupando os dados filtrados
            final groupedData = <String, Map<String, Map<String, int>>>{};
            for (var item in filteredData) {
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

            // Ordenando ciclos de forma decrescente
            final sortedGroupedData = groupedData.entries.toList()
              ..sort((a, b) => b.key.compareTo(a.key));

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Filtro de Ciclo
                        const Text('Selecione o Ciclo'),
                        DropdownButton<String>(
                          value: selectedCiclo,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              selectedCiclo = value;
                            });
                          },
                          items: ciclos.map((ciclo) {
                            return DropdownMenuItem<String>(
                              value: ciclo,
                              child: Text(ciclo),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Filtro de Gleba
                        const Text('Selecione a Gleba'),
                        DropdownButton<String>(
                          value: selectedGleba,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              selectedGleba = value;
                            });
                          },
                          items: glebas.map((gleba) {
                            return DropdownMenuItem<String>(
                              value: gleba,
                              child: Text(gleba),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Filtro de Tipo de Produto
                        const Text('Selecione o Tipo de Produto'),
                        DropdownButton<String>(
                          value: selectedProduto,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              selectedProduto = value;
                            });
                          },
                          items: produtos.map((produto) {
                            return DropdownMenuItem<String>(
                              value: produto,
                              child: Text(produto),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Ciclo X Gleba X Aplicações',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  for (var ciclo in sortedGroupedData)
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
                                  'Ciclo: ${ciclo.key}', // Exibe a descrição do ciclo
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
                                        color: getColorForProduto(entry.key),
                                      );
                                    }).toList(),
                                    centerSpaceRadius: 40,
                                    sectionsSpace: 5,
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
                                          color: getColorForProduto(entry.key),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MenuScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                // Código para fechar o app
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
