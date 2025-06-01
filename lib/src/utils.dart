import 'package:vector_math/vector_math.dart';
import 'extensions/khr_lights_punctual.dart';
import 'sampler.dart';
import 'animation.dart';
import 'buffer_view.dart';
import 'material.dart';

List<String> stringListFromGLTF(dynamic node) {
  if (node is! List) {
    return [];
  }

  List<String> toReturn = [];
  for (var element in node) {
    if (element is String) {
      toReturn.add(element);
    }
  }

  return toReturn;
}

Vector2? vec2FromGLTF(List<dynamic>? vec) {
  if (vec == null) {
    return null;
  }
  if (vec.length != 2) {
    throw Exception('Vector2 must have 2 elements');
  }
  return Vector2(vec[0].toDouble(), vec[1].toDouble());
}

Vector3? vec3FromGLTF(List<dynamic>? vec) {
  if (vec == null) {
    return null;
  }
  if (vec.length != 3) {
    throw Exception('Vector3 must have 3 elements');
  }
  return Vector3(vec[0].toDouble(), vec[1].toDouble(), vec[2].toDouble());
}

Vector4? vec4FromGLTF(List<dynamic>? vec) {
  if (vec == null) {
    return null;
  }
  if (vec.length != 4) {
    throw Exception('Vector4 must have 4 elements');
  }
  return Vector4(
    vec[0].toDouble(),
    vec[1].toDouble(),
    vec[2].toDouble(),
    vec[3].toDouble(),
  );
}

Quaternion? quatFromGLTF(List<dynamic>? quat) {
  if (quat == null) {
    return null;
  }
  if (quat.length != 4) {
    throw Exception('Quaternion must have 4 elements');
  }
  return Quaternion(
    quat[0].toDouble(),
    quat[1].toDouble(),
    quat[2].toDouble(),
    quat[3].toDouble(),
  );
}

Matrix4? mat4FromGLTF(List<dynamic>? mat) {
  if (mat == null) {
    return null;
  }
  if (mat.length != 16) {
    throw Exception('Matrix4 must have 16 elements');
  }
  List<double> data = doubleListFromGLTF(mat)!;
  return Matrix4.fromList(data);
}

List<double>? doubleListFromGLTF(List<dynamic>? list) {
  if (list == null) {
    return null;
  }
  return list.map((e) => (e as num).toDouble()).toList();
}

List<int>? intListFromGLTF(List<dynamic>? list) {
  if (list == null) {
    return null;
  }
  return list.map((e) => e as int).toList();
}

WrapMode wrapModefromGLTF(int mode) {
  switch (mode) {
    case 10497:
      return WrapMode.repeat;
    case 33648:
      return WrapMode.mirroredRepeat;
    case 33071:
      return WrapMode.clampToEdge;
    default:
      throw Exception('Unsupported wrap mode: $mode');
  }
}

MagFilterMode? magFilterModeFromGLTF(int? mode) {
  if (mode == null) {
    return null;
  }
  switch (mode) {
    case 9728:
      return MagFilterMode.nearest;
    case 9729:
      return MagFilterMode.linear;
    default:
      throw Exception('Unsupported mag filter mode: $mode');
  }
}

MinFilterMode? minFilterModeFromGLTF(int? mode) {
  if (mode == null) {
    return null;
  }
  switch (mode) {
    case 9728:
      return MinFilterMode.nearest;
    case 9729:
      return MinFilterMode.linear;
    case 9984:
      return MinFilterMode.nearestMipmapNearest;
    case 9985:
      return MinFilterMode.linearMipmapNearest;
    case 9986:
      return MinFilterMode.nearestMipmapLinear;
    case 9987:
      return MinFilterMode.linearMipmapLinear;
    default:
      throw Exception('Unsupported min filter mode: $mode');
  }
}

AlphaMode? alphaModeFromGLTF(String? mode) {
  if (mode == null) {
    return null;
  }
  switch (mode) {
    case 'OPAQUE':
      return AlphaMode.opaque;
    case 'MASK':
      return AlphaMode.mask;
    case 'BLEND':
      return AlphaMode.blend;
    default:
      throw Exception('Unsupported alpha mode: $mode');
  }
}

AnimationInterpolation? animationInterpolationFromGLTF(String? mode) {
  if (mode == null) {
    return null;
  }
  switch (mode) {
    case 'LINEAR':
      return AnimationInterpolation.linear;
    case 'STEP':
      return AnimationInterpolation.step;
    case 'CUBICSPLINE':
      return AnimationInterpolation.cubicSpline;
    default:
      throw Exception('Unsupported animation interpolation: $mode');
  }
}

BufferViewTarget? bufferViewTargetFromGLTF(int? mode) {
  if (mode == null) {
    return null;
  }
  switch (mode) {
    case 34962:
      return BufferViewTarget.arrayBuffer;
    case 34963:
      return BufferViewTarget.elementArrayBuffer;
    default:
      throw Exception('Unsupported buffer view target: $mode');
  }
}

KHRLightPunctualType khrLightPunctualTypeFromString(String name) {
  switch (name) {
    case 'directional':
      return KHRLightPunctualType.directional;
    case 'point':
      return KHRLightPunctualType.point;
    case 'spot':
      return KHRLightPunctualType.spot;
    default:
      throw Exception('Unsupported khr light punctual type: $name');
  }
}
