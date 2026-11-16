
import '../model/crate.dart';
import '../model/crate_detail.dart';
import '../model/crate_version.dart';
import '../model/owner.dart';
import 'crates_api.dart';

/// Hand-written sample data shaped exactly like the crates.io API fields, so the UI does not
/// change when the repository switches to the network. Versions, download counts and owners
/// are illustrative, not live values. (Generated from the KMP project's MockData.kt.)
abstract final class MockData {
  static const List<Crate> crates = [
    Crate(
      name: "serde",
      version: "1.0.228",
      downloads: 850000000,
      description: "A generic serialization/deserialization framework",
      repository: "https://github.com/serde-rs/serde",
      documentation: "https://docs.rs/serde",
      homepage: "https://serde.rs",
      dependencies: const ["serde_derive", "serde_core"],
      owners: const ["dtolnay"],
    ),
    Crate(
      name: "tokio",
      version: "1.47.1",
      downloads: 520000000,
      description: "An event-driven, non-blocking I/O platform for writing asynchronous applications",
      repository: "https://github.com/tokio-rs/tokio",
      documentation: "https://docs.rs/tokio",
      homepage: "https://tokio.rs",
      dependencies: const ["bytes", "mio", "parking_lot", "tracing"],
      owners: const ["carllerche", "Darksonn"],
    ),
    Crate(
      name: "reqwest",
      version: "0.12.23",
      downloads: 280000000,
      description: "Higher level HTTP client library",
      repository: "https://github.com/seanmonstar/reqwest",
      documentation: "https://docs.rs/reqwest",
      homepage: "https://github.com/seanmonstar/reqwest",
      dependencies: const ["hyper", "tokio", "serde", "serde_json", "url", "base64"],
      owners: const ["seanmonstar"],
    ),
    Crate(
      name: "clap",
      version: "4.5.48",
      downloads: 450000000,
      description: "A simple to use, efficient, and full-featured command line argument parser",
      repository: "https://github.com/clap-rs/clap",
      documentation: "https://docs.rs/clap",
      homepage: "https://github.com/clap-rs/clap",
      dependencies: const ["anstyle", "strsim", "clap_builder"],
      owners: const ["epage"],
    ),
    Crate(
      name: "anyhow",
      version: "1.0.100",
      downloads: 480000000,
      description: "Flexible concrete Error type built on std::error::Error",
      repository: "https://github.com/dtolnay/anyhow",
      documentation: "https://docs.rs/anyhow",
      homepage: "https://github.com/dtolnay/anyhow",
      dependencies: const ["backtrace"],
      owners: const ["dtolnay"],
    ),
    Crate(
      name: "thiserror",
      version: "2.0.17",
      downloads: 560000000,
      description: "derive(Error) for custom error types",
      repository: "https://github.com/dtolnay/thiserror",
      documentation: "https://docs.rs/thiserror",
      homepage: "https://github.com/dtolnay/thiserror",
      dependencies: const ["thiserror-impl"],
      owners: const ["dtolnay"],
    ),
    Crate(
      name: "rayon",
      version: "1.11.0",
      downloads: 330000000,
      description: "Simple work-stealing parallelism for Rust",
      repository: "https://github.com/rayon-rs/rayon",
      documentation: "https://docs.rs/rayon",
      homepage: "https://github.com/rayon-rs/rayon",
      dependencies: const ["rayon-core", "either"],
      owners: const ["cuviper"],
    ),
    Crate(
      name: "serde_json",
      version: "1.0.145",
      downloads: 620000000,
      description: "A JSON file format implementation for Rust",
      repository: "https://github.com/serde-rs/json",
      documentation: "https://docs.rs/serde_json",
      homepage: "https://github.com/serde-rs/json",
      dependencies: const ["serde", "itoa", "ryu", "memchr"],
      owners: const ["dtolnay"],
    ),
    Crate(
      name: "hyper",
      version: "1.7.0",
      downloads: 400000000,
      description: "A protective and efficient HTTP library for all",
      repository: "https://github.com/hyperium/hyper",
      documentation: "https://docs.rs/hyper",
      homepage: "https://hyper.rs",
      dependencies: const ["tokio", "futures", "http", "bytes"],
      owners: const ["seanmonstar"],
    ),
    Crate(
      name: "axum",
      version: "0.8.6",
      downloads: 130000000,
      description: "Web framework that focuses on ergonomics and modularity",
      repository: "https://github.com/tokio-rs/axum",
      documentation: "https://docs.rs/axum",
      homepage: "https://github.com/tokio-rs/axum",
      dependencies: const ["hyper", "tokio", "tracing", "serde", "serde_json"],
      owners: const ["davidpdrsn"],
    ),
    Crate(
      name: "tracing",
      version: "0.1.41",
      downloads: 360000000,
      description: "Application-level tracing for Rust",
      repository: "https://github.com/tokio-rs/tracing",
      documentation: "https://docs.rs/tracing",
      homepage: "https://tokio.rs",
      dependencies: const ["log", "once_cell", "pin-project-lite"],
      owners: const ["hawkw"],
    ),
    Crate(
      name: "log",
      version: "0.4.28",
      downloads: 700000000,
      description: "A lightweight logging facade for Rust",
      repository: "https://github.com/rust-lang/log",
      documentation: "https://docs.rs/log",
      homepage: "https://github.com/rust-lang/log",
      dependencies: const ["serde", "value-bag"],
      owners: const ["alexcrichton"],
    ),
    Crate(
      name: "rand",
      version: "0.9.2",
      downloads: 600000000,
      description: "Random number generators and other randomness functionality",
      repository: "https://github.com/rust-random/rand",
      documentation: "https://docs.rs/rand",
      homepage: "https://rust-random.github.io/book",
      dependencies: const ["rand_core", "rand_chacha", "serde"],
      owners: const ["dhardy"],
    ),
    Crate(
      name: "regex",
      version: "1.11.3",
      downloads: 650000000,
      description: "An implementation of regular expressions for Rust with linear time matching",
      repository: "https://github.com/rust-lang/regex",
      documentation: "https://docs.rs/regex",
      homepage: "https://github.com/rust-lang/regex",
      dependencies: const ["regex-syntax", "regex-automata", "memchr", "aho-corasick"],
      owners: const ["BurntSushi"],
    ),
    Crate(
      name: "chrono",
      version: "0.4.42",
      downloads: 380000000,
      description: "Date and time library for Rust",
      repository: "https://github.com/chronotope/chrono",
      documentation: "https://docs.rs/chrono",
      homepage: "https://github.com/chronotope/chrono",
      dependencies: const ["num-traits", "serde", "iana-time-zone"],
      owners: const ["djc"],
    ),
    Crate(
      name: "uuid",
      version: "1.18.1",
      downloads: 340000000,
      description: "A library to generate and parse UUIDs",
      repository: "https://github.com/uuid-rs/uuid",
      documentation: "https://docs.rs/uuid",
      homepage: "https://github.com/uuid-rs/uuid",
      dependencies: const ["rand", "serde", "getrandom"],
      owners: const ["KodrAus"],
    ),
    Crate(
      name: "url",
      version: "2.5.7",
      downloads: 420000000,
      description: "URL library for Rust, based on the WHATWG URL Standard",
      repository: "https://github.com/servo/rust-url",
      documentation: "https://docs.rs/url",
      homepage: "https://github.com/servo/rust-url",
      dependencies: const ["percent-encoding", "idna", "serde"],
      owners: const ["SimonSapin"],
    ),
    Crate(
      name: "base64",
      version: "0.22.1",
      downloads: 500000000,
      description: "Encodes and decodes base64 as bytes or utf8",
      repository: "https://github.com/marshallpierce/rust-base64",
      documentation: "https://docs.rs/base64",
      homepage: "https://github.com/marshallpierce/rust-base64",
      dependencies: const ["alloc"],
      owners: const ["marshallpierce"],
    ),
    Crate(
      name: "futures",
      version: "0.3.31",
      downloads: 460000000,
      description: "An implementation of futures and streams featuring zero allocations and composability",
      repository: "https://github.com/rust-lang/futures-rs",
      documentation: "https://docs.rs/futures",
      homepage: "https://rust-lang.github.io/futures-rs",
      dependencies: const ["futures-core", "futures-util", "futures-channel"],
      owners: const ["taiki-e"],
    ),
    Crate(
      name: "once_cell",
      version: "1.21.3",
      downloads: 640000000,
      description: "Single assignment cells and lazy values",
      repository: "https://github.com/matklad/once_cell",
      documentation: "https://docs.rs/once_cell",
      homepage: "https://github.com/matklad/once_cell",
      dependencies: const ["critical-section", "portable-atomic"],
      owners: const ["matklad"],
    ),
    Crate(
      name: "parking_lot",
      version: "0.12.5",
      downloads: 410000000,
      description: "More compact and efficient implementations of the standard synchronization primitives",
      repository: "https://github.com/Amanieu/parking_lot",
      documentation: "https://docs.rs/parking_lot",
      homepage: "https://github.com/Amanieu/parking_lot",
      dependencies: const ["lock_api", "parking_lot_core"],
      owners: const ["Amanieu"],
    ),
    Crate(
      name: "itertools",
      version: "0.14.0",
      downloads: 430000000,
      description: "Extra iterator adaptors, iterator methods, free functions, and macros",
      repository: "https://github.com/rust-itertools/itertools",
      documentation: "https://docs.rs/itertools",
      homepage: "https://github.com/rust-itertools/itertools",
      dependencies: const ["either"],
      owners: const ["bluss", "jswrenn"],
    ),
    Crate(
      name: "syn",
      version: "2.0.106",
      downloads: 900000000,
      description: "Parser for Rust source code",
      repository: "https://github.com/dtolnay/syn",
      documentation: "https://docs.rs/syn",
      homepage: "https://github.com/dtolnay/syn",
      dependencies: const ["proc-macro2", "quote", "unicode-ident"],
      owners: const ["dtolnay"],
    ),
    Crate(
      name: "bytes",
      version: "1.10.1",
      downloads: 580000000,
      description: "Types and traits for working with bytes",
      repository: "https://github.com/tokio-rs/bytes",
      documentation: "https://docs.rs/bytes",
      homepage: "https://github.com/tokio-rs/bytes",
      dependencies: const ["serde"],
      owners: const ["carllerche", "Darksonn"],
    ),
  ];

