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
    String path = join(await getDatabasesPath(), 'agriculture.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
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
  }

  // ------------------ CRUD de Produtos ------------------ //

  // Inserir produto
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  // Consultar todos os produtos
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  // Atualizar produto
  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  // Deletar produto
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------ CRUD de Glebas ------------------ //

  // Inserir Gleba
  Future<int> insertGleba(Gleba gleba) async {
    final db = await database;
    return await db.insert('Gleba', gleba.toMap());
  }

  // Buscar todas as Glebas
  Future<List<Gleba>> getGlebas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Gleba');

    return List.generate(maps.length, (i) {
      return Gleba.fromMap(maps[i]);
    });
  }

  // Atualizar Gleba
  Future<int> updateGleba(Gleba gleba) async {
    final db = await database;
    return await db.update(
      'Gleba',
      gleba.toMap(),
      where: 'id = ?',
      whereArgs: [gleba.id],
    );
  }

  // Excluir Gleba
  Future<void> deleteGleba(int id) async {
    final db = await database;
    await db.delete(
      'Gleba',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
