import '../../domain/entities/user_entity.dart';

// --- Modelo de datos que extiende la entidad ---
class UserModel extends UserEntity {
  // constructor que llama al constructor de la entidad
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.display,
    required super.subscription,
    super.icon,
    super.phrase
  });

  // --- Crear un UserModel a partir de un JSON ---
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'].toString(),
        email: json['email'] ?? '',
        username: json['username'] ?? '',
        display: json['display'] ?? '',
        icon: json['icon'],
        phrase: json['phrase'],
        subscription: json['subscription'] ?? 'freeplan'
    );
  }

  // --- Convertir el modelo a JSON para enviarlo al backend o almacenamiento ---
  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? 0,
      'email': email,
      'username': username,
      'display': display,
      'icon': icon,
      'phrase': phrase,
      'subscription': subscription,
    };
  }

  // factory para crear un UserModel a partir de un UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
        id: entity.id,
        email: entity.email,
        username: entity.username,
        display: entity.display,
        subscription: entity.subscription,
        icon: entity.icon,
        phrase: entity.phrase
    );
  }
}
