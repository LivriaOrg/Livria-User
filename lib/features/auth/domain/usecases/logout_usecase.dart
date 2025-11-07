import '../repositories/auth_repository.dart';

// caso de uso para cerrar la sesión del usuario
class LogoutUseCase {
  // referencia al repositorio de autenticación
  final AuthRepository repository;

  // constructor que recibe el repositorio (inyección de dependencias)
  LogoutUseCase(this.repository);

  // no retorna nada (void), simplemente realiza el logout
  Future<void> call() async {
    // llama al repositorio para invalidar la sesión o eliminar tokens locales
    return await repository.logout();
  }
}
