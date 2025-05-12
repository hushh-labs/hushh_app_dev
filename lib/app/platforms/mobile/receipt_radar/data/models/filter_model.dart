class FilterModel {
  final String name;
  final List<String>? ids;
  bool isSelected;

  FilterModel({required this.name, this.isSelected = false, this.ids});
}
