import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'agriculture.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade, // Preparação para futuras migrações
      );
    } catch (e) {
      print("Erro ao inicializar o banco de dados: $e");
      throw Exception("Erro ao inicializar o banco de dados");
    }
  }

  Future _onCreate(Database db, int version) async {
    try {
      // Criação da tabela de produtos
      await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tipo TEXT NOT NULL,
          nomeComercial TEXT NOT NULL,
          principioAtivo TEXT NOT NULL,
          classificacaoToxicologica TEXT,
          formulacao TEXT,
          dosagemComercial REAL,
          intervaloDeSeguranca INTEGER NOT NULL,
          vigencia INTEGER
        )
      ''');

      // Criação da tabela de Glebas
      await db.execute('''
        CREATE TABLE Gleba (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nomeIdentificador TEXT NOT NULL,
          area REAL NOT NULL,
          cultivar_id INTEGER,
          FOREIGN KEY (cultivar_id) REFERENCES Cultivar(id)
        )
      ''');
    } catch (e) {
      print("Erro ao criar as tabelas: $e");
      throw Exception("Erro ao criar as tabelas");
    }
  }

  // Migração: Atualizar a estrutura do banco de dados se necessário
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Adicionar comandos de migração conforme necessário
      print("Atualizando banco de dados de $oldVersion para $newVersion");
    }
  }

  // ------------------ CRUD de Produtos ------------------ //

  // Inserir produto
  Future<int> insertProduct(Map<String, dynamic> product) async {
    try {
      final db = await database;
      return await db.insert('products', product);
    } catch (e) {
      print("Erro ao inserir produto: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Consultar todos os produtos
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final db = await database;
      return await db.query('products');
    } catch (e) {
      print("Erro ao buscar produtos: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  // Atualizar produto
  Future<int> updateProduct(Map<String, dynamic> product) async {
    try {
      final db = await database;
      return await db.update(
        'products',
        product,
        where: 'id = ?',
        whereArgs: [product['id']],
      );
    } catch (e) {
      print("Erro ao atualizar produto: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Deletar produto
  Future<int> deleteProduct(int id) async {
    try {
      final db = await database;
      return await db.delete('products', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Erro ao deletar produto: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // ------------------ CRUD de Glebas ------------------ //

  // Inserir Gleba
  Future<int> insertGleba(Gleba gleba) async {
    try {
      final db = await database;
      return await db.insert('Gleba', gleba.toMap());
    } catch (e) {
      print("Erro ao inserir Gleba: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Buscar todas as Glebas
  Future<List<Gleba>> getGlebas() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('Gleba');
      return List.generate(maps.length, (i) {
        return Gleba.fromMap(maps[i]);
      });
    } catch (e) {
      print("Erro ao buscar Glebas: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  // Atualizar Gleba
  Future<int> updateGleba(Gleba gleba) async {
    try {
      final db = await database;
      return await db.update(
        'Gleba',
        gleba.toMap(),
        where: 'id = ?',
        whereArgs: [gleba.id],
      );
    } catch (e) {
      print("Erro ao atualizar Gleba: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Excluir Gleba
  Future<void> deleteGleba(int id) async {
    try {
      final db = await database;
      await db.delete(
        'Gleba',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erro ao deletar Gleba: $e");
      throw Exception("Erro ao deletar Gleba");
    }
  }
}
