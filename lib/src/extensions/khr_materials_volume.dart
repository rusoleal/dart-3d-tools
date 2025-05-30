import 'package:vector_math/vector_math.dart';
import '../../gltf_loader.dart';

/// KHR_materials_volume
class KHRMaterialVolume {
  /// The thickness of the volume beneath the surface. The value is given in the
  /// coordinate space of the mesh. If the value is 0 the material is
  /// thin-walled. Otherwise the material is a volume boundary. The doubleSided
  /// property has no effect on volume boundaries. Range is [0, +inf).
  double thicknessFactor;

  /// A texture that defines the thickness, stored in the G channel. This will
  /// be multiplied by thicknessFactor. Range is [0, 1].
  TextureInfo? thicknessTexture;

  /// Density of the medium given as the average distance that light travels in
  /// the medium before interacting with a particle. The value is given in world
  /// space. Range is (0, +inf).
  double attenuationDistance;

  /// The color that white light turns into due to absorption when reaching the
  /// attenuation distance.
  Vector3 attenuationColor;

  KHRMaterialVolume({
    double? thicknessFactor,
    this.thicknessTexture,
    double? attenuationDistance,
    Vector3? attenuationColor,
  }) : thicknessFactor = thicknessFactor ?? 0.0,
       attenuationDistance = attenuationDistance ?? double.infinity,
       attenuationColor = attenuationColor ?? Vector3.all(1.0);
}
