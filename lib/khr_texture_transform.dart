import 'package:vector_math/vector_math.dart';

/// KHR_texture_transform
class KHRTextureTransform {
  /// The offset of the UV coordinate origin as a factor of the texture
  /// dimensions.
  Vector2 offset;

  /// Rotate the UVs by this many radians counter-clockwise around the origin.
  /// This is equivalent to a similar rotation of the image clockwise.
  double rotation;

  /// The scale factor applied to the components of the UV coordinates.
  Vector2 scale;

  /// Overrides the textureInfo texCoord value if supplied, and if this
  /// extension is supported.
  int? texCoord;

  KHRTextureTransform({
    Vector2? offset,
    double? rotation,
    Vector2? scale,
    this.texCoord,
  }) : offset = offset ?? Vector2.zero(),
       scale = scale ?? Vector2.all(1.0),
       rotation = rotation ?? 0.0;
}
