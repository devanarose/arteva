class BannerItem {
  final int bannerId;
  final String bannerName;
  final String bannerImage;
  final String bannerLink;
  final String bannerLinkType;

  BannerItem({
    required this.bannerId,
    required this.bannerName,
    required this.bannerImage,
    required this.bannerLink,
    required this.bannerLinkType,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      bannerId: int.parse(json['banner_id'].toString()),
      bannerName: json['banner_name']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      bannerLink: json['banner_link']?.toString() ?? '',
      bannerLinkType: json['banner_link_type']?.toString() ?? '',
    );
  }

}
