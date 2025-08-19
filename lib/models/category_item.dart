class CategoryItem {
  final String name;
  final String imagePath;

  CategoryItem({required this.name, required this.imagePath});
}

final List<CategoryItem> categories = [
  CategoryItem(name: 'Paint Tube', imagePath: 'assets/images/paint_tubess.jpg'),
  CategoryItem(name: 'Fabric Paint', imagePath: 'assets/images/fabric_paintt.jpg'),
  CategoryItem(name: 'Paint Brush', imagePath: 'assets/images/paint_brushh.jpg'),
  CategoryItem(name: 'Tray Roller', imagePath: 'assets/images/tray_rolerr.jpg'),
  CategoryItem(name: 'Paint Can', imagePath: 'assets/images/paint_cann.jpg'),
  CategoryItem(name: 'Canvas', imagePath: 'assets/images/canvass.jpg'),
];
