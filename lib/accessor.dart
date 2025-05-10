
import 'gltf.dart';

/// The datatype of the accessor’s components.
enum ComponentType {
  byte,
  unsignedByte,
  short,
  unsignedShort,
  unsignedInt,
  float
}

/// Specifies if the accessor’s elements are scalars, vectors, or matrices.
enum AccessorType {
  scalar,
  vec2,
  vec3,
  vec4,
  mat2,
  mat3,
  mat4
}

/// A typed view into a buffer view that contains raw binary data.
class Accessor extends GLTFBase{
  int? bufferView;
  int byteOffset;
  ComponentType componentType;
  bool normalized;
  int count;
  AccessorType type;
  List<num>? min;
  List<num>? max;
  // sparse ???
  String? name;
  // extensions
  // extras

  Accessor({
    this.bufferView,
    this.byteOffset=0,
    required this.componentType,
    this.normalized=false,
    required this.count,
    required this.type,
    this.min,
    this.max,
    this.name,
    super.extensions,
    super.extras
  });
}
