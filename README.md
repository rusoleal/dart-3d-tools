# glTF 2.0 helper library

A Flutter package that allows loading .gltf and .glb (glTF binary format) files according to the [glTF 2.0 specification.](https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html)

## Features

* Load .gltf format with external buffers/images.
* Load .gltf format with embedded buffers/images.
* Load .glb format (glTF binary format).
* Dynamic asset loading.
  * Load specific buffer via GLTF.loadBuffer
  * Load specific image via GLTF.loadImage
  * Load assets needed by a scene via GLTF.loadScene

## Live viewer

Try the [glTF Viewer](https://leal.games/gltf_viewer) and dive into the internal structure of your assets.

## Extensions

Ratified glTF 2.0 KHR extensions:

|                                 | Status  | Reference                                                                                                      |
|---------------------------------|---------|----------------------------------------------------------------------------------------------------------------|
| KHR_animation_pointer           | Ok      | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_animation_pointer)           |
| KHR_draco_mesh_compression      | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_draco_mesh_compression)      |
| KHR_lights_punctual             | Ok      | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_lights_punctual)             |
| KHR_materials_anisotropy        | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_anisotropy)        |
| KHR_materials_clearcoat         | Ok      | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_clearcoat)         |
| KHR_materials_dispersion        | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_dispersion)        |
| KHR_materials_emissive_strength | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_emissive_strength) |
| KHR_materials_ior               | Ok      | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_ior)               |
| KHR_materials_iridescence       | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_iridescence)       |
| KHR_materials_sheen             | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_sheen)             |
| KHR_materials_specular          | Ok      | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_specular)          |
| KHR_materials_transmission      | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_transmission)      |
| KHR_materials_unlit             | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_unlit)             |
| KHR_materials_variants          | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_variants)          |
| KHR_materials_volume            | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_materials_volume)            |
| KHR_mesh_quantization           | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_mesh_quantization)           |
| KHR_texture_basisu              | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_texture_basisu)              |
| KHR_texture_transform           | Ok      | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_texture_transform)           |
| KHR_xmp_json_ld                 | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Khronos/KHR_xmp_json_ld)                 |
| EXT_mesh_gpu_instancing         | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Vendor/EXT_mesh_gpu_instancing)          |
| EXT_meshopt_compression         | Pending | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Vendor/EXT_meshopt_compression)          |
| EXT_texture_webp                | Ok      | [Spec.](https://github.com/KhronosGroup/glTF/blob/main/extensions/2.0/Vendor/EXT_texture_webp)                 |
