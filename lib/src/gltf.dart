import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:gltf_loader/src/extensions/khr_materials_emissive_strength.dart';
import 'package:gltf_loader/src/extensions/khr_materials_iridescence.dart';
import 'package:vector_math/vector_math.dart';

import 'animation.dart';
import 'buffer.dart';
import 'extensions/ext_texture_webp.dart';
import 'extensions/khr_materials_anisotropy.dart';
import 'extensions/khr_materials_dispersion.dart';
import 'extensions/khr_materials_ior.dart';
import 'extensions/khr_materials_unlit.dart';
import 'image.dart';
import 'extensions/khr_lights_punctual.dart';
import 'extensions/khr_materials_sheen.dart';
import 'extensions/khr_materials_specular.dart';
import 'extensions/khr_materials_transmission.dart';
import 'extensions/khr_materials_volume.dart';
import 'info.dart';
import 'material.dart';
import 'mesh.dart';
import 'sampler.dart';
import 'texture.dart';
import 'accessor.dart';
import 'buffer_view.dart';
import 'camera.dart';
import 'node.dart';
import 'scene.dart';
import 'utils.dart';
import 'skin.dart';

/// Base class for all gltf elements
class GLTFBase {
  /// JSON object with extension-specific objects.
  dynamic extensions;

  /// Application-specific data.
  dynamic extras;

  GLTFBase({this.extensions, this.extras});
}

class GLTF extends GLTFBase {
  static const Set<String> implementedExtensions = {
    'KHR_animation_pointer',
    'KHR_lights_punctual',
    'KHR_materials_anisotropy',
    'KHR_materials_clearcoat',
    'KHR_materials_dispersion',
    'KHR_materials_emissive_strength',
    'KHR_materials_ior',
    'KHR_materials_iridescence',
    'KHR_materials_sheen',
    'KHR_materials_specular',
    'KHR_materials_transmission',
    'KHR_materials_unlit',
    'KHR_materials_volume',
    'KHR_texture_transform',
    'EXT_texture_webp',
  };

  final Future<Uint8List> Function(String? uri) _onLoadData;

  Info info;
  List<Buffer> buffers;
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
  List<KHRLightPunctual> khrLightsPunctual;

  Set<void Function()> _onRefresh = {};

  // runtime data
  late List<ui.Image?> _runtimeImages;
  late List<Uint8List?> _runtimeBuffers;

  GLTF({
    required this.info,
    required Future<Uint8List> Function(String? uri) onLoadData,
    List<Buffer>? buffers,
    List<BufferView>? bufferViews,
    List<Image>? images,
    List<Texture>? textures,
    List<Accessor>? accessors,
    List<Scene>? scenes,
    List<Node>? nodes,
    List<Sampler>? samplers,
    List<Mesh>? meshes,
    List<Material>? materials,
    List<Animation>? animations,
    List<Camera>? cameras,
    List<Skin>? skins,
    List<KHRLightPunctual>? khrLightsPunctual,
    super.extensions,
    super.extras,
  }) : buffers = buffers ?? [],
       bufferViews = bufferViews ?? [],
       images = images ?? [],
       textures = textures ?? [],
       accessors = accessors ?? [],
       scenes = scenes ?? [],
       nodes = nodes ?? [],
       samplers = samplers ?? [],
       meshes = meshes ?? [],
       materials = materials ?? [],
       animations = animations ?? [],
       cameras = cameras ?? [],
       skins = skins ?? [],
       khrLightsPunctual = khrLightsPunctual ?? [],
       _onLoadData = onLoadData {
    _runtimeImages = List.filled(this.images.length, null);
    _runtimeBuffers = List.filled(this.buffers.length, null);
  }

  void addOnRefreshListener(void Function() listener) {
    _onRefresh.add(listener);
  }

  void removeOnRefreshListener(void Function() listener) {
    _onRefresh.remove(listener);
  }

  void _refresh() {
    for (var listener in _onRefresh) {
      listener();
    }
  }

  /// runtime image list. Call [loadImage] to load images.
  List<ui.Image?> get runtimeImages => List.unmodifiable(_runtimeImages);

  /// runtime buffer list. Call [loadBuffer] to load buffers.
  List<Uint8List?> get runtimeBuffers => List.unmodifiable(_runtimeBuffers);

