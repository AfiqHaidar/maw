enum BannerIdentifier { picture, lottie, none }

extension BannerIdentifierExtension on BannerIdentifier {
  String get name {
    switch (this) {
      case BannerIdentifier.picture:
        return 'picture';
      case BannerIdentifier.lottie:
        return 'lottie';
      case BannerIdentifier.none:
        return '';
    }
  }

  static BannerIdentifier fromString(String type) {
    switch (type.toLowerCase()) {
      case 'picture':
        return BannerIdentifier.picture;
      case 'lottie':
        return BannerIdentifier.lottie;
      case '':
      case 'none':
        return BannerIdentifier.none;
      default:
        throw Exception("Invalid BannerIdentifier: $type");
    }
  }
}
