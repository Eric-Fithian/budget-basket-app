enum UnitOfMeasurement {
  mL,
  g,
  each,
}

String unitOfMeasurementToString(UnitOfMeasurement uom) {
  return uom
      .toString()
      .split('.')
      .last
      .replaceAll(RegExp(r'(?<=[a-z])(?=[A-Z])'), ' ');
}