  /// Returns the estimated memory usage of the GLTF loaded assets in bytes.
  ///
  /// Value is calculated based on buffers and images loaded.
  int get estimatedMemoryUsage {
    int toReturn = 0;
    for (var buffer in runtimeBuffers) {
      toReturn += buffer?.lengthInBytes ?? 0;
    }
    for (var image in runtimeImages) {
      if (image != null) {
        toReturn += image.width * image.height * 4;
      }
    }
    return toReturn;
  }

  Future<Uint8List> _loadAsset(String? uri) async {
    print('Loading asset: $uri');
    return await _onLoadData(uri);
  }

  /// clear runtime buffers and textures.
  void clearRuntimeData() {
    for (int a = 0; a < _runtimeBuffers.length; a++) {
      _runtimeBuffers[a] = null;
    }

    for (int a = 0; a < _runtimeImages.length; a++) {
      _runtimeImages[a] = null;
    }
    _refresh();
  }

  /// load data from buffer at [bufferIndex].
  /// This method load a buffer and store it in [runtimeBuffers] at [bufferIndex].
  Future<void> loadBuffer(int bufferIndex, [bool refresh = true]) async {
    // finish if bufferIndex is out of range or buffer is already loaded
    if (bufferIndex < 0 ||
        bufferIndex >= buffers.length ||
        _runtimeBuffers[bufferIndex] != null) {
      return;
    }

    var data = await _loadAsset(buffers[bufferIndex].uri);
    _runtimeBuffers[bufferIndex] = data;
    if (refresh) {
      _refresh();
    }
  }

  /// load runtime image at [imageIndex].
  /// This method load image and store it in [runtimeImages] at [imageIndex].
  Future<void> loadImage(int imageIndex, [bool refresh = true]) async {
    // finish if bufferIndex is out of range or buffer is already loaded
    if (imageIndex < 0 ||
        imageIndex >= images.length ||
        _runtimeImages[imageIndex] != null) {
      return;
    }

    var image = images[imageIndex];

    Uint8List data;
    if (image.uri != null) {
      data = await _loadAsset(image.uri);
    } else {
      var bufferView = bufferViews[image.bufferView!];

      // check if buffer is already loaded
      if (_runtimeBuffers[bufferView.buffer] == null) {
        await loadBuffer(bufferView.buffer);
      }
      var buffer = _runtimeBuffers[bufferView.buffer]!;
      data = buffer.buffer.asUint8List(
        buffer.offsetInBytes + bufferView.offset,
        bufferView.length,
      );
    }

    ui.Codec codec = await ui.instantiateImageCodec(data);
    _runtimeImages[imageIndex] = (await codec.getNextFrame()).image;

    if (refresh) {
      _refresh();
    }
  }

  void _updateImagesToLoadFromTexture(
    List<bool> imagesToLoad,
    Texture texture,
  ) {
    int? imageIndex;
    if (texture.extTextureWebp != null) {
      imageIndex = texture.extTextureWebp!.source;
    } else {
      imageIndex = texture.source;
    }
    if (imageIndex != null && _runtimeImages[imageIndex] == null) {
      imagesToLoad[imageIndex] = true;
    }
  }

  /// load all buffers andd images
  Future<void> loadAll() async {
    List<Future> futures = [];

    for (int a = 0; a < _runtimeBuffers.length; a++) {
      if (runtimeBuffers[a] == null) {
        futures.add(loadBuffer(a, false));
      }
    }

    for (int a = 0; a < _runtimeImages.length; a++) {
      if (_runtimeImages[a] == null) {
        futures.add(loadImage(a, false));
      }
    }

    await Future.wait(futures);
    _refresh();
  }

