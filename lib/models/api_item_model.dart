/// Modelo desserializado a partir do JSON retornado pelo endpoint protegido da API REST.
/// Cumpre o requisito de apresentar, no mínimo, três atributos de cada objeto na lista.
class ApiItemModel {
  final int id;
  final String athleteName; // Atributo 1: Nome do atleta/corredor
  final String roleCategory; // Atributo 2: Categoria / Nível
  final String cityWeather; // Atributo 3: Cidade / Condição climática de treino
  final String email; // Atributo 4: E-mail de contato

  const ApiItemModel({
    required this.id,
    required this.athleteName,
    required this.roleCategory,
    required this.cityWeather,
    required this.email,
  });

  /// Desserializa o objeto JSON retornado pelo endpoint protegido `GET https://dummyjson.com/auth/users`
  factory ApiItemModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString() ?? '';
    final lastName = json['lastName']?.toString() ?? '';
    final fullName = '$firstName $lastName'.trim();

    final address = json['address'] as Map<String, dynamic>?;
    final city = address?['city']?.toString() ?? 'Local Padrão';
    final age = json['age']?.toString() ?? '25';

    return ApiItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      athleteName: fullName.isEmpty ? 'Corredor #${json['id']}' : fullName,
      roleCategory: 'Categoria: ${json['role']?.toString().toUpperCase() ?? 'RUNNER'} (${age}a)',
      cityWeather: 'Cidade: $city • Clima Ideal (21°C)',
      email: json['email']?.toString() ?? 'sem-email@paceweather.com',
    );
  }
}
