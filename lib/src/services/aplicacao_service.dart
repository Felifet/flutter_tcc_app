import 'package:flutter_tcc_app/src/models/aplicacao_model.dart';
import 'package:flutter_tcc_app/src/models/product_model.dart';
import 'package:flutter_tcc_app/src/services/product_service.dart';
import '../services/db_helper.dart';

class AplicacaoService {
  final DBHelper _dbHelper = DBHelper();
  final ProductService _productService = ProductService();

  // Método para buscar aplicações por ID da Gleba e incluir o tipo do produto
  Future<List<Map<String, dynamic>>> getAplicacoesWithProdutoTipoByGlebaId(
      int gleba_id) async {
    final db = await _dbHelper.database;

    // Consulta as aplicações com base no gleba_id
    final List<Map<String, dynamic>> result = await db.query(
      'Aplicacao',
      where: 'gleba_id = ?', // Corrigido para gleba_id
      whereArgs: [gleba_id],
    );

    // Itera sobre as aplicações e carrega o tipo do produto para cada uma
    List<Map<String, dynamic>> aplicacoesComTipos = [];
    for (var aplicacaoMap in result) {
      // Converte o map em um objeto Aplicacao
      Aplicacao aplicacao = Aplicacao.fromMap(aplicacaoMap);

      // Busca o produto associado usando o ID do produto na aplicação
      Product? produto =
          await _productService.getProductById(aplicacao.produtoId);

      // Adiciona o tipo do produto ao map
      aplicacoesComTipos.add({
        'aplicacao': aplicacao,
        'tipoProduto': produto?.tipo ?? 'Desconhecido',
        'vigencia': produto?.vigencia ?? 0, // Vigência do produto
        'carencia': produto?.intervaloDeSeguranca ??
            0 // Carência (intervalo de segurança)
      });
    }

    return aplicacoesComTipos;
  }

  // Novo método para agrupar aplicações por tipo de produto
  Future<List<Map<String, dynamic>>> getAplicacoesAgrupadasPorTipo(
      int gleba_id) async {
    List<Map<String, dynamic>> aplicacoesComTipos =
        await getAplicacoesWithProdutoTipoByGlebaId(gleba_id);

    // Mapa para agrupar os dados
    Map<String, List<Map<String, dynamic>>> agrupadoPorTipo = {};

    // Agrupar por tipo de produto
    for (var aplicacaoComTipo in aplicacoesComTipos) {
      String tipoProduto = aplicacaoComTipo['tipoProduto'];

      if (!agrupadoPorTipo.containsKey(tipoProduto)) {
        agrupadoPorTipo[tipoProduto] = [];
      }

      agrupadoPorTipo[tipoProduto]!.add(aplicacaoComTipo);
    }

    // Converter o agrupamento para uma lista
    List<Map<String, dynamic>> agrupadoFinal =
        agrupadoPorTipo.entries.map((entry) {
      String tipo = entry.key;
      List<Map<String, dynamic>> aplicacoes = entry.value;

      // Somar os valores de vigência e carência
      double totalVigencia =
          aplicacoes.fold(0, (prev, curr) => prev + (curr['vigencia'] ?? 0));
      double totalCarencia =
          aplicacoes.fold(0, (prev, curr) => prev + (curr['carencia'] ?? 0));

      return {
        'tipoProduto': tipo,
        'totalVigencia': totalVigencia,
        'totalCarencia': totalCarencia,
      };
    }).toList();

    return agrupadoFinal;
  }

  // Método para inserir uma nova aplicação
  Future<int> insertAplicacao(Aplicacao aplicacao) async {
    final db = await _dbHelper.database;
    return await db.insert('Aplicacao', aplicacao.toMap());
  }

  // Buscar todas as aplicações
  Future<List<Aplicacao>> getAplicacoes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Aplicacao');

    return List.generate(maps.length, (i) {
      return Aplicacao.fromMap(maps[i]);
    });
  }

  // Método para buscar aplicações por ID da Gleba
  Future<List<Aplicacao>> getAplicacoesByGlebaId(int glebaId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'Aplicacao',
      where: 'gleba_id = ?', // Corrigido para gleba_id
      whereArgs: [glebaId],
    );
    return result.map((map) => Aplicacao.fromMap(map)).toList();
  }

  // Atualizar uma aplicação
  Future<int> updateAplicacao(Aplicacao aplicacao) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Aplicacao',
      aplicacao.toMap(),
      where: 'id = ?',
      whereArgs: [aplicacao.id],
    );
  }

  // Deletar uma aplicação
  Future<int> deleteAplicacao(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Aplicacao',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
