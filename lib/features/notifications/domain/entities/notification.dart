import 'dart:convert';

class Notification {
  final int id;
  final int userClientId;
  final DateTime createdAt;
  final int type;
  final String title;
  final String content;
  final bool isRead;
  final bool isHidden;

  const Notification({
    required this.id,
    required this.userClientId,
    required this.createdAt,
    required this.type,
    required this.title,
    required this.content,
    required this.isRead,
    required this.isHidden,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as int,
      userClientId: json['userClientId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: json['type'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      isRead: json['isRead'] as bool,
      isHidden: json['isHidden'] as bool,
    );
  }

  static List<Notification> listFromJson(String str) {
    final List<dynamic> jsonList = json.decode(str);

    return jsonList.map((item) => Notification.fromJson(item as Map<String, dynamic>)).toList();
  }
}