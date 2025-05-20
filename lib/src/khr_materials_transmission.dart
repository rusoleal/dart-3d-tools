import '../gltf_loader.dart';

/// KHR_materials_transmission spec.
class KHRMaterialTransmission {
  /// The base percentage of light that is transmitted through the surface.
  double transmissionFactor;

  /// A texture that defines the transmission percentage of the surface, stored
  /// in the R channel. This will be multiplied by transmissionFactor.
  TextureInfo? transmissionTexture;

  KHRMaterialTransmission({
    double? transmissionFactor,
    this.transmissionTexture,
  }) : transmissionFactor = transmissionFactor ?? 0.0;
}
