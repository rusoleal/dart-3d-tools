/// KHR_materials_dispersion
class KHRMaterialDispersion {
  /// The strength of the dispersion effect, specified as 20/Abbe number.
  double dispersion;

  KHRMaterialDispersion({double? dispersion}) : dispersion = dispersion ?? 0.0;
}
