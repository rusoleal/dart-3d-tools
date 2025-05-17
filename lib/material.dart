import 'package:gltf_loader/khr_materials_ior.dart';
import 'package:gltf_loader/khr_materials_specular.dart';
import 'package:gltf_loader/khr_texture_transform.dart';

import 'utils.dart';
import 'package:vector_math/vector_math.dart';

import 'gltf.dart';
import 'mesh.dart';
import 'texture.dart';

/// The material’s alpha rendering mode enumeration specifying
/// the interpretation of the alpha value of the base color.
enum AlphaMode {
  /// The alpha value is ignored, and the rendered output is fully opaque.
  opaque,

  /// The rendered output is either fully opaque or fully transparent depending
  /// on the alpha value and the specified alphaCutoff value; the exact
  /// appearance of the edges MAY be subject to implementation-specific
  /// techniques such as “Alpha-to-Coverage”.
  mask,

  /// The alpha value is used to composite the source and destination areas.
  /// The rendered output is combined with the background using the normal
  /// painting operation (i.e. the Porter and Duff over operator).
  blend,
}

/// The material appearance of a [Primitive].
class Material extends GLTFBase {
  /// The user-defined name of this object. This is not necessarily unique,
  /// e.g., an accessor and a buffer could have the same name, or two accessors
  /// could even have the same name.
  String? name;

  /// A set of parameter values that are used to define the metallic-roughness
  /// material model from Physically Based Rendering (PBR) methodology.
  ///
  /// When undefined, all the default values of pbrMetallicRoughness MUST apply.
  PBRMetallicRoughness? pbrMetallicRoughness;

  /// The tangent space normal texture. The texture encodes RGB components with
  /// linear transfer function. Each texel represents the XYZ components of a
  /// normal vector in tangent space. The normal vectors use the convention
  /// +X is right and +Y is up. +Z points toward the viewer. If a fourth
  /// component (A) is present, it MUST be ignored. When undefined, the material
  /// does not have a tangent space normal texture.
  NormalTextureInfo? normalTexture;

  /// The occlusion texture. The occlusion values are linearly sampled from the
  /// R channel. Higher values indicate areas that receive full indirect
  /// lighting and lower values indicate no indirect lighting. If other channels
  /// are present (GBA), they MUST be ignored for occlusion calculations. When
  /// undefined, the material does not have an occlusion texture.
  OcclusionTextureInfo? occlusionTexture;

  /// The emissive texture. It controls the color and intensity of the light
  /// being emitted by the material. This texture contains RGB components
  /// encoded with the sRGB transfer function. If a fourth component (A) is
  /// present, it MUST be ignored. When undefined, the texture MUST be sampled
  /// as having 1.0 in RGB components.
  TextureInfo? emissiveTexture;

  /// The factors for the emissive color of the material. This value defines
  /// linear multipliers for the sampled texels of the emissive texture.
  Vector3 emissiveFactor;

  /// The material’s alpha rendering mode enumeration specifying the
  /// interpretation of the alpha value of the base color.
  AlphaMode alphaMode;

  /// Specifies the cutoff threshold when in [AlphaMode.mask]. If the alpha
  /// value is greater than or equal to this value then it is rendered as fully
  /// opaque, otherwise, it is rendered as fully transparent. A value greater
  /// than 1.0 will render the entire material as fully transparent. This value
  /// MUST be ignored for other alpha modes. When alphaMode is not defined, this
  /// value MUST NOT be defined.
  double alphaCutoff;

  /// Specifies whether the material is double sided. When this value is false,
  /// back-face culling is enabled. When this value is true, back-face culling
  /// is disabled and double-sided lighting is enabled. The back-face MUST have
  /// its normals reversed before the lighting equation is evaluated.
  bool doubleSided;

  /// KHR_materials_specular
  KHRMaterialSpecular? khrMaterialSpecular;

  /// KHR_materials_ior
  KHRMaterialIor? khrMaterialIor;

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
    this.khrMaterialSpecular,
    this.khrMaterialIor,
  }) : emissiveFactor = emissiveFactor ?? Vector3.zero();
}

/// A set of parameter values that are used to define the metallic-roughness
/// material model from Physically Based Rendering (PBR) methodology.
class PBRMetallicRoughness extends GLTFBase {
  /// The factors for the base color of the material. This value defines linear
  /// multipliers for the sampled texels of the base color texture.
  Vector4 baseColorFactor;

