import 'gltf.dart';

/// Image data used to create a texture. Image MAY be referenced by an URI
/// (or IRI) or a buffer view index.
class Image extends GLTFBase {
  /// The URI (or IRI) of the image.
  String? uri;

  /// The image’s media type. This field MUST be defined when bufferView is
  /// defined.
  String? mimeType;

  /// The index of the bufferView that contains the image. This field MUST NOT
  /// be defined when uri is defined.
  int? bufferView;

  /// The user-defined name of this object.
  String? name;

  Image({
    this.uri,
    this.mimeType,
    this.bufferView,
    this.name,
    super.extensions,
    super.extras,
  });
}
