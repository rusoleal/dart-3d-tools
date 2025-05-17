import 'dart:math';
import 'gltf.dart';
import 'node.dart';
import 'scene.dart';

/// A camera’s projection. A [Node] MAY reference a camera to apply a transform
/// to place the camera in the [Scene].
abstract class Camera extends GLTFBase {
  /// The user-defined name of this object. This is not necessarily unique,
  /// e.g., an accessor and a buffer could have the same name, or two accessors
  /// could even have the same name.
  String? name;

  Camera({this.name, super.extensions, super.extras});
}

/// An orthographic camera containing properties to create an orthographic
/// projection matrix.
class OrthographicCamera extends Camera {
  /// The floating-point horizontal magnification of the view. This value
  /// MUST NOT be equal to zero. This value SHOULD NOT be negative.
  double xMag;

  /// The floating-point vertical magnification of the view. This value MUST NOT
  /// be equal to zero. This value SHOULD NOT be negative.
  double yMag;

  /// The floating-point distance to the far clipping plane. This value MUST NOT
  /// be equal to zero. zfar MUST be greater than [zNear].
  double zFar;

  /// The floating-point distance to the near clipping plane.
  double zNear;

  OrthographicCamera({
    required this.xMag,
    required this.yMag,
    required this.zFar,
    required this.zNear,
    super.name,
    super.extensions,
    super.extras,
  });
}

/// A perspective camera containing properties to create a perspective
/// projection matrix.
class PerspectiveCamera extends Camera {
  /// The floating-point aspect ratio of the field of view. When undefined, the
  /// aspect ratio of the rendering viewport MUST be used.
  double? aspectRatio;

  /// The floating-point vertical field of view in radians. This value SHOULD be
  /// less than [pi].
  double yFov;

  /// The floating-point distance to the far clipping plane. When defined, zfar
  /// MUST be greater than [zNear]. If zfar is undefined, client implementations
  /// SHOULD use infinite projection matrix.
  double? zFar;

  /// The floating-point distance to the near clipping plane.
  double zNear;

  PerspectiveCamera({
    this.aspectRatio,
    required this.yFov,
    this.zFar,
    required this.zNear,
    super.name,
    super.extensions,
    super.extras,
  });
}