  /// load assets needed to render scene at [sceneIndex]
  Future<void> loadScene(int sceneIndex) async {
    if (sceneIndex < 0 || sceneIndex >= scenes.length) {
      return;
    }

    List<bool> imagesToLoad = List.filled(images.length, false);
    List<bool> buffersToLoad = List.filled(buffers.length, false);

    Scene scene = scenes[sceneIndex];
    if (scene.nodes != null) {
      for (int nodeIndex in scene.nodes!) {
        Node node = nodes[nodeIndex];
        if (node.mesh != null) {
          Mesh mesh = meshes[node.mesh!];
          for (var primitive in mesh.primitives) {
            if (primitive.material != null) {
              Material material = materials[primitive.material!];

              if (material.emissiveTexture != null) {
                var textureIndex = material.emissiveTexture!.index;
                _updateImagesToLoadFromTexture(
                  imagesToLoad,
                  textures[textureIndex],
                );
              }

              if (material.normalTexture != null) {
                var textureIndex = material.normalTexture!.index;
                _updateImagesToLoadFromTexture(
                  imagesToLoad,
                  textures[textureIndex],
                );
              }

              if (material.occlusionTexture != null) {
                var textureIndex = material.occlusionTexture!.index;
                _updateImagesToLoadFromTexture(
                  imagesToLoad,
                  textures[textureIndex],
                );
              }

              if (material.pbrMetallicRoughness != null) {
                if (material.pbrMetallicRoughness!.baseColorTexture != null) {
                  var textureIndex =
                      material.pbrMetallicRoughness!.baseColorTexture!.index;
                  _updateImagesToLoadFromTexture(
                    imagesToLoad,
                    textures[textureIndex],
                  );
                }

                if (material.pbrMetallicRoughness!.metallicRoughnessTexture !=
                    null) {
                  var textureIndex =
                      material
                          .pbrMetallicRoughness!
                          .metallicRoughnessTexture!
                          .index;
                  _updateImagesToLoadFromTexture(
                    imagesToLoad,
                    textures[textureIndex],
                  );
                }
              }

              if (material.khrMaterialSpecular != null) {
                if (material.khrMaterialSpecular!.specularColorTexture !=
                    null) {
                  var textureIndex =
                      material.khrMaterialSpecular!.specularColorTexture!.index;
                  _updateImagesToLoadFromTexture(
                    imagesToLoad,
                    textures[textureIndex],
                  );
                }

                if (material.khrMaterialSpecular!.specularTexture != null) {
                  var textureIndex =
                      material.khrMaterialSpecular!.specularTexture!.index;
                  _updateImagesToLoadFromTexture(
                    imagesToLoad,
                    textures[textureIndex],
                  );
                }
              }
            }

            // search for indices buffer
            if (primitive.indices != null) {
              Accessor accessor = accessors[primitive.indices!];
              if (accessor.bufferView != null) {
                BufferView bv = bufferViews[accessor.bufferView!];
                buffersToLoad[bv.buffer] = true;
              }
            }

            // search for vertex attributes
            for (var attribute in primitive.attributes.values) {
              Accessor accessor = accessors[attribute];
              if (accessor.bufferView != null) {
                BufferView bv = bufferViews[accessor.bufferView!];
                buffersToLoad[bv.buffer] = true;
              }
            }
          }
        }
      }
    }

    List<Future> futures = [];
    for (int a = 0; a < imagesToLoad.length; a++) {
      if (imagesToLoad[a] && _runtimeImages[a] == null) {
        futures.add(loadImage(a, false));
      }
    }
    for (int a = 0; a < buffersToLoad.length; a++) {
      if (buffersToLoad[a] && _runtimeBuffers[a] == null) {
        futures.add(loadBuffer(a, false));
      }
    }
    await Future.wait(futures);
    _refresh();
  }

  @override
  String toString() {
    return 'Buffers: ${buffers.length}\n'
        'BufferViews: ${bufferViews.length}\n'
        'Images: ${images.length}\n'
        'Textures: ${textures.length}\n'
        'Accessors: ${accessors.length}\n'
        'Scenes: ${scenes.length}\n'
        'Nodes: ${nodes.length}\n'
        'Samplers: ${samplers.length}\n'
        'Meshes: ${meshes.length}\n'
        'Materials: ${materials.length}\n'
        'Animations: ${animations.length}\n'
        'Cameras: ${cameras.length}\n'
        'Skins: ${skins.length}\n'
        'KHR_lights_punctual: ${khrLightsPunctual.length}';
  }

