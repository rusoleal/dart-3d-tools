import '../../gltf_loader.dart';

/// Iridescence describes an effect where hue varies depending on the viewing
/// angle and illumination angle: A thin-film of a semi-transparent layer
/// results in inter-reflections and due to thin-film interference, certain
/// wavelengths get absorbed or amplified. Iridescence can be seen on soap
/// bubbles, oil films, or on the wings of many insects. With this extension,
/// thickness and index of refraction (IOR) of the thin-film can be specified,
/// enabling iridescent materials.
class KHRMaterialIridescence {
  /// The iridescence intensity factor.
  double iridescenceFactor;

  /// The iridescence intensity texture.
  TextureInfo? iridescenceTexture;

  /// The index of refraction of the dielectric thin-film layer.
  double iridescenceIor;

  /// The minimum thickness of the thin-film layer given in nanometers.
  double iridescenceThicknessMinimum;

  /// The maximum thickness of the thin-film layer given in nanometers.
  double iridescenceThicknessMaximum;

  /// The thickness texture of the thin-film layer.
  TextureInfo? iridescenceThicknessTexture;

  KHRMaterialIridescence({
    double? iridescenceFactor,
    this.iridescenceTexture,
    double? iridescenceIor,
    double? iridescenceThicknessMinimum,
    double? iridescenceThicknessMaximum,
    this.iridescenceThicknessTexture,
  }) : iridescenceFactor = iridescenceFactor ?? 0.0,
       iridescenceIor = iridescenceIor ?? 1.3,
       iridescenceThicknessMinimum = iridescenceThicknessMinimum ?? 100.0,
       iridescenceThicknessMaximum = iridescenceThicknessMaximum ?? 400.0;
}
