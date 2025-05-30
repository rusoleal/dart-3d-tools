import '../material.dart';

/// In this extension, a new emissiveStrength scalar factor is supplied, that
/// governs the upper limit of emissive strength per [Material].
class KHRMaterialEmissiveStrength {
  /// The strength adjustment to be multiplied with the material's emissive
  /// value.
  double emissiveStrength;

  KHRMaterialEmissiveStrength({double? emissiveStrength})
    : emissiveStrength = emissiveStrength ?? 1.0;
}
