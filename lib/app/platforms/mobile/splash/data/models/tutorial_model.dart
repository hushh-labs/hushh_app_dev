class TutorialItem {
  final String icon;
  final String heading;
  final String desc;

  TutorialItem({
    required this.icon,
    required this.heading,
    required this.desc,
  });
}

class TutorialModel {
  final String image;
  final String heading;
  final List<TutorialItem> items;

  TutorialModel({
    required this.image,
    required this.heading,
    required this.items,
  });
}
