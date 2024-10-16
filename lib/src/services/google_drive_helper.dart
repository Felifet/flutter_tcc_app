import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;

const _scopes = [drive.DriveApi.driveFileScope];

// Função para fazer o upload de um arquivo para o Google Drive
Future<void> uploadFile(String filePath) async {
  // Crie um cliente HTTP usando a autenticação OAuth 2.0.
  final clientId = ClientId(
      '794698547918-9d9oc8oo45an9nv06qs68ho77999ni4m.apps.googleusercontent.com',
      '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');
  final client = await clientViaUserConsent(clientId, _scopes, (url) {
    // Abra o link de autorização no navegador.
    print('Acesse o seguinte URL:');
    print('  => $url');
    print('Digite o código de autorização:');
  });

  // Crie uma instância do Drive API.
  var driveApi = drive.DriveApi(client);

  // Crie um arquivo para o upload.
  var fileToUpload = drive.File();
  fileToUpload.name = 'backup_${DateTime.now().toIso8601String()}.db';

  // Crie um arquivo para o upload no Drive.
  var media =
      drive.Media(File(filePath).openRead(), File(filePath).lengthSync());

  // Faça o upload do arquivo.
  await driveApi.files.create(fileToUpload, uploadMedia: media);
  print('Backup enviado para o Google Drive com sucesso!');

  // Libere o cliente após o upload.
  client.close();
}