  static const Map<String, String> _ownerNames = {
    "dtolnay": "David Tolnay",
    "carllerche": "Carl Lerche",
    "Darksonn": "Alice Ryhl",
    "seanmonstar": "Sean McArthur",
    "BurntSushi": "Andrew Gallant",
    "matklad": "Aleksey Kladov",
    "Amanieu": "Amanieu d'Antras",
    "cuviper": "Josh Stone",
  };

  static final List<Owner> owners = [
    for (final login in {for (final c in crates) ...c.owners})
      Owner(login: login, name: _ownerNames[login], avatar: 'https://github.com/$login.png'),
  ];
}

/// [CratesDataSource] backed by [MockData]; mimics API latency and 404s.
class MockCratesSource implements CratesDataSource {
  MockCratesSource({this.latency = const Duration(milliseconds: 250)});

  final Duration latency;

  @override
  Future<List<Crate>> search(String query, int page, [int perPage = defaultPerPage]) async {
    await Future<void>.delayed(latency);
    final q = query.trim().toLowerCase();
    final matches = MockData.crates.where((c) =>
        q.isEmpty || c.name.toLowerCase().contains(q) || (c.description ?? '').toLowerCase().contains(q));
    final size = perPage.clamp(1, maxPerPage).toInt();
    return matches.skip(((page < 1 ? 1 : page) - 1) * size).take(size).toList();
  }

