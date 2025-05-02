
/// A view into a buffer generally representing a subset of the buffer.
class BufferView {
  int buffer;
  int offset;
  int length;
  int? stride;
  int? target;
  String? name;

  BufferView({required this.buffer, this.offset=0, required this.length, this.stride, this.target, this.name});

}