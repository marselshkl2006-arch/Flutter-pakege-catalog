class Crate {
  final String id; // используется как имя
  final String version;
  final String description;
  final int downloads;

  const Crate({
    required this.id,
    required this.version,
    required this.description,
    required this.downloads,
  });
}
