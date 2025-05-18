import 'gltf.dart';

/// A buffer points to binary geometry, animation, or skins.
class Buffer extends GLTFBase {
  /// The URI (or IRI) of the buffer.
  String? uri;

  /// The length of the buffer in bytes.
  int byteLength;

  /// The user-defined name of this object.
  String? name;

  Buffer({
    this.uri,
    required this.byteLength,
    this.name,
    super.extensions,
    super.extras,
  });
}
