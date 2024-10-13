import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter_tcc_app/src/models/product_model.dart';
import 'package:flutter_tcc_app/src/services/product_service.dart';

class ImportacaoProdutosScreen extends StatefulWidget {
  const ImportacaoProdutosScreen({super.key});

  @override
  _ImportacaoProdutosScreenState createState() =>
      _ImportacaoProdutosScreenState();
}

class _ImportacaoProdutosScreenState extends State<ImportacaoProdutosScreen> {
  File? _selectedFile;
  bool _isLoading = false; // Variável para controlar a barra de carregamento

  // Método para selecionar o arquivo Excel
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Apenas arquivos Excel são permitidos
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

  // Método para importar dados do arquivo Excel
  Future<void> _importData() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true; // Inicia a barra de carregamento
    });

    try {
      var bytes = _selectedFile!.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      // Processa a primeira planilha
      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;

        // Ignorando a primeira linha (cabeçalho)
        for (var row in sheet.rows.skip(1)) {
          // Verifique se a linha possui dados suficientes
          if (row.length >= 7) {
            // Verifica se a linha tem pelo menos 7 colunas
            // Extrai os valores das colunas do Excel
            var tipo = row[0]?.value?.toString() ?? '';
            var nomeComercial = row[1]?.value?.toString() ?? '';
            var principioAtivo = row[2]?.value?.toString() ?? '';
            var classificacaoToxicologica = row[3]?.value?.toString();
            var formulacao = row[4]?.value?.toString();
            var dosagemComercial =
                double.tryParse(row[5]?.value?.toString() ?? '');
            var intervaloDeSeguranca =
                int.tryParse(row[6]?.value?.toString() ?? '0') ?? 0;

            Product product = Product(
              tipo: tipo,
              nomeComercial: nomeComercial,
              principioAtivo: principioAtivo,
              classificacaoToxicologica: classificacaoToxicologica,
              formulacao: formulacao,
              dosagemComercial: dosagemComercial,
              intervaloDeSeguranca: intervaloDeSeguranca,
            );
            await _saveProductImport(product);
          } else {
            print('Linha com dados insuficientes: $row');
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
        _isLoading = false; // Finaliza a barra de carregamento
      });
    }
  }

  // Método para salvar um produto no banco de dados através da importação
  Future<void> _saveProductImport(Product product) async {
    try {
      int result = await ProductService().addProductImport(product);
      if (result == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar produto.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar produto: $e')),
      );
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
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey), // Cor neutra
              child: const Text('Selecionar Arquivo Excel'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _isLoading || _selectedFile == null ? null : _importData,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue), // Cor azul
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Importar Dados'),
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null)
              Text('Arquivo selecionado: ${_selectedFile!.path}'),
          ],
        ),
      ),
    );
  }
}
