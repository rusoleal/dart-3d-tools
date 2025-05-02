
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'accessor.dart';
import 'buffer_view.dart';
import 'camera.dart';
import 'node.dart';

class Project {
  List<Uint8List> buffers;
  List<BufferView> bufferViews; // typed_data
  List<Accessor> accessors;
  List<Image> images;
  List<Texture> textures;
  List<Scene> scenes;
  List<Node> nodes;
  List<Sampler> samplers;
  List<Mesh> meshes;
  List<Material> materials;
  List<Animation> animations;
  List<Camera> cameras;
  List<Skin> skins;

  Project({List<Uint8List>? buffers, List<BufferView>? bufferViews, List<Image>? images, List<Texture>? textures, List<Accessor>? accessors, List<Scene>? scenes, List<Node>? nodes, List<Sampler>? samplers, List<Mesh>? meshes, List<Material>? materials, List<Animation>? animations, List<Camera>? cameras, List<Skin>? skins}):
      this.buffers = buffers ?? [],
      this.bufferViews = bufferViews ?? [],
      this.images = images ?? [],
      this.textures = textures ?? [],
      this.accessors = accessors ?? [],
      this.scenes = scenes ?? [],
      this.nodes = nodes ?? [],
      this.samplers = samplers ?? [],
      this.meshes = meshes ?? [],
      this.materials = materials ?? [],
      this.animations = animations ?? [],
      this.cameras = cameras ?? [],
      this.skins = skins ?? []
  ;

  static Future<Project> loadGLTF(String data, Future<Uint8List> Function(String uri) onLoadBuffer) async {
    Map<String,dynamic> json = jsonDecode(data);
    String version = json['asset']['version'];
    List<String> parts = version.split('.');
    int major = int.parse(parts[0]);
    int minor = int.parse(parts[1]);
    if (major != 2) {
      throw Exception('Unsupported GLTF version: $major.$minor');
    }

    // Buffers
    List<Uint8List> buffers = [];
    List<dynamic> buffersDef = json['buffers'];
    List<Future<Uint8List>> bufferLoaders = [];
    for (var buffer in buffersDef) {
      int byteLength = buffer['byteLength'];
      String uri = buffer['uri'];
      //print(uri);
      bufferLoaders.add(onLoadBuffer(uri));
    }
    buffers = await Future.wait(bufferLoaders);

    // BufferViews
    List<BufferView> bufferViews = [];
    List<dynamic> bufferViewsDef = json['bufferViews'];
    for (var bufferView in bufferViewsDef) {
      int buffer = bufferView['buffer'];
      int byteOffset = bufferView['byteOffset']??0;
      int byteLength = bufferView['byteLength'];
      int? byteStride = bufferView['byteStride'];
      int? target = bufferView['target'];
      String? name = bufferView['name'];
      bufferViews.add(BufferView(
        buffer: buffer,
        offset: byteOffset,
        length: byteLength,
        stride: byteStride,
        target: target,
        name: name,
      ));
    }

    // Accessors
    List<dynamic> accessorsDef = json['accessors'];
    List<Accessor> accessors = [];
    for (var accessor in accessorsDef) {
      int? bufferView = accessor['bufferView'];
      int byteOffset = accessor['byteOffset']??0;
      int componentType = accessor['componentType'];
      ComponentType ct;
      switch (componentType) {
        case 5120:
          ct = ComponentType.byte;
          break;
        case 5121:
          ct = ComponentType.unsignedByte;
          break;
        case 5122:
          ct = ComponentType.short;
          break;
        case 5123:
          ct = ComponentType.unsignedShort;
          break;
        case 5125:
          ct = ComponentType.unsignedInt;
          break;
        case 5126:
          ct = ComponentType.float;
          break;
        default:
          throw Exception('Unsupported component type: $componentType');
      }
      bool normalized = accessor['normalized']??false;
      int count = accessor['count'];
      String type = accessor['type'];
      AccessorType t;
      switch (type) {
        case 'SCALAR':
          t = AccessorType.scalar;
          break;
        case 'VEC2':
          t = AccessorType.vec2;
          break;
        case 'VEC3':
          t = AccessorType.vec3;
          break;
        case 'VEC4':
          t = AccessorType.vec4;
          break;
        case 'MAT2':
          t = AccessorType.mat2;
          break;
        case 'MAT3':
          t = AccessorType.mat3;
          break;
        case 'MAT4':
          t = AccessorType.mat4;
          break;
        default:
          throw Exception('Unsupported accessor type: $type');
      }
      String? name = accessor['name'];

      accessors.add(Accessor(
        bufferView: bufferView,
        byteOffset: byteOffset,
        componentType: ct,
        normalized: normalized,
        count: count,
        type: t,
        name: name,
      ));
    }

    return Project(
      buffers: buffers,
      bufferViews: bufferViews,
      accessors: accessors,
    );
  }

  static Future<Project> loadGLB(Uint8List data) {
    throw UnimplementedError();
  }

}

class Texture {
}

class Scene {
}

class Sampler {
}

class Mesh {
}

class Material {
}

class Animation {
}

class Skin {
}
