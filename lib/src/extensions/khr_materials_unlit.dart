/// The common Unlit material is defined by adding the KHR_materials_unlit
/// extension to any glTF material. When present, the extension indicates that
/// a material should be unlit and use available baseColor values, alpha values,
/// and vertex colors while ignoring all properties of the default PBR model
/// related to lighting or color. Alpha coverage and doubleSided still apply to
/// unlit materials.
class KHRMaterialUnlit {}
