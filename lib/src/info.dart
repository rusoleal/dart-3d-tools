import 'package:gltf_loader/src/utils.dart' as Utils;

/// Information about loaded asset.
class Info {
  /// name of asset extracted from filename or url paht.
  String name;

  /// copyright information. From glTF.asset.copyright.
  String? copyright;

  /// generator information. From glTF.asset.generator.
  String? generator;

  /// version information. From glTF.asset.version.
  String version;

  /// minimum version supported by this loader. From glTF.asset.minVersion.
  String? minVersion;

  /// extensions used by this asset. From glTF.extensionsUsed.
  List<String> extensionsUsed;

  /// extensions required by this asset. From glTF.extensionsRequired.
  List<String> extensionsRequired;

  Info({
    required this.name,
    this.copyright,
    this.generator,
    required this.version,
    this.minVersion,
    required this.extensionsUsed,
    required this.extensionsRequired,
  });

  static fromJson(String name, Map<String, dynamic> json) {
    return Info(
      name: name,
      copyright: json['asset']['copyright'],
      generator: json['asset']['generator'],
      version: json['asset']['version'],
      minVersion: json['asset']['minVersion'],
      extensionsRequired: Utils.stringListFromGLTF(json['extensionsRequired']),
      extensionsUsed: Utils.stringListFromGLTF(json['extensionsUsed']),
    );
  }
}
