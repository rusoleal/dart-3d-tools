
import 'gltf.dart';

class Texture extends GLTFBase {
  int? sampler;
  int? source;
  String? name;

  Texture({
    this.sampler,
    this.source,
    this.name,
    super.extensions,
    super.extras
  });
}
