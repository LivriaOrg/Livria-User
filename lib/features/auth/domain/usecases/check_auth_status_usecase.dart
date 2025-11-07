import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// caso de uso para verificar si un usuario ya está autenticado
class CheckAuthStatusUseCase {
  // referencia al repositorio de autenticación
  final AuthRepository repository;

  // constructor que recibe el repositorio (inyección de dependencias)
  CheckAuthStatusUseCase(this.repository);

  // retorna un UserEntity si hay un usuario autenticado, o null si no
  Future<UserEntity?> call() async {
    // llama al repositorio para verificar si existe una sesión activa
    return await repository.checkAuthStatus();
  }
}
