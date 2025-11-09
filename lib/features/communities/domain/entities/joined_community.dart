class JoinedCommunity {
  final int userClientId;
  final int communityId;
  final DateTime joinedDate;

  JoinedCommunity({
    required this.userClientId,
    required this.communityId,
    required this.joinedDate,
  });

  factory JoinedCommunity.fromJson(Map<String, dynamic> json) {
    return JoinedCommunity(
      userClientId: json['userClientId'] as int,
      communityId: json['communityId'] as int,
      joinedDate: DateTime.parse(json['joinedDate'] as String),
    );
  }
}