class ProductItem {
  final int? p_id;
  final String title;
  final String imageUrl;
  final String subtitle;
  final String description;
  final String c_id;
  final String section;
  final double price;

  ProductItem({this.p_id, required this.title, required this.imageUrl,required this.subtitle,required this.description,required this.c_id,required this.section, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'p_id': p_id,
      'title': title,
      'imageUrl': imageUrl,
      'subtitle': subtitle,
      'description': description,
      'c_id' : c_id,
      'price': price,
      'section' : section,
    };
  }

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      p_id: map['p_id'] as int?,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      c_id: map['c_id'] ?? '',
      section: map['section'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}
