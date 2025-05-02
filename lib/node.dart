
import 'package:vector_math/vector_math.dart';

class Node {
  int? camera;
  List<int> children;
  int? skin;
  Matrix4 matrix;
  int? mesh;
  Quaternion rotation;
  Vector3 scale;
  Vector3 translation;
  List<double> weights;
  String? name;

  Node({
    this.camera,
    List<int>? children,
    this.skin,
    Matrix4? matrix,
    this.mesh,
    Quaternion? rotation,
    Vector3? scale,
    Vector3? translation,
    List<double>? weights,
    this.name,
  }):
      this.children = children ?? [],
      this.matrix = matrix ?? Matrix4.identity(),
      this.rotation = rotation ?? Quaternion.identity(),
      this.scale = scale ?? Vector3.all(1.0),
      this.translation = translation ?? Vector3.zero(),
      this.weights = weights ?? []
  ;

}
