import 'gltf.dart';

/// A view into a buffer generally representing a subset of the buffer.
class BufferView extends GLTFBase {
  int buffer;
  int offset;
  int length;
  int? stride;
  BufferViewTarget? target;
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

enum BufferViewTarget { arrayBuffer, elementArrayBuffer }
