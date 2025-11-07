// permite comparar objetos por sus propiedades
import 'package:equatable/equatable.dart';

// representa un usuario en el sistema
// extendemos Equatable para que podamos comparar dos instancias de UserEntity fácilmente
class UserEntity extends Equatable {

  final String id;
  final String email;
  final String username;     // nombre de usuario (
  final String display;      // nombre para mostrar (nickname)
  final String subscription;
  final String? icon;
  final String? phrase;

  // constructor constante de la clase
  // los campos opcionales (`icon` y `phrase`) no necesitan valor, por eso no son required
  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.display,
    required this.subscription,
    this.icon,
    this.phrase,
  });

  // props de Equatable
  // listamos todas las propiedades que deben considerarse para comparar dos objetos UserEntity
  // esto permite que `user1 == user2` devuelva true si todas estas propiedades son iguales
  @override
  List<Object?> get props => [
    id,
    email,
    username,
    display,
    subscription,
    icon,
    phrase
  ];
}
