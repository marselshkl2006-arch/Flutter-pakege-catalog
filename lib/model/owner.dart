class Owner {
  const Owner({required this.login, this.name, this.avatar});

  final String login;
  final String? name;
  final String? avatar;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        login: json['login'] as String,
        name: json['name'] as String?,
        avatar: json['avatar'] as String?,
      );
}
