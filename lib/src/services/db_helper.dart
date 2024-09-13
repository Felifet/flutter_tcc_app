import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/cultivar_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/models/doenca_praga_model.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
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
        onOpen: _checkTables, // Verifica tabelas ao abrir o banco de dados
      );
    } catch (e) {
      print("Erro ao inicializar o banco de dados: $e");
      throw Exception("Erro ao inicializar o banco de dados");
    }
  }

  Future _onCreate(Database db, int version) async {
    try {
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

      await db.execute('''
        CREATE TABLE Gleba (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nomeIdentificador TEXT NOT NULL,
          area REAL NOT NULL,
          cultivar_id INTEGER,
          FOREIGN KEY (cultivar_id) REFERENCES Cultivar(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE Ciclo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          descricao TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE DoencaPraga (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          descricaoCurta TEXT NOT NULL,
          descricaoLonga TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE Cultivar (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE Manejo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          descricao TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE EstagioFenologico (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          descricao TEXT NOT NULL
        )
      ''');
      await db.execute('''
      CREATE TABLE RegistroManejo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        datetime TEXT NOT NULL,
        ciclo_id INTEGER,
        gleba_id INTEGER,
        manejo_id INTEGER,
        FOREIGN KEY (ciclo_id) REFERENCES Ciclo(id) ON DELETE CASCADE,
        FOREIGN KEY (gleba_id) REFERENCES Gleba(id) ON DELETE CASCADE,
        FOREIGN KEY (manejo_id) REFERENCES Manejo(id) ON DELETE CASCADE
      );
    ''');

      await _insertInitialCultivars(db);
    } catch (e) {
      print("Erro ao criar as tabelas: $e");
      throw Exception("Erro ao criar as tabelas");
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      print("Atualizando banco de dados de $oldVersion para $newVersion");
    }
  }

  Future<void> _checkTables(Database db) async {
    final tables = [
      'products',
      'Gleba',
      'Ciclo',
      'DoencaPraga',
      'Cultivar',
      'Manejo',
      'EstagioFenologico',
      'RegistroManejo'
    ];
    for (String table in tables) {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'",
      );
      if (result.isEmpty) {
        print("Tabela $table não encontrada. Criando a tabela...");
        switch (table) {
          case 'products':
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
            break;
          case 'Gleba':
            await db.execute('''
              CREATE TABLE Gleba (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nomeIdentificador TEXT NOT NULL,
                area REAL NOT NULL,
                cultivar_id INTEGER,
                FOREIGN KEY (cultivar_id) REFERENCES Cultivar(id)
              )
            ''');
            break;
          case 'Ciclo':
            await db.execute('''
              CREATE TABLE Ciclo (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                descricao TEXT NOT NULL
              )
            ''');
            break;
          case 'DoencaPraga':
            await db.execute('''
              CREATE TABLE DoencaPraga (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                descricaoCurta TEXT NOT NULL,
                descricaoLonga TEXT
              )
            ''');
            break;
          case 'Cultivar':
            await db.execute('''
              CREATE TABLE Cultivar (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL
              )
            ''');
            await _insertInitialCultivars(db);
            break;
          case 'Manejo':
            await db.execute('''
              CREATE TABLE Manejo (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                descricao TEXT NOT NULL
              )
            ''');
            break;
          case 'EstagioFenologico':
            await db.execute('''
              CREATE TABLE EstagioFenologico (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                descricao TEXT NOT NULL
              )
            ''');
            break;
          case 'RegistroManejo':
            await db.execute('''
              CREATE TABLE RegistroManejo (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              datetime TEXT NOT NULL,
              ciclo_id INTEGER,
              gleba_id INTEGER,
              manejo_id INTEGER,
              FOREIGN KEY (ciclo_id) REFERENCES Ciclo(id) ON DELETE CASCADE,
              FOREIGN KEY (gleba_id) REFERENCES Gleba(id) ON DELETE CASCADE,
              FOREIGN KEY (manejo_id) REFERENCES Manejo(id) ON DELETE CASCADE
            );
            ''');
        }
      }
    }
  }

  // ------------------ CRUD de Produtos ------------------ //

  Future<int> insertProduct(Map<String, dynamic> product) async {
    try {
      final db = await database;
      return await db.insert('products', product);
    } catch (e) {
      print("Erro ao inserir produto: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final db = await database;
      return await db.query('products');
    } catch (e) {
      print("Erro ao buscar produtos: $e");
      return [];
    }
  }

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
      return -1;
    }
  }

  Future<int> deleteProduct(int id) async {
    try {
      final db = await database;
      return await db.delete('products', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Erro ao deletar produto: $e");
      return -1;
    }
  }

  // ------------------ CRUD de Glebas ------------------ //

  Future<int> insertGleba(Gleba gleba) async {
    try {
      final db = await database;
      return await db.insert('Gleba', gleba.toMap());
    } catch (e) {
      print("Erro ao inserir Gleba: $e");
      return -1;
    }
  }

  Future<List<Gleba>> getGlebas() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('Gleba');
      return List.generate(maps.length, (i) {
        return Gleba.fromMap(maps[i]);
      });
    } catch (e) {
      print("Erro ao buscar Glebas: $e");
      return [];
    }
  }

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
      return -1;
    }
  }

  Future<void> deleteGleba(int id) async {
    try {
      final db = await database;
      await db.delete('Gleba', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Erro ao deletar Gleba: $e");
      throw Exception("Erro ao deletar Gleba");
    }
  }

  // ------------------ CRUD de Ciclos ------------------ //

  Future<int> insertCiclo(Ciclo ciclo) async {
    final db = await database;
    return await db.insert('Ciclo', ciclo.toMap());
  }

  Future<List<Ciclo>> getCiclos() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Ciclo');
    return result.map((map) => Ciclo.fromMap(map)).toList();
  }

  Future<int> updateCiclo(Ciclo ciclo) async {
    final db = await database;
    return await db.update(
      'Ciclo',
      ciclo.toMap(),
      where: 'id = ?',
      whereArgs: [ciclo.id],
    );
  }

  Future<int> deleteCiclo(int id) async {
    final db = await database;
    return await db.delete('Ciclo', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------ CRUD de Doenca/Praga ------------------ //

  Future<int> insertDoencaPraga(DoencaPraga doencaPraga) async {
    final db = await database;
    return await db.insert('DoencaPraga', doencaPraga.toMap());
  }

  Future<List<DoencaPraga>> getDoencasPragas() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('DoencaPraga');
    return result.map((map) => DoencaPraga.fromMap(map)).toList();
  }

  Future<int> updateDoencaPraga(DoencaPraga doencaPraga) async {
    final db = await database;
    return await db.update(
      'DoencaPraga',
      doencaPraga.toMap(),
      where: 'id = ?',
      whereArgs: [doencaPraga.id],
    );
  }

  Future<int> deleteDoencaPraga(int id) async {
    final db = await database;
    return await db.delete('DoencaPraga', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getDoencaPragaById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'DoencaPraga',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // ------------------ CRUD de Cultivares ------------------ //

  Future<int> insertCultivar(Cultivar cultivar) async {
    final db = await database;
    return await db.insert('Cultivar', cultivar.toMap());
  }

  Future<List<Cultivar>> getCultivares() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Cultivar');
    return result.map((map) => Cultivar.fromMap(map)).toList();
  }

  Future<int> updateCultivar(Cultivar cultivar) async {
    final db = await database;
    return await db.update(
      'Cultivar',
      cultivar.toMap(),
      where: 'id = ?',
      whereArgs: [cultivar.id],
    );
  }

  Future<int> deleteCultivar(int id) async {
    final db = await database;
    return await db.delete('Cultivar', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _insertInitialCultivars(Database db) async {
    final cultivares = [
      'BRS Vitória',
      'BRS Núbia',
      'BRS Ísis',
      'BRS Cora',
      'BRS Magna',
      'BRS Morena',
      'BRS Clara',
      'BRS Linda',
      'BRS Violeta',
      'BRS Carmem',
      'Cabernet Sauvignon',
      'Merlot',
      'Chardonnay',
      'Syrah',
      'Pinot Noir',
      'Sauvignon Blanc',
      'Petit Verdot',
      'Viognier',
      'Malbec',
      'Gamay',
      'Sangiovese',
      'Nebbiolo',
      'Barbera',
      'Moscato',
      'Trebbiano',
      'Montepulciano',
      'Lambrusco',
      'Verdicchio',
      'Nero d’Avola',
      'Dolcetto',
      'Tannat',
      'Moscato Giallo',
      'Ancellotta',
      'Alicante Bouschet',
      'Riesling Itálico',
      'Tempranillo',
      'Touriga Nacional',
      'Arinarnoa',
      'Ruby Cabernet',
      'Grenache',
      'Isabel',
      'Bordô',
      'Niagara Rosada',
      'Niagara Branca',
      'Concord',
      'Seibel',
      'Jacquez',
      'Goethe',
      'Isabel Precoce',
      'Moscato Embrapa'
    ];

    for (String nome in cultivares) {
      await db.insert('Cultivar', {'nome': nome});
    }
  }

  // ------------------ CRUD de Manejos ------------------ //

  Future<int> insertManejo(Manejo manejo) async {
    final db = await database;
    return await db.insert('Manejo', manejo.toMap());
  }

  Future<List<Manejo>> getManejos() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Manejo');
    return result.map((map) => Manejo.fromMap(map)).toList();
  }

  Future<int> updateManejo(Manejo manejo) async {
    final db = await database;
    return await db.update(
      'Manejo',
      manejo.toMap(),
      where: 'id = ?',
      whereArgs: [manejo.id],
    );
  }

  Future<int> deleteManejo(int id) async {
    final db = await database;
    return await db.delete('Manejo', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------ CRUD de Estágio Fenológico ------------------ //

  Future<int> insertEstagioFenologico(
      Map<String, dynamic> estagioFenologico) async {
    try {
      final db = await database;
      return await db.insert('EstagioFenologico', estagioFenologico);
    } catch (e) {
      print("Erro ao inserir Estágio Fenológico: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  Future<List<Map<String, dynamic>>> getEstagiosFenologicos() async {
    try {
      final db = await database;
      return await db.query('EstagioFenologico');
    } catch (e) {
      print("Erro ao buscar Estágios Fenológicos: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<int> updateEstagioFenologico(
      Map<String, dynamic> estagioFenologico) async {
    try {
      final db = await database;
      return await db.update(
        'EstagioFenologico',
        estagioFenologico,
        where: 'id = ?',
        whereArgs: [estagioFenologico['id']],
      );
    } catch (e) {
      print("Erro ao atualizar Estágio Fenológico: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  Future<int> deleteEstagioFenologico(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'EstagioFenologico',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erro ao deletar Estágio Fenológico: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }
  // ------------------ CRUD de Registro Manejo ------------------ //

  Future<int> insertRegistroManejo(Map<String, dynamic> registroManejo) async {
    try {
      final db = await database;
      return await db.insert('RegistroManejo', registroManejo);
    } catch (e) {
      print("Erro ao inserir Registro de Manejo: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  Future<List<Map<String, dynamic>>> getRegistrosManejo() async {
    try {
      final db = await database;
      return await db.query('RegistroManejo');
    } catch (e) {
      print("Erro ao buscar Registros de Manejo: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<int> updateRegistroManejo(
      Map<String, dynamic> registroManejo, int id) async {
    try {
      final db = await database;
      return await db.update(
        'RegistroManejo',
        registroManejo,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erro ao atualizar Registro de Manejo: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  Future<int> deleteRegistroManejo(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'RegistroManejo',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Erro ao deletar Registro de Manejo: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }
}
