import 'gltf.dart';
import 'accessor.dart';

/// A view into a buffer generally representing a subset of the buffer.
class BufferView extends GLTFBase {
  /// The index of the buffer.
  int buffer;

  /// The offset into the buffer in bytes.
  int offset;

  /// The length of the bufferView in bytes.
  int length;

  /// The stride, in bytes, between vertex attributes.
  ///
  /// When this is not defined, data is tightly packed. When two or more
  /// accessors use the same [BufferView], this field MUST be defined.
  int? stride;

  /// The hint representing the intended GPU buffer type to use with this
  /// buffer view.
  BufferViewTarget? target;

  /// The user-defined name of this object. This is not necessarily unique,
  /// e.g., an [Accessor] and a buffer could have the same name, or two
  /// accessors could even have the same name.
  String? name;

  BufferView({
    required this.buffer,
    this.offset = 0,
    required this.length,
    this.stride,
    this.target,
    this.name,
    super.extensions,
    super.extras,
  });
}

/// The hint representing the intended GPU buffer type to use with this buffer view.
enum BufferViewTarget { arrayBuffer, elementArrayBuffer }
