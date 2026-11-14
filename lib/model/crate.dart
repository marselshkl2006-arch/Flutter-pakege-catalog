/// Field names follow the crates.io API. `dependencies` and `owners` are not part of the
/// search/detail payload: the data layer fills them in from separate endpoints.
class Crate {
  const Crate({
    required this.name,
    required this.version,
    this.description,
    this.downloads = 0,
    this.repository,
    this.documentation,
    this.homepage,
    this.dependencies = const [],
    this.owners = const [],
  });

  final String name;
  final String version; // `max_version` in the API
  final String? description;
  final int downloads;
  final String? repository;
  final String? documentation;
  final String? homepage;
  final List<String> dependencies;
  final List<String> owners;

  factory Crate.fromJson(Map<String, dynamic> json) => Crate(
        name: json['name'] as String,
        version: json['max_version'] as String,
        description: json['description'] as String?,
        downloads: (json['downloads'] as num?)?.toInt() ?? 0,
        repository: json['repository'] as String?,
        documentation: json['documentation'] as String?,
        homepage: json['homepage'] as String?,
      );

  Crate copyWith({List<String>? dependencies, List<String>? owners}) => Crate(
        name: name,
        version: version,
        description: description,
        downloads: downloads,
        repository: repository,
        documentation: documentation,
        homepage: homepage,
        dependencies: dependencies ?? this.dependencies,
        owners: owners ?? this.owners,
      );
}
