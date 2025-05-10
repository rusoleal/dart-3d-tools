import 'package:vector_math/vector_math.dart';
import 'gltf.dart';

class Node extends GLTFBase {
  int? camera;
  List<int>? children;
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
    this.children,
    this.skin,
    Matrix4? matrix,
    this.mesh,
    Quaternion? rotation,
    Vector3? scale,
    Vector3? translation,
    List<double>? weights,
    this.name,
    super.extensions,
    super.extras,
  }) : matrix = matrix ?? Matrix4.identity(),
       rotation = rotation ?? Quaternion.identity(),
       scale = scale ?? Vector3.all(1.0),
       translation = translation ?? Vector3.zero(),
       weights = weights ?? [];
}
