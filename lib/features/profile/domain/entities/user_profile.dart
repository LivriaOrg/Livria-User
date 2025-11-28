class UserProfile {
  final int id;
  final String display;
  final String username;
  final String email;
  final String icon;
  final String phrase;
  final String subscription;

  const UserProfile({
    required this.id,
    required this.display,
    required this.username,
    required this.email,
    required this.icon,
    required this.phrase,
    required this.subscription,
  });

  factory UserProfile.empty() {
    return const UserProfile(
      id: 0,
      display: '',
      username: '',
      email: '',
      icon: '',
      phrase: '',
      subscription: 'freeplan',
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? 0,
      display: map['display'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      icon: map['icon'] ?? '',
      phrase: map['phrase'] ?? '',
      subscription: map['subscription'] ?? 'Free Plan',
    );
  }

  // Convertir Objeto Dart a JSON (Para el PUT de editar perfil)
  Map<String, dynamic> toMap() {
    return {
      'display': display,
      'username': username,
      'email': email,
      'icon': icon,
      'phrase': phrase,
    };
  }

  UserProfile copyWith({
    String? display,
    String? username,
    String? email,
    String? icon,
    String? phrase,
    String? subscription,
  }) {
    return UserProfile(
      id: id,
      display: display ?? this.display,
      username: username ?? this.username,
      email: email ?? this.email,
      icon: icon ?? this.icon,
      phrase: phrase ?? this.phrase,
      subscription: subscription ?? this.subscription,
    );
  }
}