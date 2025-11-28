import '../entities/user_profile.dart';

abstract class ProfileRepository {
  // Obtener perfil
  Future<UserProfile> getUserProfile(int userId);

  // Actualizar perfil
  Future<UserProfile> updateUserProfile(int userId, UserProfile updatedProfile);

  // Borrar cuenta
  Future<void> deleteAccount(int userId);
}