import 'package:flutter_tcc_app/src/models/aplicacao_model.dart';
import 'package:flutter_tcc_app/src/models/product_model.dart';
import 'package:flutter_tcc_app/src/services/product_service.dart';
import '../services/db_helper.dart';

class AplicacaoService {
  final DBHelper _dbHelper = DBHelper();
  final ProductService _productService = ProductService();

  // Método para buscar aplicações por ID da Gleba e incluir o tipo do produto
  Future<List<Map<String, dynamic>>> getAplicacoesWithProdutoTipoByGlebaId(
      int glebaId) async {
    try {
      final db = await _dbHelper.database;

      // Consulta as aplicações com base no glebaId
      final List<Map<String, dynamic>> result = await db.query(
        'Aplicacao',
        where: 'gleba_id = ?',
        whereArgs: [glebaId],
      );

      // Itera sobre as aplicações e carrega o tipo do produto para cada uma
      List<Map<String, dynamic>> aplicacoesComTipos = [];
      for (var aplicacaoMap in result) {
        Aplicacao aplicacao = Aplicacao.fromMap(aplicacaoMap);
        Product? produto =
            await _productService.getProductById(aplicacao.produtoId);

        aplicacoesComTipos.add({
          'aplicacao': aplicacao,
          'tipoProduto': produto?.tipo ?? 'Desconhecido',
          'vigencia': produto?.vigencia ?? 0,
          'carencia': produto?.intervaloDeSeguranca ?? 0,
        });
      }

      return aplicacoesComTipos;
    } catch (e) {
      print('Erro ao buscar aplicações: $e');
      return [];
    }
  }

  // Novo método para agrupar aplicações por tipo de produto
  Future<List<Map<String, dynamic>>> getAplicacoesAgrupadasPorTipo(
      int glebaId, String s) async {
    List<Map<String, dynamic>> aplicacoesComTipos =
        await getAplicacoesWithProdutoTipoByGlebaId(glebaId);
    return _agruparAplicacoesPorTipo(aplicacoesComTipos);
  }

  // Método auxiliar para agrupar aplicações por tipo
  List<Map<String, dynamic>> _agruparAplicacoesPorTipo(
      List<Map<String, dynamic>> aplicacoesComTipos) {
    Map<String, List<Map<String, dynamic>>> agrupadoPorTipo = {};

    for (var aplicacaoComTipo in aplicacoesComTipos) {
      String tipoProduto = aplicacaoComTipo['tipoProduto'];

      agrupadoPorTipo.putIfAbsent(tipoProduto, () => []).add(aplicacaoComTipo);
    }

    return agrupadoPorTipo.entries.map((entry) {
      String tipo = entry.key;
      List<Map<String, dynamic>> aplicacoes = entry.value;

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

    return List.generate(maps.length, (i) => Aplicacao.fromMap(maps[i]));
  }

  Future<String> getProdutoNomeComercial(int produtoId) async {
    final produto = await _productService.getProductById(produtoId);
    return produto?.nomeComercial ?? 'Produto não encontrado';
  }

  // Método para buscar aplicações por ID da Gleba
  Future<List<Aplicacao>> getAplicacoesByGlebaId(int glebaId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'Aplicacao',
      where: 'gleba_id = ?',
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
