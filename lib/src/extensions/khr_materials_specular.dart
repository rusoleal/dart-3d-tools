import 'package:vector_math/vector_math.dart';
import '../material.dart';

class KHRMaterialSpecular {
  /// The strength of the specular reflection.
  double specularFactor;

  /// A texture that defines the strength of the specular reflection, stored in
  /// the alpha (A) channel. This will be multiplied by specularFactor.
  TextureInfo? specularTexture;

  /// The F0 color of the specular reflection (linear RGB).
  Vector3 specularColorFactor;

  /// A texture that defines the F0 color of the specular reflection, stored in
  /// the RGB channels and encoded in sRGB. This texture will be multiplied by
  /// specularColorFactor.
  TextureInfo? specularColorTexture;

  KHRMaterialSpecular({
    this.specularFactor = 1.0,
    this.specularTexture,
    Vector3? khrMaterialsSpecularSpecularColorFactor,
    this.specularColorTexture,
  }) : specularColorFactor =
           khrMaterialsSpecularSpecularColorFactor ?? Vector3.all(1.0);
}
