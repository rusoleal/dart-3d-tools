import 'package:vector_math/vector_math.dart';
import '../gltf_loader.dart';

/// KHR_materials_sheen
class KHRMaterialSheen {
  /// The sheen color in linear space
  Vector3 sheenColorFactor;

  /// The sheen color (RGB).
  ///
  /// The sheen color is in sRGB transfer function
  TextureInfo? sheenColorTexture;

  /// The sheen roughness.
  double sheenRoughnessFactor;

  /// The sheen roughness (Alpha) texture.
  TextureInfo? sheenRoughnessTexture;

  KHRMaterialSheen({
    Vector3? sheenColorFactor,
    this.sheenColorTexture,
    double? sheenRoughnessFactor,
    this.sheenRoughnessTexture,
  }) : sheenColorFactor = sheenColorFactor ?? Vector3.zero(),
       sheenRoughnessFactor = sheenRoughnessFactor ?? 0.0;
}
