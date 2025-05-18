import 'package:vector_math/vector_math.dart';
import 'gltf.dart';
import 'camera.dart';
import 'scene.dart';
import 'animation.dart';
import 'mesh.dart';

/// A node in the node hierarchy.
///
/// When the node contains skin, all mesh.primitives MUST contain JOINTS_0 and
/// WEIGHTS_0 attributes. A node MAY have either a matrix or any combination of
/// translation/rotation/scale (TRS) properties. TRS properties are converted
/// to matrices and postmultiplied in the T * R * S order to compose the
/// transformation matrix; first the scale is applied to the vertices, then the
/// rotation, and then the translation. If none are provided, the transform is
/// the identity.
///
/// When a node is targeted for animation (referenced by an
/// [AnimationChannelTarget]), matrix MUST NOT be present.
class Node extends GLTFBase {
  /// The index of the [Camera] referenced by this node.
  int? camera;

  /// The indices of this node’s children.
  List<int>? children;

  /// The index of the skin referenced by this node. When a skin is referenced
  /// by a node within a [Scene], all joints used by the skin MUST belong to the
  /// same scene. When defined, [mesh] MUST also be defined.
  int? skin;

  /// A floating-point 4x4 transformation matrix stored in column-major order.
  Matrix4 matrix;

  /// The index of the [Mesh] in this node.
  int? mesh;

  /// The node’s unit quaternion rotation in the order (x, y, z, w), where w is
  /// the scalar.
  Quaternion rotation;

  /// The node’s non-uniform scale, given as the scaling factors along the x, y,
  /// and z axes.
  Vector3 scale;

  /// The node’s translation along the x, y, and z axes.
  Vector3 translation;

  /// The weights of the instantiated morph target. The number of array elements
  /// MUST match the number of morph targets of the referenced mesh. When
  /// defined, mesh MUST also be defined.
  List<double> weights;

  /// The user-defined name of this object. This is not necessarily unique,
  /// e.g., an accessor and a buffer could have the same name, or two accessors
  /// could even have the same name.
  String? name;

  /// KHR_lights_punctual extension.
  int? khrLightPunctual;

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
    this.khrLightPunctual,
    super.extensions,
    super.extras,
  }) : matrix = matrix ?? Matrix4.identity(),
       rotation = rotation ?? Quaternion.identity(),
       scale = scale ?? Vector3.all(1.0),
       translation = translation ?? Vector3.zero(),
       weights = weights ?? [];
}
