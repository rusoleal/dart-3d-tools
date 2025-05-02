
abstract class Camera {
  String? name;

  Camera({this.name});

}

class OrthographicCamera extends Camera {
  double xmag;
  double ymag;
  double zfar;
  double znear;

  OrthographicCamera({required this.xmag, required this.ymag, required this.zfar, required this.znear, String? name}): super(name: name);
}

class PerspectiveCamera extends Camera {
  double? aspectRatio;
  double yfov;
  double? zfar;
  double znear;

  PerspectiveCamera({this.aspectRatio, required this.yfov, this.zfar, required this.znear, String? name}): super(name: name);

}