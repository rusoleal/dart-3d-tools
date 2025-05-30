import '../../gltf_loader.dart';

/// KHR_materials_anisotropy
class KHRMaterialAnisotropy {
  /// The anisotropy strength. When the anisotropy texture is present, this
  /// value is multiplied by the texture's blue channel.
  double anisotropyStrength;

  /// The rotation of the anisotropy in tangent, bitangent space, measured in
  /// radians counter-clockwise from the tangent. When the anisotropy texture
  /// is present, this value provides additional rotation to the vectors in the
  /// texture.
  double anisotropyRotation;

  /// The anisotropy texture. Red and green channels represent the anisotropy
  /// direction in [−1,1] tangent, bitangent space to be rotated by the
  /// anisotropy rotation. The blue channel contains strength as [0,1] to be
  /// multiplied by the anisotropy strength.
  TextureInfo? anisotropyTexture;

  KHRMaterialAnisotropy({
    double? anisotropyStrength,
    double? anisotropyRotation,
    this.anisotropyTexture,
  }) : anisotropyStrength = anisotropyStrength ?? 0.0,
       anisotropyRotation = anisotropyRotation ?? 0.0;
}
