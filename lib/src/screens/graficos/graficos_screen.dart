import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/services/graficos_service.dart';
import 'package:intl/intl.dart';

class GraficosScreen extends StatefulWidget {
  final int glebaId;
  final int cicloId;

  const GraficosScreen({
    Key? key,
    required this.glebaId,
    required this.cicloId,
  }) : super(key: key);

  @override
  _GraficosScreenState createState() => _GraficosScreenState();
}

class _GraficosScreenState extends State<GraficosScreen> {
  List<Map<String, dynamic>> _dadosAgrupados = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filterAplicacoes();
  }

  Future<void> _filterAplicacoes() async {
    try {
      _dadosAgrupados = await GraficosService()
          .getAplicacoesPorGlebaECiclo(widget.glebaId, widget.cicloId);
      setState(() {});
    } catch (error) {
      debugPrint('Erro ao buscar dados: $error');
      _showErrorDialog('Não foi possível carregar os dados do gráfico.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    final String formattedDate =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(data['data_aplicacao']));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Tipo do Produto: ${data['produto_tipo']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data da aplicação: $formattedDate'),
            Text('Motivo: ${data['motivo_aplicacao']}'),
            Text('Intervalo de segurança: ${data['intervalo_seguranca']} dias'),
            Text('Vigência: ${data['produto_vigencia']}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe das Aplicações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'ID Gleba: ${widget.glebaId}\nID Ciclo: ${widget.cicloId}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            // Usando o ListView para permitir o scroll nos cards
            if (_dadosAgrupados.isNotEmpty)
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: _dadosAgrupados.map(_buildCard).toList(),
                ),
              )
            else
              const Center(
                child: Text(
                    'Nenhuma aplicação encontrada para a Gleba e Ciclo selecionados.'),
              ),
          ],
        ),
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
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
