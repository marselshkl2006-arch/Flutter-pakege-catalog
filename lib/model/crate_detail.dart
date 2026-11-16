import 'crate.dart';
import 'crate_version.dart';
import 'owner.dart';

class CrateDetail {
  const CrateDetail({
    required this.crate,
    required this.versions,
    required this.owners,
    required this.dependencies,
  });

  final Crate crate;
  final List<CrateVersion> versions;
  final List<Owner> owners;
  final List<String> dependencies;
}
