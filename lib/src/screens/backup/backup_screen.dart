import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;
  String? _selectedFilePath; // Caminho do arquivo selecionado

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _authenticateWithGoogle();
      }
    });
  }

  Future<void> _signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print("Error during sign-in: $error");
    }
  }

  Future<void> _authenticateWithGoogle() async {
    if (_currentUser != null) {
      print('Usuário autenticado: ${_currentUser!.displayName}');
      final authHeaders = await _currentUser!.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      _driveApi = drive.DriveApi(authenticateClient);
      setState(() {}); // Atualiza a interface após autenticação
    }
  }

  Future<void> _selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path!;
        });
      }
    } catch (e) {
      print('Erro ao selecionar arquivo: $e');
    }
  }

  Future<void> _uploadBackup() async {
    if (_driveApi == null) {
      print('Não há autenticação com o Google Drive');
      return;
    }

    if (_selectedFilePath == null) {
      print('Nenhum arquivo selecionado para backup');
      return;
    }

    try {
      // Nome do arquivo com data
      final dateSuffix = DateTime.now().toIso8601String().split('T').first;
      final fileName =
          'backup_${dateSuffix}_${_selectedFilePath!.split('/').last}';

      final file = drive.File()
        ..name = fileName
        ..mimeType = 'application/octet-stream';

      final fileData = await _getFileData();

      final media = drive.Media(
        Stream.value(fileData),
        fileData.length,
      );

      final uploadedFile =
          await _driveApi!.files.create(file, uploadMedia: media);
      print('Arquivo enviado com sucesso: ${uploadedFile.id}');
    } catch (e) {
      print('Erro ao fazer upload: $e');
    }
  }

  Future<List<int>> _getFileData() async {
    if (_selectedFilePath != null) {
      return await File(_selectedFilePath!).readAsBytes();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup no Google Drive')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Olá, ${_currentUser!.displayName ?? 'Usuário'}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_currentUser == null) ...[
                    ElevatedButton(
                      onPressed: _signIn,
                      child: const Text('Login no Google'),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: _selectFile,
                      child: const Text('Selecionar Arquivo'),
                    ),
                    if (_selectedFilePath != null) ...[
                      Text(
                        'Arquivo Selecionado: ${_selectedFilePath!.split('/').last}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _uploadBackup,
                        child: const Text('Fazer Backup'),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return request.send();
  }
}