  static Future<GLTF> loadGLTF(
    String name,
    String data,
    Future<Uint8List> Function(String? uri) onLoadData,
  ) async {
    Map<String, dynamic> json = jsonDecode(data);
    String version = json['asset']['version'];
    List<String> parts = version.split('.');
    int major = int.parse(parts[0]);
    int minor = int.parse(parts[1]);
    if (major != 2) {
      throw Exception('Unsupported GLTF version: $major.$minor');
    }

    List<dynamic>? extensionsRequired = json['extensionsRequired'];
    if (extensionsRequired != null) {
      for (var required in extensionsRequired) {
        if (!implementedExtensions.contains(required)) {
          throw Exception('Unsupported required extension: $required');
        }
      }
    }

    // load info
    Info info = Info.fromJson(name, json);

    // Buffers
    List<Buffer> buffers = [];
    List<dynamic> buffersDef = json['buffers'] ?? [];
    //List<Future<Uint8List>> bufferLoaders = [];
    for (var buffer in buffersDef) {
      int byteLength = buffer['byteLength'];
      String? uri = buffer['uri'];
      String? name = buffer['name'];
      buffers.add(Buffer(uri: uri, byteLength: byteLength, name: name));
    }
    //buffers = await Future.wait(bufferLoaders);

    // BufferViews
    List<BufferView> bufferViews = [];
    List<dynamic> bufferViewsDef = json['bufferViews'] ?? [];
    for (var bufferView in bufferViewsDef) {
      int buffer = bufferView['buffer'];
      int byteOffset = bufferView['byteOffset'] ?? 0;
      int byteLength = bufferView['byteLength'];
      int? byteStride = bufferView['byteStride'];
      int? target = bufferView['target'];
      String? name = bufferView['name'];
      bufferViews.add(
        BufferView(
          buffer: buffer,
          offset: byteOffset,
          length: byteLength,
          stride: byteStride,
          target: bufferViewTargetFromGLTF(target),
          name: name,
        ),
      );
    }

    // Accessors
    List<dynamic> accessorsDef = json['accessors'] ?? [];
    List<Accessor> accessors = [];
    for (var accessor in accessorsDef) {
      int? bufferView = accessor['bufferView'];
      int byteOffset = accessor['byteOffset'] ?? 0;
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
      bool normalized = accessor['normalized'] ?? false;
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

      accessors.add(
        Accessor(
          bufferView: bufferView,
          byteOffset: byteOffset,
          componentType: ct,
          normalized: normalized,
          count: count,
          type: t,
          name: name,
        ),
      );
    }

    List<Camera> cameras = [];
    List<dynamic> camerasDef = json['cameras'] ?? [];
    for (var camera in camerasDef) {
      String type = camera['type'];
      String? name = camera['name'];
      switch (type) {
        case 'perspective':
          double? aspectRatio =
              camera['perspective']['aspectRatio']?.toDouble();
          double yfov = camera['perspective']['yfov'].toDouble();
          double? zFar = camera['perspective']['zfar']?.toDouble();
          double zNear = camera['perspective']['znear'].toDouble();
          cameras.add(
            PerspectiveCamera(
              aspectRatio: aspectRatio,
              yFov: yfov,
              zFar: zFar,
              zNear: zNear,
              name: name,
            ),
          );
          break;
        case 'orthographic':
          double xMag = camera['orthographic']['xmag'].toDouble();
          double yMag = camera['orthographic']['ymag'].toDouble();
          double zFar = camera['orthographic']['zfar'].toDouble();
          double zNear = camera['orthographic']['znear'].toDouble();
          //double yMin = camera['orthographic']['yMin'];
          //double yMax = camera['orthographic']['yMax'];
          cameras.add(
            OrthographicCamera(
              xMag: xMag,
              yMag: yMag,
              zFar: zFar,
              zNear: zNear,
            ),
          );
          break;
        default:
          throw Exception('Unsupported camera type: $type');
      }
    }

    List<Image> images = [];
    List<dynamic> imagesDef = json['images'] ?? [];
    //List<Future<Uint8List>> imageLoaders = [];
    for (var image in imagesDef) {
      String? uri = image['uri'];
      String? mimeType = image['mimeType'];
      int? bufferView = image['bufferView'];
      String? name = image['name'];

      images.add(
        Image(uri: uri, mimeType: mimeType, bufferView: bufferView, name: name),
      );
    }

    List<Texture> textures = [];
    List<dynamic> texturesDef = json['textures'] ?? [];
    for (var texture in texturesDef) {
      int? sampler = texture['sampler'];
      int? source = texture['source'];
      String? name = texture['name'];

      EXTTextureWebp? extTextureWebp;

      var extensions = texture['extensions'];
      if (extensions != null) {
        var extTextureWebpDef = extensions['EXT_texture_webp'];
        if (extTextureWebpDef != null) {
          int source = extTextureWebpDef['source'];
          extTextureWebp = EXTTextureWebp(source: source);
        }
      }

      textures.add(
        Texture(
          sampler: sampler,
          source: source,
          name: name,
          extTextureWebp: extTextureWebp,
        ),
      );
    }

    List<Sampler> samplers = [];
    List<dynamic> samplersDef = json['samplers'] ?? [];
    for (var sampler in samplersDef) {
      int? magFilter = sampler['magFilter'];
      int? minFilter = sampler['minFilter'];
      int wrapS = sampler['wrapS'] ?? 10497;
      int wrapT = sampler['wrapT'] ?? 10497;
      String? name = sampler['name'];
      samplers.add(
        Sampler(
          magFilter: magFilterModeFromGLTF(magFilter),
          minFilter: minFilterModeFromGLTF(minFilter),
          wrapS: wrapModefromGLTF(wrapS),
          wrapT: wrapModefromGLTF(wrapT),
          name: name,
        ),
      );
    }

    List<Material> materials = [];
    List<dynamic> materialsDef = json['materials'] ?? [];
    for (var material in materialsDef) {
      String? name = material['name'];
      PBRMetallicRoughness? pbrMetallicRoughness =
          PBRMetallicRoughness.fromGLTF(material['pbrMetallicRoughness']);
      NormalTextureInfo? normalTexture = NormalTextureInfo.fromGLTF(
        material['normalTexture'],
      );
      OcclusionTextureInfo? occlusionTexture = OcclusionTextureInfo.fromGLTF(
        material['occlusionTexture'],
      );
      TextureInfo? emissiveTexture = TextureInfo.fromGLTF(
        material['emissiveTexture'],
      );
      Vector3 emissiveFactor =
          vec3FromGLTF(material['emissiveFactor']) ?? Vector3.zero();
      AlphaMode alphaMode =
          alphaModeFromGLTF(material['alphaMode']) ?? AlphaMode.opaque;
      double alphaCutoff = material['alphaCutoff'] ?? 0.5;
      bool doubleSided = material['doubleSided'] ?? false;

      KHRMaterialSpecular? khrMaterialSpecular;
      KHRMaterialIor? khrMaterialIor;
      KHRMaterialTransmission? khrMaterialTransmission;
      KHRMaterialSheen? khrMaterialSheen;
      KHRMaterialVolume? khrMaterialVolume;
      KHRMaterialAnisotropy? khrMaterialAnisotropy;
      KHRMaterialDispersion? khrMaterialDispersion;
      KHRMaterialEmissiveStrength? khrMaterialEmissiveStrength;
      KHRMaterialIridescence? khrMaterialIridescence;
      KHRMaterialUnlit? khrMaterialUnlit;

      var extensions = material['extensions'];
      if (extensions != null) {
        var specularExt = extensions['KHR_materials_specular'];
        if (specularExt != null) {
          double specularFactor =
              ((specularExt['specularFactor'] as num?) ?? 1.0).toDouble();
          TextureInfo? specularTexture = TextureInfo.fromGLTF(
            specularExt['specularTexture'],
          );
          Vector3 specularColorFactor =
              vec3FromGLTF(specularExt['specularColorFactor']) ??
              Vector3.all(1.0);
          TextureInfo? specularColorTexture = TextureInfo.fromGLTF(
            specularExt['specularColorTexture'],
          );
          khrMaterialSpecular = KHRMaterialSpecular(
            specularFactor: specularFactor,
            specularTexture: specularTexture,
            khrMaterialsSpecularSpecularColorFactor: specularColorFactor,
            specularColorTexture: specularColorTexture,
          );
        }

        var iorExt = extensions['KHR_materials_ior'];
        if (iorExt != null) {
          double ior = ((iorExt['ior'] as num?) ?? 1.0).toDouble();
          khrMaterialIor = KHRMaterialIor(ior: ior);
        }

        var transmissionExt = extensions['KHR_materials_transmission'];
        if (transmissionExt != null) {
          double? transmissionFactor =
              transmissionExt['transmissionFactor']?.toDouble();
          TextureInfo? transmissionTexture = TextureInfo.fromGLTF(
            transmissionExt['transmissionTexture'],
          );
          khrMaterialTransmission = KHRMaterialTransmission(
            transmissionFactor: transmissionFactor,
            transmissionTexture: transmissionTexture,
          );
        }

        var sheenExt = extensions['KHR_materials_sheen'];
        if (sheenExt != null) {
          Vector3? sheenColorFactor = vec3FromGLTF(
            sheenExt['sheenColorFactor'],
          );
          TextureInfo? sheenColorTexture = TextureInfo.fromGLTF(
            sheenExt['sheenColorTexture'],
          );
          double? sheenRoughnessFactor =
              sheenExt['sheenRoughnessFactor']?.toDouble();
          TextureInfo? sheenRoughnessTexture = TextureInfo.fromGLTF(
            sheenExt['sheenRoughnessTexture'],
          );
          khrMaterialSheen = KHRMaterialSheen(
            sheenColorFactor: sheenColorFactor,
            sheenColorTexture: sheenColorTexture,
            sheenRoughnessFactor: sheenRoughnessFactor,
            sheenRoughnessTexture: sheenRoughnessTexture,
          );
        }

        var volumeExt = extensions['KHR_materials_volume'];
        if (volumeExt != null) {
          double? thicknessFactor = volumeExt['thicknessFactor']?.toDouble();
          TextureInfo? thicknessTexture = TextureInfo.fromGLTF(
            volumeExt['thicknessTexture'],
          );
          double? attenuationDistance =
              volumeExt['attenuationDistance']?.toDouble();
          Vector3? attenuationColor = vec3FromGLTF(
            volumeExt['attenuationColor'],
          );

          khrMaterialVolume = KHRMaterialVolume(
            thicknessFactor: thicknessFactor,
            thicknessTexture: thicknessTexture,
            attenuationDistance: attenuationDistance,
            attenuationColor: attenuationColor,
          );
        }

        var anisotropyExt = extensions['KHR_materials_anisotropy'];
        if (anisotropyExt != null) {
          double? anisotropyStrength =
              anisotropyExt['anisotropyStrength']?.toDouble();
          double? anisotropyRotation =
              anisotropyExt['anisotropyRotation']?.toDouble();
          TextureInfo? anisotropyTexture = TextureInfo.fromGLTF(
            anisotropyExt['anisotropyTexture'],
          );
          khrMaterialAnisotropy = KHRMaterialAnisotropy(
            anisotropyStrength: anisotropyStrength,
            anisotropyRotation: anisotropyRotation,
            anisotropyTexture: anisotropyTexture,
          );
        }

        var dispersionExt = extensions['KHR_materials_dispersion'];
        if (dispersionExt != null) {
          double? dispersion = dispersionExt['dispersion']?.toDouble();
          khrMaterialDispersion = KHRMaterialDispersion(dispersion: dispersion);
        }

        var emissiveStrengthExt = extensions['KHR_materials_emissive_strength'];
        if (emissiveStrengthExt != null) {
          double? emissiveStrength =
              emissiveStrengthExt['emissiveStrength']?.toDouble();
          khrMaterialEmissiveStrength = KHRMaterialEmissiveStrength(
            emissiveStrength: emissiveStrength,
          );
        }

        var iridescenceExt = extensions['KHR_materials_iridescence'];
        if (iridescenceExt != null) {
          double? iridescenceFactor =
              iridescenceExt['iridescenceFactor']?.toDouble();
          TextureInfo? iridescenceTexture = TextureInfo.fromGLTF(
            iridescenceExt['iridescenceTexture'],
          );
          double? iridescenceIor = iridescenceExt['iridescenceIor']?.toDouble();
          double? iridescenceThicknessMinimum =
              iridescenceExt['iridescenceThicknessMinimum']?.toDouble();
          double? iridescenceThicknessMaximum =
              iridescenceExt['iridescenceThicknessMaximum']?.toDouble();
          TextureInfo? iridescenceThicknessTexture = TextureInfo.fromGLTF(
            iridescenceExt['iridescenceThicknessTexture'],
          );

          khrMaterialIridescence = KHRMaterialIridescence(
            iridescenceFactor: iridescenceFactor,
            iridescenceTexture: iridescenceTexture,
            iridescenceIor: iridescenceIor,
            iridescenceThicknessMinimum: iridescenceThicknessMinimum,
            iridescenceThicknessMaximum: iridescenceThicknessMaximum,
            iridescenceThicknessTexture: iridescenceThicknessTexture,
          );
        }

        var unlitExt = extensions['KHR_materials_unlit'];
        if (unlitExt != null) {
          khrMaterialUnlit = KHRMaterialUnlit();
        }
      }

      materials.add(
        Material(
          name: name,
          pbrMetallicRoughness: pbrMetallicRoughness,
          normalTexture: normalTexture,
          occlusionTexture: occlusionTexture,
          emissiveTexture: emissiveTexture,
          emissiveFactor: emissiveFactor,
          alphaMode: alphaMode,
          alphaCutoff: alphaCutoff,
          doubleSided: doubleSided,
          khrMaterialSpecular: khrMaterialSpecular,
          khrMaterialIor: khrMaterialIor,
          khrMaterialTransmission: khrMaterialTransmission,
          khrMaterialSheen: khrMaterialSheen,
          khrMaterialVolume: khrMaterialVolume,
          khrMaterialAnisotropy: khrMaterialAnisotropy,
          khrMaterialDispersion: khrMaterialDispersion,
          khrMaterialEmissiveStrength: khrMaterialEmissiveStrength,
          khrMaterialIridescence: khrMaterialIridescence,
          khrMaterialUnlit: khrMaterialUnlit,
        ),
      );
    }

    List<Mesh> meshes = [];
    List<dynamic> meshesDef = json['meshes'] ?? [];
    for (var mesh in meshesDef) {
      List<Primitive> primitives =
          (mesh['primitives'] as List)
              .map((e) => Primitive.fromGLTF(e))
              .toList();
      List<double>? weights = doubleListFromGLTF(mesh['weights']);
      String? name = mesh['name'];
      meshes.add(Mesh(primitives: primitives, weights: weights, name: name));
    }

    List<Node> nodes = [];
    List<dynamic> nodesDef = json['nodes'] ?? [];
    for (var node in nodesDef) {
      int? camera = node['camera'];
      List<int>? children = intListFromGLTF(node['children']);
      int? skin = node['skin'];
      Matrix4 matrix = mat4FromGLTF(node['matrix']) ?? Matrix4.identity();
      int? mesh = node['mesh'];
      Quaternion rotation =
          quatFromGLTF(node['rotation']) ?? Quaternion(0, 0, 0, 1);
      Vector3 scale = vec3FromGLTF(node['scale']) ?? Vector3.all(1);
      Vector3 translation = vec3FromGLTF(node['translation']) ?? Vector3.zero();
      List<double>? weights = doubleListFromGLTF(node['weights']);
      String? name = node['name'];

      int? khrLightPunctual;
      var extensions = node['extensions'];
      if (extensions != null) {
        var khrLightPunctualDef = extensions['KHR_lights_punctual'];
        if (khrLightPunctualDef != null) {
          khrLightPunctual = khrLightPunctualDef['light'];
          //print('Node: $node light: $khrLightPunctual');
        }
      }

      nodes.add(
        Node(
          camera: camera,
          children: children,
          skin: skin,
          matrix: matrix,
          mesh: mesh,
          rotation: rotation,
          scale: scale,
          translation: translation,
          weights: weights,
          name: name,
          khrLightPunctual: khrLightPunctual,
        ),
      );
    }

    List<Scene> scenes = [];
    List<dynamic> scenesDef = json['scenes'] ?? [];
    for (var scene in scenesDef) {
      List<int>? nodes = intListFromGLTF(scene['nodes']);
      String? name = scene['name'];
      scenes.add(Scene(nodes: nodes, name: name));
    }

    List<Skin> skins = [];
    List<dynamic> skinsDef = json['skins'] ?? [];
    for (var skin in skinsDef) {
      int? inverseBindMatrices = skin['inverseBindMatrices'];
      int? skeleton = skin['skeleton'];
      List<int> joints = intListFromGLTF(skin['joints'])!;
      String? name = skin['name'];
      skins.add(
        Skin(
          inverseBindMatrices: inverseBindMatrices,
          skeleton: skeleton,
          joints: joints,
          name: name,
        ),
      );
    }

    List<Animation> animations = [];
    List<dynamic> animationsDef = json['animations'] ?? [];
    for (var animation in animationsDef) {
      List<AnimationChannel> channels =
          (animation['channels'] as List)
              .map((e) => AnimationChannel.fromGLTF(e))
              .toList();
      List<AnimationSampler> samplers =
          (animation['samplers'] as List)
              .map((e) => AnimationSampler.fromGLTF(e))
              .toList();
      String? name = animation['name'];
      animations.add(
        Animation(channels: channels, samplers: samplers, name: name),
      );
    }

    List<KHRLightPunctual> khrLightsPunctual = [];
    Map<String, dynamic>? extensions = json['extensions'];
    if (extensions != null) {
      Map<String, dynamic>? khrLightsPunctualDef =
          extensions['KHR_lights_punctual'];
      if (khrLightsPunctualDef != null) {
        List<dynamic> lights = khrLightsPunctualDef['lights'] ?? [];
        for (var light in lights) {
          String name = light['name'] ?? '';
          Vector3 color = vec3FromGLTF(light['color']) ?? Vector3.all(1.0);
          num intensity = light['intensity'] ?? 1.0;
          KHRLightPunctualType type = khrLightPunctualTypeFromString(
            light['type'],
          );
          num? range = light['range'] as num?;
          num innerConeAngle = light['innerConeAngle'] ?? 0.0;
          num outerConeAngle = light['outerConeAngle'] ?? pi / 4.0;
          khrLightsPunctual.add(
            KHRLightPunctual(
              name: name,
              color: color,
              intensity: intensity.toDouble(),
              type: type,
              range: range?.toDouble(),
              innerConeAngle: innerConeAngle.toDouble(),
              outerConeAngle: outerConeAngle.toDouble(),
            ),
          );
        }
      }
    }

    return GLTF(
      info: info,
      onLoadData: onLoadData,
      buffers: buffers,
      bufferViews: bufferViews,
      accessors: accessors,
      cameras: cameras,
      images: images,
      textures: textures,
      samplers: samplers,
      materials: materials,
      meshes: meshes,
      nodes: nodes,
      scenes: scenes,
      skins: skins,
      animations: animations,
      khrLightsPunctual: khrLightsPunctual,
    );
  }

