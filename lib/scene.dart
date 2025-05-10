
import 'gltf.dart';

class Scene extends GLTFBase {
  List<int>? nodes;
  String? name;

  Scene({
    this.nodes,
    this.name,
    super.extensions,
    super.extras
  });
}
