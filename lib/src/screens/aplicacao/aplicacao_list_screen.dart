import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/aplicacao_model.dart';
import 'package:flutter_tcc_app/src/screens/aplicacao/add_aplicacao_screen.dart';
import 'package:flutter_tcc_app/src/screens/aplicacao/aplicacao_edit_screen.dart';
import 'package:flutter_tcc_app/src/services/aplicacao_service.dart';

class AplicacaoListScreen extends StatefulWidget {
  const AplicacaoListScreen({Key? key}) : super(key: key);

  @override
  _AplicacaoListScreenState createState() => _AplicacaoListScreenState();
}

class _AplicacaoListScreenState extends State<AplicacaoListScreen> {
  late Future<List<Aplicacao>> _aplicacoes;

  @override
  void initState() {
    super.initState();
    _loadAplicacoes();
  }

  void _loadAplicacoes() {
    setState(() {
      _aplicacoes = AplicacaoService().getAplicacoes();
    });
  }

  void _navigateToAddAplicacao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAplicacaoScreen()),
    ).then((_) {
      _loadAplicacoes();
    });
  }

  void _navigateToEditAplicacao(Aplicacao aplicacao) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditAplicacaoScreen(aplicacao: aplicacao)),
    ).then((_) {
      _loadAplicacoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Aplicações'),
      ),
      body: FutureBuilder<List<Aplicacao>>(
        future: _aplicacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar as aplicações.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma aplicação encontrada.'));
          }

          final aplicacoes = snapshot.data!;

          return ListView.builder(
            itemCount: aplicacoes.length,
            itemBuilder: (context, index) {
              final aplicacao = aplicacoes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Aplicação em ${aplicacao.datetime}'),
                  subtitle: Text('Motivo: ${aplicacao.motivo}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _navigateToEditAplicacao(aplicacao),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAplicacao,
        child: const Icon(Icons.add),
      ),
    );
  }
}
