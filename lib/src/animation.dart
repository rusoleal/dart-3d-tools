import 'khr_animation_pointer.dart';
import 'utils.dart';
import 'gltf.dart';
import 'sampler.dart';
import 'node.dart';
import 'accessor.dart';

/// A keyframe animation.
class Animation extends GLTFBase {
  /// An array of [AnimationChannel]. An [AnimationChannel] combines an
  /// animation sampler with a target property being animated. Different
  /// channels of the same animation MUST NOT have the same targets.
  List<AnimationChannel> channels;

  /// An array of [AnimationSampler]. An [AnimationSampler] combines timestamps
  /// with a sequence of output values and defines an interpolation algorithm.
  List<AnimationSampler> samplers;

  /// The user-defined name of this object. This is not necessarily unique,
  /// e.g., an accessor and a buffer could have the same name, or two accessors
  /// could even have the same name.
  String? name;

  Animation({
    required this.channels,
    required this.samplers,
    this.name,
    super.extensions,
    super.extras,
  });
}

/// An animation channel combines an animation sampler with a target property
/// being animated.
class AnimationChannel extends GLTFBase {
  /// The index of a [Sampler] in this animation used to compute the value for
  /// the target, e.g., a [Node]’s translation, rotation, or scale (TRS).
  int sampler;

  /// The descriptor of the animated property.
  AnimationChannelTarget target;

  AnimationChannel({
    required this.sampler,
    required this.target,
    super.extensions,
    super.extras,
  });

  static AnimationChannel fromGLTF(Map<String, dynamic> data) {
    int sampler = data['sampler'];
    AnimationChannelTarget target = AnimationChannelTarget.fromGLTF(
      data['target'],
    );
    return AnimationChannel(sampler: sampler, target: target);
  }
}

/// The descriptor of the animated property.
class AnimationChannelTarget extends GLTFBase {
  /// The index of the [Node] to animate. When undefined, the animated object
  /// MAY be defined by an extension.
  int? node;

  /// The name of the node’s TRS property to animate, or the "weights" of the
  /// Morph Targets it instantiates. For the "translation" property, the values
  /// that are provided by the sampler are the translation along the X, Y, and
  /// Z axes. For the "rotation" property, the values are a quaternion in the
  /// order (x, y, z, w), where w is the scalar. For the "scale" property, the
  /// values are the scaling factors along the X, Y, and Z axes.
  String path;

  /// KHR_animation_pointer
  KHRAnimationPointer? khrAnimationPointer;

  AnimationChannelTarget({
    this.node,
    required this.path,
    super.extensions,
    this.khrAnimationPointer,
    super.extras,
  });

  static AnimationChannelTarget fromGLTF(Map<String, dynamic> data) {
    int? node = data['node'];
    String path = data['path'];

    KHRAnimationPointer? khrAnimationPointer;

    var extensions = data['extensions'];
    if (extensions != null) {
      var khrAnimationPointerExt = extensions['KHR_animation_pointer'];
      if (khrAnimationPointerExt != null) {
        String pointer = khrAnimationPointerExt['pointer'];
        khrAnimationPointer = KHRAnimationPointer(pointer: pointer);
      }
    }
    return AnimationChannelTarget(
      node: node,
      path: path,
      khrAnimationPointer: khrAnimationPointer,
    );
  }
}

/// An animation sampler combines timestamps with a sequence of output values
/// and defines an interpolation algorithm.
class AnimationSampler extends GLTFBase {
  /// The index of an [Accessor] containing keyframe timestamps.
  ///
  /// The accessor MUST be of scalar type with floating-point components. The
  /// values represent time in seconds with time[0] >= 0.0, and strictly
  /// increasing values, i.e., time[n + 1] > time[n].
  int input;

  /// Interpolation algorithm.
  AnimationInterpolation interpolation;

  /// The index of an [Accessor], containing keyframe output values.
  int output;

  AnimationSampler({
    required this.input,
    this.interpolation = AnimationInterpolation.linear,
    required this.output,
    super.extensions,
    super.extras,
  });

  static AnimationSampler fromGLTF(Map<String, dynamic> data) {
    int input = data['input'];
    String? interpolation = data['interpolation'];
    int output = data['output'];
    return AnimationSampler(
      input: input,
      interpolation:
          animationInterpolationFromGLTF(interpolation) ??
          AnimationInterpolation.linear,
      output: output,
    );
  }
}

/// Interpolation algorithm.
enum AnimationInterpolation {
  /// The animated values are linearly interpolated between keyframes. When
  /// targeting a rotation, spherical linear interpolation (slerp) SHOULD be
  /// used to interpolate quaternions. The number of output elements MUST equal
  /// the number of input elements.
  linear,

  /// The animated values remain constant to the output of the first keyframe,
  /// until the next keyframe. The number of output elements MUST equal the
  /// number of input elements.
  step,

  /// The animation’s interpolation is computed using a cubic spline with
  /// specified tangents. The number of output elements MUST equal three times
  /// the number of input elements. For each input element, the output stores
  /// three elements, an in-tangent, a spline vertex, and an out-tangent.
  /// There MUST be at least two keyframes when using this interpolation.
  cubicSpline,
}
