import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// "caso de uso" de la aplicación: iniciar sesión
// los casos de uso encapsulan la lógica de negocio de manera limpia
class LoginUseCase {
  // guardamos una referencia al repositorio de autenticación
  final AuthRepository repository;

  // constructor que recibe el repositorio como dependencia
  LoginUseCase(this.repository);

  // al llamarlo (call) se realiza el login
  // Recibe email y password
  // devuelve un Future<UserEntity>, porque el login puede tardar (operación asíncrona)
  Future<UserEntity> call(String username, String password) async {
    // llama al método login del repositorio y espera la respuesta
    return await repository.login(username, password);
  }
}
