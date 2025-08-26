class CategoryItem {
  final String c_id;
  final String name;
  final String imagePath;

  CategoryItem({required this.c_id,required this.name, required this.imagePath});
}

final List<CategoryItem> categories = [
  CategoryItem(c_id:'c1',name: 'Paint Tube', imagePath: 'assets/images/paint_tubess.jpg'),
  CategoryItem(c_id:'c2',name: 'Fabric Paint', imagePath: 'assets/images/fabric_paintt.jpg'),
  CategoryItem(c_id:'c3',name: 'Paint Brush', imagePath: 'assets/images/paint_brushh.jpg'),
  // CategoryItem(c_id:'tray_roller',name: 'Tray Roller', imagePath: 'assets/images/tray_rolerr.jpg'),
  CategoryItem(c_id:'c4',name: 'Paint Can', imagePath: 'assets/images/paint_cann.jpg'),
  CategoryItem(c_id:'c5',name: 'Canvas', imagePath: 'assets/images/canvass.jpg'),
];