  /// The base color texture. The first three components (RGB) MUST be encoded
  /// with the sRGB transfer function. They specify the base color of the
  /// material. If the fourth component (A) is present, it represents the linear
  /// alpha coverage of the material. Otherwise, the alpha coverage is equal
  /// to 1.0. The [Material.alphaMode] property specifies how alpha is
  /// interpreted. The stored texels MUST NOT be premultiplied. When undefined,
  /// the texture MUST be sampled as having 1.0 in all components.
  TextureInfo? baseColorTexture;

  /// The factor for the metalness of the material. This value defines a linear
  /// multiplier for the sampled metalness values of the metallic-roughness
  /// texture.
  double metallicFactor;

  /// The factor for the roughness of the material. This value defines a linear
  /// multiplier for the sampled roughness values of the metallic-roughness
  /// texture.
  double roughnessFactor;

  /// The metallic-roughness texture. The metalness values are sampled from the
  /// B channel. The roughness values are sampled from the G channel. These
  /// values MUST be encoded with a linear transfer function. If other channels
  /// are present (R or A), they MUST be ignored for metallic-roughness
  /// calculations. When undefined, the texture MUST be sampled as having 1.0
  /// in G and B components.
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

/// Base class for texture base information.
class TextureInfo extends GLTFBase {
  /// The index of the [Texture].
  int index;

  /// This integer value is used to construct a string in the format
  /// TEXCOORD_&lt;set index&gt; which is a reference to a key in
  /// mesh.primitives.attributes (e.g. a value of 0 corresponds to TEXCOORD_0).
  /// A mesh primitive MUST have the corresponding texture coordinate attributes
  /// for the material to be applicable to it.
  int texCoord;

  KHRTextureTransform? khrTextureTransform;

  TextureInfo({
    required this.index,
    this.texCoord = 0,
    this.khrTextureTransform,
    super.extensions,
    super.extras,
  });

  static TextureInfo? fromGLTF(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    int index = data['index'];
    int texCoord = data['texCoord'] ?? 0;

    KHRTextureTransform? khrTextureTransform;

    var extensions = data['extensions'];
    if (extensions != null) {
      var khrTextureTransformData = extensions['KHR_texture_transform'];
      Vector2? offset = vec2FromGLTF(khrTextureTransformData['offset']);
      double? rotation = khrTextureTransformData['rotation'];
      Vector2? scale = vec2FromGLTF(khrTextureTransformData['scale']);
      khrTextureTransform = KHRTextureTransform(
        offset: offset,
        rotation: rotation,
        scale: scale,
      );
    }

    return TextureInfo(
      index: index,
      texCoord: texCoord,
      khrTextureTransform: khrTextureTransform,
    );
  }
}

/// The tangent space normal texture.
///
/// The texture encodes RGB components with linear transfer function. Each texel
/// represents the XYZ components of a normal vector in tangent space.
///
/// The normal vectors use the convention +X is right and +Y is up. +Z points
/// toward the viewer. If a fourth component (A) is present, it MUST be ignored.
class NormalTextureInfo extends TextureInfo {
  /// The scalar parameter applied to each normal vector of the texture. This
  /// value scales the normal vector in X and Y directions using the formula:
  /// scaledNormal = normalize&lt;sampled normal texture value&gt; * 2.0 - 1.0) *
  /// vec3(&lt;normal scale&gt;, &lt;normal scale&gt;, 1.0).
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
    double scale = ((data['scale'] as num?) ?? 1.0).toDouble();
    return NormalTextureInfo(index: index, texCoord: texCoord, scale: scale);
  }
}

/// The occlusion texture.
///
/// The occlusion values are linearly sampled from the R channel.
///
/// Higher values indicate areas that receive full indirect lighting and lower
/// values indicate no indirect lighting. If other channels are present (GBA),
/// they MUST be ignored for occlusion calculations.
class OcclusionTextureInfo extends TextureInfo {
  /// A scalar parameter controlling the amount of occlusion applied. A value
  /// of 0.0 means no occlusion. A value of 1.0 means full occlusion. This value
  /// affects the final occlusion value as:
  /// 1.0 + strength * (&lt;sampled occlusion texture value&gt; - 1.0).
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
