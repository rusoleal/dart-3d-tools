import 'gltf.dart';

abstract class Camera extends GLTFBase {
  String? name;

  Camera({this.name, super.extensions, super.extras});
}

class OrthographicCamera extends Camera {
  double xMag;
  double yMag;
  double zFar;
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

class PerspectiveCamera extends Camera {
  double? aspectRatio;
  double yFov;
  double? zFar;
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
