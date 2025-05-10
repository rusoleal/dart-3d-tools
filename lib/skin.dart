import 'gltf.dart';

class Skin extends GLTFBase {
  int? inverseBindMatrices;
  int? skeleton;
  List<int> joints;
  String? name;

  Skin({
    this.inverseBindMatrices,
    this.skeleton,
    required this.joints,
    this.name,
    super.extensions,
    super.extras,
  });
}
