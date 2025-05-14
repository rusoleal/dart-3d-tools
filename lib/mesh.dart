import 'gltf.dart';
import 'node.dart';
import 'material.dart';
import 'accessor.dart';

/// A set of primitives to be rendered. Its global transform is defined by a
/// [Node] that references it.
class Mesh extends GLTFBase {

  /// An array of primitives, each defining geometry to be rendered.
  List<Primitive> primitives;

  /// Array of weights to be applied to the morph targets. The number of array
  /// elements MUST match the number of morph targets.
  List<double>? weights;

  /// The user-defined name of this object. This is not necessarily unique,
  /// e.g., an accessor and a buffer could have the same name, or two accessors
  /// could even have the same name.
  String? name;

  Mesh({
    required this.primitives,
    this.weights,
    this.name,
    super.extensions,
    super.extras,
  });
}

/// Geometry to be rendered with the given [Material].
class Primitive extends GLTFBase {

  /// A plain JSON object, where each key corresponds to a mesh attribute
  /// semantic and each value is the index of the accessor containing
  /// attribute’s data.
  Map<String, int> attributes;

  /// The index of the [Accessor] that contains the vertex indices. When this is
  /// undefined, the primitive defines non-indexed geometry. When defined, the
  /// [Accessor] MUST have SCALAR type and an unsigned integer component type.
  int? indices;

  /// The index of the [Material] to apply to this primitive when rendering.
  int? material;

  /// The topology type of primitives to render.
  PrimitiveMode mode;

  /// An array of morph targets.
  List<Object>? targets;

  Primitive({
    required this.attributes,
    this.indices,
    this.material,
    this.mode = PrimitiveMode.triangles,
    this.targets,
    super.extensions,
    super.extras,
  });

  static Primitive fromGLTF(Map<String, dynamic> data) {
    Map<String, int> attributes = _attributesFromGLTF(data['attributes']);
    int? indices = data['indices'];
    int? material = data['material'];
    int mode = data['mode'] ?? 4;
    return Primitive(
      attributes: attributes,
      indices: indices,
      material: material,
      mode: _modeFromGLTF(mode) ?? PrimitiveMode.triangles,
    );
  }

  static Map<String, int> _attributesFromGLTF(Map<String, dynamic> data) {
    Map<String, int> toReturn = {};
    for (var entry in data.entries) {
      toReturn[entry.key] = entry.value;
    }
    return toReturn;
  }

  static PrimitiveMode? _modeFromGLTF(int? mode) {
    if (mode == null) {
      return null;
    }
    switch (mode) {
      case 0:
        return PrimitiveMode.points;
      case 1:
        return PrimitiveMode.lines;
      case 2:
        return PrimitiveMode.lineLoop;
      case 3:
        return PrimitiveMode.lineStrip;
      case 4:
        return PrimitiveMode.triangles;
      case 5:
        return PrimitiveMode.triangleStrip;
      case 6:
        return PrimitiveMode.triangleFan;
      default:
        throw Exception("Unknown primitive mode: $mode");
    }
  }
}

/// The topology type of primitives to render.
enum PrimitiveMode {
  points,
  lines,
  lineLoop,
  lineStrip,
  triangles,
  triangleStrip,
  triangleFan,
}
