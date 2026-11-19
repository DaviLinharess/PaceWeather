import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/pace_weather_logo.dart';

/// Tela de Login inicial do PaceWeather com Autenticação JWT via HTTPS
/// e armazenamento seguro obrigatório no `flutter_secure_storage`.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Credenciais válidas oficiais da API DummyJSON (HTTPS + JWT real)
  final TextEditingController _usernameController =
      TextEditingController(text: 'emilys');
  final TextEditingController _passwordController =
      TextEditingController(text: 'emilyspass');

  final ApiService _apiService = ApiService();
  final SecureStorageService _secureStorage = SecureStorageService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed({
    ApiTestScenario scenario = ApiTestScenario.normal,
    bool simulateStorageFail = false,
  }) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Informe o usuário e a senha para autenticar.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    SecureStorageService.simulateStorageFailure = simulateStorageFail;

    try {
      // 1. Envia requisição HTTPS POST para o endpoint de autenticação e extrai o JWT
      final jwtToken = await _apiService.login(
        username: username,
        password: password,
        scenario: scenario,
      );

      // 2. Armazena obrigatoriamente o JWT no flutter_secure_storage
      await _secureStorage.saveToken(jwtToken);

      if (!mounted) return;

      // 3. Acessa automaticamente a tela de consulta protegida
      Navigator.of(context).pushReplacementNamed('/main');
    } on SecureStorageException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro inesperado ao autenticar: $e';
      });
    } finally {
      SecureStorageService.simulateStorageFailure = false;
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const PaceWeatherLogo(
                iconSize: 84,
                fontSize: 28,
                showText: true,
              ),
              const SizedBox(height: 6),
              const Text(
                'Autenticação Segura JWT • HTTPS + Secure Storage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Card de Acesso
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Acessar Conta (JWT)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Endpoint: POST https://dummyjson.com/auth/login',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Exibição de erro tratado (caso ocorra)
                    if (_errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Campo Usuário
                    const Text(
                      'Usuário da API (padrão: emilys)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.dark, size: 20),
                        hintText: 'emilys',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Campo Senha
                    const Text(
                      'Senha (padrão: emilyspass)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.dark, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: '••••••',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botão Entrar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryYellow,
                          foregroundColor: AppColors.dark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _isLoading ? null : () => _onLoginPressed(),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.dark,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Autenticar e Consultar API',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.lock_open_rounded, size: 19),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Painel de Teste Rápido dos Cenários Obrigatórios no Login
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TESTAR CENÁRIOS DE ERRO OBRIGATÓRIOS (LOGIN):',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildScenarioChip(
                          label: 'Credenciais Inválidas',
                          onTap: () {
                            _passwordController.text = 'senha_errada';
                            _onLoginPressed();
                          },
                        ),
                        _buildScenarioChip(
                          label: 'Timeout',
                          onTap: () => _onLoginPressed(
                            scenario: ApiTestScenario.simulateTimeout,
                          ),
                        ),
                        _buildScenarioChip(
                          label: 'Servidor Indisponível',
                          onTap: () => _onLoginPressed(
                            scenario: ApiTestScenario.simulateServerUnavailable,
                          ),
                        ),
                        _buildScenarioChip(
                          label: 'JSON Inválido',
                          onTap: () => _onLoginPressed(
                            scenario: ApiTestScenario.simulateInvalidJson,
                          ),
                        ),
                        _buildScenarioChip(
                          label: 'Falha Secure Storage',
                          onTap: () => _onLoginPressed(
                            simulateStorageFail: true,
                          ),
                        ),
                        _buildScenarioChip(
                          label: 'Restaurar Credencial Válida',
                          isHighlight: true,
                          onTap: () {
                            setState(() {
                              _usernameController.text = 'emilys';
                              _passwordController.text = 'emilyspass';
                              _errorMessage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioChip({
    required String label,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isHighlight
              ? AppColors.primaryYellow.withValues(alpha: 0.35)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlight ? AppColors.dark : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.dark,
          ),
        ),
      ),
    );
  }
}
