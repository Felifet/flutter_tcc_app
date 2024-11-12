import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/services/backup_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String _statusMessage = '';

  // Função para exibir o caminho do banco de dados
  Future<void> _showDatabasePath() async {
    try {
      // Obtém o diretório onde o banco de dados está armazenado
      final directory = await getApplicationDocumentsDirectory();
      final databasePath = directory.path;

      // Exibe o caminho em um AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Caminho do Banco de Dados'),
            content: Text(databasePath), // Mostra o caminho do banco de dados
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao obter o caminho: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup de Dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  _showDatabasePath, // Chamando a função para mostrar o caminho
              child: const Text('Mostrar Caminho do Banco de Dados'),
            ),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(
                fontSize: 16,
                color: _statusMessage.contains('sucesso')
                    ? Colors.green
                    : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