  static Future<GLTF> loadGLB(
    String name,
    Uint8List data,
    Future<Uint8List> Function(String uri) onLoadData,
  ) async {
    var header = data.buffer.asUint32List(0, 12);
    if (header[0] != 0x46546C67) {
      throw Exception('Invalid GLB header');
    }
    int version = header[1];
    if (version != 2) {
      throw Exception('Unsupported GLB version: $version');
    }

    var jsonChunk = _loadGLBChunk(data, 12);
    String json = utf8.decode(jsonChunk.$1);
    Uint8List? binaryChunk;
    int binaryChunkOffset = 12 + 8 + jsonChunk.$1.length;
    if (binaryChunkOffset & 3 != 0) {
      binaryChunkOffset += 4 - (binaryChunkOffset & 3);
    }
    if (binaryChunkOffset < data.length) {
      binaryChunk = _loadGLBChunk(data, binaryChunkOffset).$1;
    }
    //print('${binaryChunk!.length}');

    return loadGLTF(name, json, (uri) {
      //print('trying to load $uri');
      if (uri == null) {
        return Future.value(binaryChunk);
      } else {
        return onLoadData(uri);
      }
    });
  }

  static (Uint8List, int) _loadGLBChunk(Uint8List data, int offset) {
    var chunkHeader = data.buffer.asUint32List(offset, 8);
    int chunkLength = chunkHeader[0];
    int chunkType = chunkHeader[1];
    return (data.buffer.asUint8List(offset + 8, chunkLength), chunkType);
  }
}
