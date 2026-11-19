import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Exceção específica para falhas de leitura ou gravação no armazenamento seguro.
class SecureStorageException implements Exception {
  final String message;
  const SecureStorageException(this.message);

  @override
  String toString() => message;
}

/// Serviço responsável pelo armazenamento seguro do Token JWT utilizando
/// obrigatoriamente o pacote `flutter_secure_storage` (Keystore no Android / Keychain no iOS).

class SecureStorageService {
  static const String _jwtKey = 'jwt_access_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Flag didática para permitir simular falha de leitura/gravação durante a avaliação
  static bool simulateStorageFailure = false;

  /// Salva o JWT Access Token de forma criptografada.
  Future<void> saveToken(String token) async {
    try {
      if (simulateStorageFailure) {
        throw PlatformException(
          code: 'KEYSTORE_ERROR',
          message:
              'Falha simulada ao acessar o Keystore/Keychain do dispositivo.',
        );
      }
      await _storage.write(key: _jwtKey, value: token);
    } on PlatformException catch (e) {
      throw SecureStorageException(
        'Falha na gravação do armazenamento seguro (${e.code}): ${e.message}',
      );
    } catch (e) {
      throw SecureStorageException(
        'Erro inesperado ao gravar token no armazenamento seguro: $e',
      );
    }
  }

  /// Recupera o JWT Access Token do armazenamento seguro.
  Future<String?> getToken() async {
    try {
      if (simulateStorageFailure) {
        throw PlatformException(
          code: 'KEYSTORE_READ_ERROR',
          message:
              'Falha simulada na leitura do token no flutter_secure_storage.',
        );
      }
      return await _storage.read(key: _jwtKey);
    } on PlatformException catch (e) {
      throw SecureStorageException(
        'Falha na leitura do armazenamento seguro (${e.code}): ${e.message}',
      );
    } catch (e) {
      throw SecureStorageException(
        'Erro inesperado ao ler token do armazenamento seguro: $e',
      );
    }
  }

  /// Remove o JWT Access Token (usado no Logout ou quando a API retorna 401 Unauthorized).
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _jwtKey);
    } on PlatformException catch (e) {
      throw SecureStorageException(
        'Falha ao remover token do armazenamento seguro (${e.code}): ${e.message}',
      );
    } catch (e) {
      throw SecureStorageException(
        'Erro inesperado ao remover token do armazenamento seguro: $e',
      );
    }
  }
}
