import 'dart:ui';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class ColorUtils {
  static int _hash(String value) {
    int hash = 0;
    for (var code in value.runes) {
      hash = code + ((hash << 5) - hash);
    }
    return hash;
  }

  static Color stringToColor(String value) {
    return Color(stringToHexInt(value));
  }

  static String stringToHexColor(String value) {
    String c = (_hash(value) & 0x00FFFFFF).toRadixString(16).toUpperCase();
    return "0xFF00000".substring(0, 10 - c.length) + c;
  }

  static int stringToHexInt(String value) {
    String c = (_hash(value) & 0x00FFFFFF).toRadixString(16).toUpperCase();
    String hex = "FF00000".substring(0, 8 - c.length) + c;
    return int.parse(hex, radix: 16);
  }

  static bool isDark(Color color) {
    double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance < 0.7;
  }

  ColorUtils._(); // private constructor
}