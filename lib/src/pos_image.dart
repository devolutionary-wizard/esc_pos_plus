import 'package:image/image.dart';

import 'pos_styles.dart';

/// Column contains text, styles and width (an integer in 1..12 range)
/// [containsChinese] not used if the text passed as textEncoded
class PosImage {
  PosImage({
    required this.image,
    this.width = 2,
    this.styles = const PosStyles(),
  }) {
    if (width < 1 || width > 12) {
      throw Exception('Column width must be between 1..12');
    }
  }

  Image image;
  int width;
  PosStyles styles;
}
