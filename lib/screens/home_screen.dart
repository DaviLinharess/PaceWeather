import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/api_item_model.dart';
import '../providers/workout_provider.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/pace_weather_logo.dart';
import 'main_navigation_shell.dart';

/// Tela Principal / Tela de Consulta de Dados Protegida por JWT.
/// Assim que o usuário autentica no Login, esta tela é aberta automaticamente,
/// recupera o JWT do `flutter_secure_storage` e realiza o `HTTP GET` (via HTTPS)
/// enviando o cabeçalho `Authorization: Bearer <token>`.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final SecureStorageService _secureStorage = SecureStorageService();

  List<ApiItemModel> _items = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _tokenPreview;

  @override
  void initState() {
    super.initState();
    _loadProtectedData();
  }

  /// Recupera o token do `flutter_secure_storage` e consulta o endpoint protegido da API.
  Future<void> _loadProtectedData({
    ApiTestScenario scenario = ApiTestScenario.normal,
    bool simulateStorageFail = false,
  }) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    SecureStorageService.simulateStorageFailure = simulateStorageFail;

    try {
      // 1. Recupera o token JWT do flutter_secure_storage
      final token = await _secureStorage.getToken();

      if (token == null || token.isEmpty) {
        await _handleUnauthorizedRedirect(
          'Token JWT não encontrado no armazenamento seguro. Redirecionando para o login...',
        );
        return;
      }

      _tokenPreview = token.length > 18 ? '${token.substring(0, 18)}...' : token;

      // 2. Realiza requisição HTTPS GET enviando Authorization: Bearer <token>
      final result = await _apiService.fetchProtectedData(
        token: token,
        scenario: scenario,
      );

      if (!mounted) return;
      setState(() {
        _items = result;
        _isLoading = false;
      });
    } on SecureStorageException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      // REQUISITO OBRIGATÓRIO: Caso o servidor retorne 401 Unauthorized,
      // remove o token do armazenamento seguro e redireciona automaticamente para o login.
      if (e.type == ApiErrorType.expiredOrInvalidToken || e.statusCode == 401) {
        await _handleUnauthorizedRedirect(e.message);
        return;
      }

      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro inesperado ao consultar API: $e';
        _isLoading = false;
      });
    } finally {
      SecureStorageService.simulateStorageFailure = false;
    }
  }

  /// Remove o token do `flutter_secure_storage` e redireciona automaticamente para `/login`
  Future<void> _handleUnauthorizedRedirect(String reason) async {
    try {
      SecureStorageService.simulateStorageFailure = false;
      await _secureStorage.deleteToken();
    } catch (_) {}

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(reason),
        backgroundColor: Colors.red.shade800,
        duration: const Duration(seconds: 4),
      ),
    );

    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Cabeçalho compacto com Logo e Status do JWT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  const PaceWeatherLogo(
                    iconSize: 46,
                    fontSize: 20,
                    showText: false,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Consulta Protegida (JWT)',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dark,
                          ),
                        ),
                        Text(
                          _tokenPreview != null
                              ? 'Bearer $_tokenPreview (SecureStorage)'
                              : 'Verificando token no SecureStorage...',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.dark),
                    tooltip: 'Recarregar GET Protegido',
                    onPressed: _isLoading ? null : () => _loadProtectedData(),
                  ),
                ],
              ),
            ),

            // Bloco Principal com a Lista da API e os Controles
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    // Barra de Teste dos Cenários Obrigatórios na Consulta
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildActionChip(
                              label: 'GET Real (HTTPS)',
                              icon: Icons.cloud_done_outlined,
                              onTap: () => _loadProtectedData(),
                            ),
                            const SizedBox(width: 6),
                            _buildActionChip(
                              label: 'Forçar 401 (Expirado)',
                              icon: Icons.gpp_bad_outlined,
                              isDanger: true,
                              onTap: () => _loadProtectedData(
                                scenario: ApiTestScenario.simulateExpiredToken401,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _buildActionChip(
                              label: 'Timeout',
                              icon: Icons.timer_off_outlined,
                              onTap: () => _loadProtectedData(
                                scenario: ApiTestScenario.simulateTimeout,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _buildActionChip(
                              label: 'Servidor Off',
                              icon: Icons.cloud_off_rounded,
                              onTap: () => _loadProtectedData(
                                scenario:
                                    ApiTestScenario.simulateServerUnavailable,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _buildActionChip(
                              label: 'JSON Inválido',
                              icon: Icons.code_off_rounded,
                              onTap: () => _loadProtectedData(
                                scenario: ApiTestScenario.simulateInvalidJson,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _buildActionChip(
                              label: 'Erro Storage',
                              icon: Icons.storage_rounded,
                              onTap: () => _loadProtectedData(
                                simulateStorageFail: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Card Azul com a Lista de Dados da API Protegida
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: const BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.verified_user_rounded,
                                    size: 18, color: AppColors.dark),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'GET https://dummyjson.com/auth/users (3+ atributos)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Conteúdo da Consulta: Loading, Erro ou Lista com >= 3 atributos
                            Expanded(
                              child: _buildApiContent(),
                            ),

                            const SizedBox(height: 10),

                            // Resumo do Estado Global (Provider) + Navegação Rápida
                            Consumer<WorkoutProvider>(
                              builder: (context, workoutProvider, child) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.dark,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                        onPressed: () {
                                          MainNavigationShell.switchTab(
                                              context, 1);
                                        },
                                        icon: const Icon(
                                            Icons.directions_run_rounded,
                                            size: 18),
                                        label: Text(
                                          'Treinos (${workoutProvider.totalWorkouts})',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: AppColors.dark,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final result =
                                              await Navigator.of(context)
                                                  .pushNamed('/novo_treino');
                                          if (result != null &&
                                              result is Map &&
                                              context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Treino "${result['title']}" salvo!',
                                                ),
                                                backgroundColor: AppColors.dark,
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.add_rounded,
                                            size: 18),
                                        label: const Text(
                                          'Novo Treino',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.dark),
            SizedBox(height: 10),
            Text(
              'Consultando API protegida com Bearer Token...',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade300, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.red, size: 38),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.dark,
              ),
              onPressed: () => _loadProtectedData(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Tentar Novamente (HTTPS Real)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _items[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryYellow,
                child: Text(
                  '#${item.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.dark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Atributo 1: Nome completo
                    Text(
                      item.athleteName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.dark,
                      ),
                    ),
                    // Atributo 2: Categoria / Papel e Idade
                    Text(
                      item.roleCategory,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    // Atributo 3: Cidade / Clima e E-mail
                    Text(
                      '${item.cityWeather} • ${item.email}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDanger ? Colors.red.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDanger ? Colors.white : AppColors.dark,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isDanger ? Colors.white : AppColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
