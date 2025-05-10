

import 'gltf.dart';

class Mesh extends GLTFBase {
  List<Primitive> primitives;
  List<double>? weights;
  String? name;

  Mesh({
    required this.primitives,
    this.weights,
    this.name,
    super.extensions,
    super.extras
  });
}

class Primitive extends GLTFBase {
  Map<String,int> attributes;
  int? indices;
  int? material;
  PrimitiveMode mode;
  List<Object>? targets;

  Primitive({
    required this.attributes,
    this.indices,
    this.material,
    this.mode=PrimitiveMode.triangles,
    this.targets,
    super.extensions,
    super.extras
  });

  static Primitive fromGLTF(Map<String,dynamic> data) {
    Map<String,int> attributes = _attributesFromGLTF(data['attributes']);
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

  static Map<String,int> _attributesFromGLTF(Map<String,dynamic> data) {
    Map<String,int> toReturn = {};
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

enum PrimitiveMode {
  points,
  lines,
  lineLoop,
  lineStrip,
  triangles,
  triangleStrip,
  triangleFan
}