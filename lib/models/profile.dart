class Profile {
  final String id;
  final String userId;
  String displayName;
  String? avatarUrl;

  Profile({
    required this.id,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
  });

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    id: map['id'] as String,
    userId: map['userId'] as String,
    displayName: map['displayName'] as String,
    avatarUrl: map['avatarUrl'] as String,
  );

  Map<String, dynamic> toMap() => {
    'display_name': displayName,
    'avatar_url': avatarUrl,
  };
}
