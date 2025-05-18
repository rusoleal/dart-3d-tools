import 'ext_texture_webp.dart';
import 'gltf.dart';

/// A texture and its sampler.
class Texture extends GLTFBase {
  /// The index of the sampler used by this texture. When undefined, a sampler
  /// with repeat wrapping and auto filtering SHOULD be used.
  int? sampler;

  /// The index of the image used by this texture. When undefined, an extension
  /// or other mechanism SHOULD supply an alternate texture source, otherwise
  /// behavior is undefined.
  int? source;

  /// The user-defined name of this object.
  String? name;

  /// EXT_texture_webp
  EXTTextureWebp? extTextureWebp;

  Texture({
    this.sampler,
    this.source,
    this.name,
    this.extTextureWebp,
    super.extensions,
    super.extras,
  });
}
