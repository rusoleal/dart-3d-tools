import 'gltf.dart';
import 'buffer_view.dart';
import 'mesh.dart';

/// The datatype of the accessor’s components.
enum ComponentType {
  byte,
  unsignedByte,
  short,
  unsignedShort,
  unsignedInt,
  float,
}

/// Specifies if the accessor’s elements are scalars, vectors, or matrices.
enum AccessorType { scalar, vec2, vec3, vec4, mat2, mat3, mat4 }

/// A typed view into a buffer view that contains raw binary data.
class Accessor extends GLTFBase {
  /// The index of the [BufferView]. When undefined, the accessor MUST be
  /// initialized with zeros; [sparse] property or extensions MAY override zeros
  /// with actual values.
  int? bufferView;

  /// The offset relative to the start of the [BufferView] in bytes.
  ///
  /// This MUST be a multiple of the size of the component datatype. This
  /// property MUST NOT be defined when [bufferView] is undefined.
  int byteOffset;

  /// The datatype of the accessor’s components.
  ///
  /// [ComponentType.unsignedInt] type MUST NOT be used for any accessor that is
  /// not referenced by [Primitive.indices].
  ComponentType componentType;

  /// Specifies whether integer data values are normalized (true) to [0, 1]
  /// (for unsigned types) or to [-1, 1] (for signed types) when they are
  /// accessed.
  ///
  /// This property MUST NOT be set to true for accessors with
  /// [ComponentType.float] or [ComponentType.unsignedInt] component type.
  bool normalized;

  /// The number of elements referenced by this accessor, not to be confused
  /// with the number of bytes or number of components.
  int count;

  /// Specifies if the accessor’s elements are scalars, vectors, or matrices.
  AccessorType type;

  /// Maximum value of each component in this accessor. Array elements MUST be
  /// treated as having the same data type as accessor’s [componentType].
  /// Both min and max arrays have the same length. The length is determined by
  /// the value of the [type] property; it can be 1, 2, 3, 4, 9, or 16.
  ///
  /// [normalized] property has no effect on array values: they always correspond
  /// to the actual values stored in the buffer. When the accessor is sparse,
  /// this property MUST contain maximum values of accessor data with sparse
  /// substitution applied.
  List<num>? max;

  /// Minimum value of each component in this accessor. Array elements MUST be
  /// treated as having the same data type as accessor’s [componentType].
  /// Both min and max arrays have the same length. The length is determined by
  /// the value of the [type] property; it can be 1, 2, 3, 4, 9, or 16.
  ///
  /// [normalized] property has no effect on array values: they always correspond
  /// to the actual values stored in the buffer. When the accessor is sparse,
  /// this property MUST contain minimum values of accessor data with sparse
  /// substitution applied.
  List<num>? min;

  // sparse ???

  /// The user-defined name of this object. This is not necessarily unique,
  /// e.g., an accessor and a buffer could have the same name, or two accessors
  /// could even have the same name.
  String? name;

  // extensions
  // extras

  Accessor({
    this.bufferView,
    this.byteOffset = 0,
    required this.componentType,
    this.normalized = false,
    required this.count,
    required this.type,
    this.min,
    this.max,
    this.name,
    super.extensions,
    super.extras,
  });
}
