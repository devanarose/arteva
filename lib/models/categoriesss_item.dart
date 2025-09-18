class CategoriesssItem {
  final int? id;
  final String c_name;
  final String imagePath;

  CategoriesssItem({this.id, required this.c_name, required this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'c_name': c_name,
      'imagePath': imagePath,
    };
  }

  factory CategoriesssItem.fromMap(Map<String, dynamic> map) {
    return CategoriesssItem(
      id: map['id'],
      c_name: map['c_name'],
      imagePath: map['imagePath'],
    );
  }
}
