enum InventoryFieldType { text, numeric, boolean, date }

InventoryFieldType parseInventoryFieldType(String value) {
  return InventoryFieldType.values.firstWhere(
    (e) => e.name == value,
    orElse: () => InventoryFieldType.text,
  );
}

class InventorySchemaResponse {
  final List<InventoryColumn> columns;

  InventorySchemaResponse(this.columns);
}

class InventoryColumn {
  String name;
  final InventoryFieldType fieldType;
  String? code;

  InventoryColumn(this.name, this.fieldType, {this.code});
}
