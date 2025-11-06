import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// caso de uso para registrar un nuevo usuario
class RegisterUseCase {
  // referencia al repositorio de autenticación (inyección de dependencias)
  final AuthRepository repository;

  // cnstructor que recibe el repositorio
  RegisterUseCase(this.repository);

  // método principal para registrar un usuario
  Future<UserEntity> call({
    required String email,
    required String password,
    required String username,
    required String display,
    String? phrase,
    String? iconPath
  }) async {
    // llama al repositorio para registrar al usuario
    // devuelve un UserEntity con los datos del usuario recién registrado
    return await repository.register(
        email: email,
        password: password,
        username: username,
        display: display,
        phrase: phrase,
        iconPath: iconPath
    );
  }
}
