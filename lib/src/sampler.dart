import 'gltf.dart';

enum MagFilterMode { nearest, linear }

enum MinFilterMode {
  nearest,
  linear,
  nearestMipmapNearest,
  linearMipmapNearest,
  nearestMipmapLinear,
  linearMipmapLinear,
}

enum WrapMode { clampToEdge, mirroredRepeat, repeat }

class Sampler extends GLTFBase {
  MagFilterMode? magFilter;
  MinFilterMode? minFilter;
  WrapMode wrapS;
  WrapMode wrapT;
  String? name;

  Sampler({
    this.magFilter,
    this.minFilter,
    this.wrapS = WrapMode.repeat,
    this.wrapT = WrapMode.repeat,
    this.name,
    super.extensions,
    super.extras,
  });
}
