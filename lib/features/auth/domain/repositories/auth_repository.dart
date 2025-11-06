import '../entities/user_entity.dart';

// al ser abstract, no tiene implementación concreta, solo define qué métodos debe tener el repositorio
abstract class AuthRepository {

  // recibe email y password como parámetros
  // devuelve un Future que resolverá en un UserEntity
  // future indica que es una operación asíncrona
  Future<UserEntity> login(String username, String password);

  // devuelve un Future que resolverá en un UserEntity
  Future<UserEntity> register ({
    required String email,
    required String password,
    required String username,
    required String display,
    String? phrase,
    String? iconPath
  });

  // no devuelve un usuario, solo un Future<void> indicando que terminó
  Future<void> logout();

  // devuelve un Future que puede resolver en un UserEntity (si hay sesión activa) o null (si no)
  Future<UserEntity?> checkAuthStatus();
}
