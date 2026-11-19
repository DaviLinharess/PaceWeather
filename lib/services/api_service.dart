import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_item_model.dart';

/// Enumeração dos cenários obrigatórios exigidos na atividade
enum ApiErrorType {
  serverUnavailable,
  connectionTimeout,
  invalidCredentials,
  expiredOrInvalidToken, // 401 Unauthorized
  invalidJsonFormat,
  secureStorageError,
}

/// Modo de execução para permitir tanto a chamada HTTPS real quanto a demonstração
/// sob demanda dos 6 cenários de erro obrigatórios durante a apresentação.
enum ApiTestScenario {
  normal, // Requisição HTTPS real para https://dummyjson.com
  simulateServerUnavailable,
  simulateTimeout,
  simulateInvalidJson,
  simulateExpiredToken401,
}

/// Exceção padronizada para comunicação segura com a API REST
class ApiException implements Exception {
  final ApiErrorType type;
  final String message;
  final int? statusCode;

  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Serviço de comunicação segura via HTTPS + JWT.
class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  static const Duration _timeoutDuration = Duration(seconds: 10);

  /// Realiza a autenticação via HTTP POST (HTTPS) e extrai o JWT Access Token do JSON.
  Future<String> login({
    required String username,
    required String password,
    ApiTestScenario scenario = ApiTestScenario.normal,
  }) async {
    try {
      // Simulações didáticas para facilitar o teste dos cenários obrigatórios
      if (scenario == ApiTestScenario.simulateTimeout) {
        await Future.delayed(const Duration(milliseconds: 600));
        throw TimeoutException('Tempo limite de conexão esgotado (10s).');
      }
      if (scenario == ApiTestScenario.simulateServerUnavailable) {
        await Future.delayed(const Duration(milliseconds: 400));
        throw const SocketException('Servidor indisponível ou sem conexão de rede.');
      }

      final uri = Uri.parse('$_baseUrl/auth/login');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username.trim(),
              'password': password.trim(),
              'expiresInMins': 30,
            }),
          )
          .timeout(_timeoutDuration);

      if (scenario == ApiTestScenario.simulateInvalidJson) {
        // Força a leitura de um payload corrompido para acionar FormatException
        jsonDecode('{json_invalido_malformado:');
      }

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('O JSON retornado não é um objeto válido.');
        }

        // Extrai o JWT Access Token (DummyJSON retorna em 'accessToken' ou 'token')
        final String? jwtToken =
            (decoded['accessToken'] ?? decoded['token'])?.toString();

        if (jwtToken == null || jwtToken.isEmpty) {
          throw const FormatException(
            'Token JWT ausente na resposta JSON do servidor.',
          );
        }

        return jwtToken;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        throw ApiException(
          type: ApiErrorType.invalidCredentials,
          statusCode: response.statusCode,
          message:
              'Credenciais inválidas (HTTP ${response.statusCode}). Verifique usuário e senha.',
        );
      } else if (response.statusCode >= 500) {
        throw ApiException(
          type: ApiErrorType.serverUnavailable,
          statusCode: response.statusCode,
          message:
              'Servidor indisponível no momento (HTTP ${response.statusCode}). Tente mais tarde.',
        );
      } else {
        throw ApiException(
          type: ApiErrorType.serverUnavailable,
          statusCode: response.statusCode,
          message: 'Erro inesperado na API (HTTP ${response.statusCode}).',
        );
      }
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        type: ApiErrorType.connectionTimeout,
        message:
            'Timeout de conexão: O servidor demorou muito para responder.',
      );
    } on SocketException {
      throw const ApiException(
        type: ApiErrorType.serverUnavailable,
        message:
            'Servidor indisponível: Falha ao conectar via HTTPS (verifique a internet ou o servidor).',
      );
    } on FormatException catch (e) {
      throw ApiException(
        type: ApiErrorType.invalidJsonFormat,
        message:
            'Resposta JSON inválida recebida da API: ${e.message}',
      );
    } catch (e) {
      throw ApiException(
        type: ApiErrorType.serverUnavailable,
        message: 'Erro de comunicação com o servidor: $e',
      );
    }
  }

  /// Realiza requisição HTTP GET para endpoint protegido da API utilizando HTTPS e o cabeçalho:
  /// `Authorization: Bearer <token>`
  Future<List<ApiItemModel>> fetchProtectedData({
    required String token,
    ApiTestScenario scenario = ApiTestScenario.normal,
  }) async {
    try {
      if (scenario == ApiTestScenario.simulateTimeout) {
        await Future.delayed(const Duration(milliseconds: 600));
        throw TimeoutException('Tempo limite esgotado ao consultar endpoint protegido.');
      }
      if (scenario == ApiTestScenario.simulateServerUnavailable) {
        await Future.delayed(const Duration(milliseconds: 400));
        throw const SocketException('Host da API inacessível.');
      }

      // Se o cenário de teste for 401 Token Expirado, enviamos um token inválido para a API real
      // para que o próprio servidor responda com 401 Unauthorized real (ou forçamos caso offline)
      final effectiveToken =
          scenario == ApiTestScenario.simulateExpiredToken401
              ? 'token_jwt_expirado_ou_invalido_teste_401'
              : token;

      final uri = Uri.parse('$_baseUrl/auth/users?limit=6');
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $effectiveToken',
            },
          )
          .timeout(_timeoutDuration);

      if (scenario == ApiTestScenario.simulateInvalidJson) {
        jsonDecode('<<<resposta_nao_json>>>');
      }

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is! Map<String, dynamic> || decoded['users'] is! List) {
          throw const FormatException(
            'Estrutura JSON inesperada na resposta da consulta.',
          );
        }

        final List<dynamic> rawList = decoded['users'] as List<dynamic>;
        return rawList
            .whereType<Map<String, dynamic>>()
            .map(ApiItemModel.fromJson)
            .toList();
      } else if (response.statusCode == 401) {
        throw const ApiException(
          type: ApiErrorType.expiredOrInvalidToken,
          statusCode: 401,
          message:
              '401 Unauthorized: Sessão expirada ou token JWT inválido. Faça login novamente.',
        );
      } else if (response.statusCode >= 500) {
        throw ApiException(
          type: ApiErrorType.serverUnavailable,
          statusCode: response.statusCode,
          message:
              'Servidor indisponível (HTTP ${response.statusCode}).',
        );
      } else {
        throw ApiException(
          type: ApiErrorType.serverUnavailable,
          statusCode: response.statusCode,
          message: 'Erro ao consultar dados protegidos (HTTP ${response.statusCode}).',
        );
      }
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        type: ApiErrorType.connectionTimeout,
        message:
            'Timeout de conexão ao consultar os dados protegidos.',
      );
    } on SocketException {
      // Caso o aluno clique em "Simular 401" mesmo sem internet, garante a demonstração do 401
      if (scenario == ApiTestScenario.simulateExpiredToken401) {
        throw const ApiException(
          type: ApiErrorType.expiredOrInvalidToken,
          statusCode: 401,
          message:
              '401 Unauthorized: Token JWT expirado ou inválido.',
        );
      }
      throw const ApiException(
        type: ApiErrorType.serverUnavailable,
        message:
            'Servidor indisponível: Não foi possível estabelecer conexão HTTPS.',
      );
    } on FormatException catch (e) {
      throw ApiException(
        type: ApiErrorType.invalidJsonFormat,
        message: 'Resposta JSON inválida na consulta: ${e.message}',
      );
    } catch (e) {
      throw ApiException(
        type: ApiErrorType.serverUnavailable,
        message: 'Falha ao consultar API protegida: $e',
      );
    }
  }
}
