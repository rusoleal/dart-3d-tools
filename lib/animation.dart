import 'utils.dart';
import 'gltf.dart';

class Animation extends GLTFBase {
  List<AnimationChannel> channels;
  List<AnimationSampler> samplers;
  String? name;

  Animation({
    required this.channels,
    required this.samplers,
    this.name,
    super.extensions,
    super.extras,
  });
}

class AnimationChannel extends GLTFBase {
  int sampler;
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

class AnimationChannelTarget extends GLTFBase {
  int? node;
  String path;

  AnimationChannelTarget({
    this.node,
    required this.path,
    super.extensions,
    super.extras,
  });

  static AnimationChannelTarget fromGLTF(Map<String, dynamic> data) {
    int? node = data['node'];
    String path = data['path'];
    return AnimationChannelTarget(node: node, path: path);
  }
}

class AnimationSampler extends GLTFBase {
  int input;
  AnimationInterpolation interpolation;
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

enum AnimationInterpolation { linear, step, cubicSpline }
