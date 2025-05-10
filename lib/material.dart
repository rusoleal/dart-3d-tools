import 'utils.dart';
import 'package:vector_math/vector_math.dart';

import 'gltf.dart';

enum AlphaMode { opaque, mask, blend }

class Material extends GLTFBase {
  String? name;
  PBRMetallicRoughness? pbrMetallicRoughness;
  NormalTextureInfo? normalTexture;
  OcclusionTextureInfo? occlusionTexture;
  TextureInfo? emissiveTexture;
  Vector3 emissiveFactor;
  AlphaMode alphaMode;
  double alphaCutoff;
  bool doubleSided;

  Material({
    this.name,
    this.pbrMetallicRoughness,
    this.normalTexture,
    this.occlusionTexture,
    this.emissiveTexture,
    Vector3? emissiveFactor,
    this.alphaMode = AlphaMode.opaque,
    this.alphaCutoff = 0.5,
    this.doubleSided = false,
    super.extensions,
    super.extras,
  }) : emissiveFactor = emissiveFactor ?? Vector3.zero();
}

class PBRMetallicRoughness extends GLTFBase {
  Vector4 baseColorFactor;
  TextureInfo? baseColorTexture;
  double metallicFactor;
  double roughnessFactor;
  TextureInfo? metallicRoughnessTexture;

  PBRMetallicRoughness({
    Vector4? baseColorFactor,
    this.baseColorTexture,
    this.metallicFactor = 1.0,
    this.roughnessFactor = 1.0,
    this.metallicRoughnessTexture,
    super.extensions,
    super.extras,
  }) : baseColorFactor = baseColorFactor ?? Vector4.all(1.0);

  static PBRMetallicRoughness? fromGLTF(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    Vector4 baseColorFactor =
        vec4FromGLTF(data['baseColorFactor']) ?? Vector4.all(1.0);
    TextureInfo? baseColorTexture = TextureInfo.fromGLTF(
      data['baseColorTexture'],
    );
    double metallicFactor = (data['metallicFactor'] ?? 1.0).toDouble();
    double roughnessFactor = (data['roughnessFactor'] ?? 1.0).toDouble();
    TextureInfo? metallicRoughnessTexture = TextureInfo.fromGLTF(
      data['metallicRoughnessTexture'],
    );

    return PBRMetallicRoughness(
      baseColorFactor: baseColorFactor,
      baseColorTexture: baseColorTexture,
      metallicFactor: metallicFactor,
      roughnessFactor: roughnessFactor,
      metallicRoughnessTexture: metallicRoughnessTexture,
    );
  }
}

class TextureInfo extends GLTFBase {
  int index;
  int texCoord;

  TextureInfo({
    required this.index,
    this.texCoord = 0,
    super.extensions,
    super.extras,
  });

  static TextureInfo? fromGLTF(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    int index = data['index'];
    int texCoord = data['texCoord'] ?? 0;
    return TextureInfo(index: index, texCoord: texCoord);
  }
}

class NormalTextureInfo extends TextureInfo {
  double scale;

  NormalTextureInfo({
    required super.index,
    super.texCoord = 0,
    this.scale = 1.0,
    super.extensions,
    super.extras,
  });

  static NormalTextureInfo? fromGLTF(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    int index = data['index'];
    int texCoord = data['texCoord'] ?? 0;
    double scale = data['scale'] ?? 1.0;
    return NormalTextureInfo(index: index, texCoord: texCoord, scale: scale);
  }
}

class OcclusionTextureInfo extends TextureInfo {
  double strength;

  OcclusionTextureInfo({
    required super.index,
    super.texCoord = 0,
    this.strength = 1.0,
    super.extensions,
    super.extras,
  });

  static OcclusionTextureInfo? fromGLTF(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    int index = data['index'];
    int texCoord = data['texCoord'] ?? 0;
    double strength = data['strength'] ?? 1.0;
    return OcclusionTextureInfo(
      index: index,
      texCoord: texCoord,
      strength: strength,
    );
  }
}