  @override
  Future<CrateDetail> getCrate(String name) async {
    await Future<void>.delayed(latency);
    final crate = _find(name);
    return CrateDetail(
      crate: crate,
      versions: _fakeVersions(crate),
      owners: _ownersOf(crate),
      dependencies: crate.dependencies,
    );
  }

  @override
  Future<List<String>> getDependencies(String name) async {
    await Future<void>.delayed(latency);
    return _find(name).dependencies;
  }

  @override
  Future<List<Owner>> getOwners(String name) async {
    await Future<void>.delayed(latency);
    return _ownersOf(_find(name));
  }

  @override
  Future<Owner> getUser(String login) async {
    await Future<void>.delayed(latency);
    for (final o in MockData.owners) {
      if (o.login == login) return o;
    }
    throw NotFoundError(login);
  }

  Crate _find(String name) {
    for (final c in MockData.crates) {
      if (c.name == name) return c;
    }
    throw NotFoundError(name);
  }

  List<Owner> _ownersOf(Crate crate) => [
        for (final login in crate.owners)
          MockData.owners.firstWhere((o) => o.login == login, orElse: () => Owner(login: login)),
      ];

  /// Derives a short version history from max_version ("1.2.3" -> 1.2.3, 1.2.2, 1.1.0).
  List<CrateVersion> _fakeVersions(Crate crate) {
    final parts = crate.version.split('.').map(int.tryParse).toList();
    if (parts.length < 3 || parts.contains(null)) {
      return [CrateVersion(number: crate.version, downloads: crate.downloads, createdAt: '2025-01-01T00:00:00Z')];
    }
    final major = parts[0]!, minor = parts[1]!, patch = parts[2]!;
    return [
      CrateVersion(number: '$major.$minor.$patch', downloads: crate.downloads ~/ 10, createdAt: '2025-09-01T00:00:00Z'),
      CrateVersion(
          number: '$major.$minor.${patch > 0 ? patch - 1 : 0}',
          downloads: crate.downloads ~/ 8,
          createdAt: '2025-07-15T00:00:00Z'),
      CrateVersion(
          number: '$major.${minor > 0 ? minor - 1 : 0}.0',
          downloads: crate.downloads ~/ 5,
          createdAt: '2025-03-01T00:00:00Z'),
    ];
  }
}
