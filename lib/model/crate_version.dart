class CrateVersion {
  const CrateVersion({required this.number, this.downloads = 0, this.createdAt = ''});

  /// `num` in the API (renamed: `num` is also a Dart core type).
  final String number;
  final int downloads;
  final String createdAt;

  factory CrateVersion.fromJson(Map<String, dynamic> json) => CrateVersion(
        number: json['num'] as String,
        downloads: (json['downloads'] as int?) ?? 0,
        createdAt: (json['created_at'] as String?) ?? '',
      );
}
