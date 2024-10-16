import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'google_drive_helper.dart'; // Importe o helper do Google Drive

// Função para exportar o banco de dados
Future<String> exportDatabase() async {
  // Obtém o diretório onde o banco de dados está armazenado
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String dbPath =
      '${appDocDir.path}/agriculture.db'; // Substitua pelo nome do seu banco de dados
  String backupFilePath =
      '${appDocDir.path}/backup_${DateTime.now().toString()}.db';

  // Copia o banco de dados para o arquivo de backup
  await File(dbPath).copy(backupFilePath);
  return backupFilePath;
}

// Função para gerenciar o backup
Future<void> backupDatabase() async {
  String backupFilePath = await exportDatabase();
  await uploadFile(backupFilePath); // Chame a função de upload
}
