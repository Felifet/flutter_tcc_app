import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter_tcc_app/src/models/product_model.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/services/product_service.dart';

class ImportacaoProdutosScreen extends StatefulWidget {
  const ImportacaoProdutosScreen({super.key});

  @override
  _ImportacaoProdutosScreenState createState() =>
      _ImportacaoProdutosScreenState();
}

class _ImportacaoProdutosScreenState extends State<ImportacaoProdutosScreen> {
  File? _selectedFile;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum arquivo selecionado.')),
      );
    }
  }

  Future<void> _importData() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var bytes = _selectedFile!.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        for (var row in sheet.rows.skip(1)) {
          if (row.length >= 7) {
            var product = Product(
              tipo: row[0]?.value?.toString() ?? '',
              nomeComercial: row[1]?.value?.toString() ?? '',
              principioAtivo: row[2]?.value?.toString() ?? '',
              classificacaoToxicologica: row[3]?.value?.toString(),
              formulacao: row[4]?.value?.toString(),
              dosagemComercial:
                  double.tryParse(row[5]?.value?.toString() ?? ''),
              intervaloDeSeguranca:
                  int.tryParse(row[6]?.value?.toString() ?? '0') ?? 0,
            );
            await ProductService().addProductImport(product);
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Importação concluída com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Produtos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: _pickFile,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Icon(Icons.attach_file, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Selecionar Arquivo'),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: (_selectedFile != null && !_isLoading)
                        ? _importData
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            size: 40,
                            color: _selectedFile != null
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const Text('Importar Dados'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null)
              Text('Arquivo selecionado: ${_selectedFile!.path}'),
            if (_isLoading) const CircularProgressIndicator(),
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
