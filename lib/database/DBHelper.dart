import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/categoriesss_item.dart';
import '../models/product_item.dart';

class DBHelper{
  static final DBHelper instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  Future<Database> get db async{
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async{
    final path = join(await getDatabasesPath(),'arteva.db');
    return await openDatabase(path,version:5,onCreate: _onCreate,onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        p_id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        imageUrl TEXT,
        subtitle TEXT,
        description TEXT,
        c_id TEXT,
        price REAL,
        section TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      c_name TEXT NOT NULL,
      imagePath TEXT
    )
  ''');

    await db.execute('''
      CREATE TABLE cart(
        cart_id INTEGER PRIMARY KEY AUTOINCREMENT,
        p_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        user_id INTEGER,
        status text )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion == 5) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS cart(
        cart_id INTEGER PRIMARY KEY AUTOINCREMENT,
        p_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        user_id INTEGER,
        status TEXT
      )
    ''');
    }
  }


  ///cart

  Future<void>  addOrUpdateCartItem(int userId, int pId, int quantity) async {
    final dbClient = await db;

    final existing = await dbClient.query('cart', where: 'user_id = ? AND p_id = ? AND status = ?', whereArgs: [userId, pId, 'active'], limit: 1,); // limit = only fetch atmost 1 row

    if (existing.isNotEmpty) {
      final existingQuantity = (existing.first['quantity'] ?? 0) as int;
      await dbClient.update('cart', {'quantity': existingQuantity + quantity}, where: 'cart_id = ?', whereArgs: [existing.first['cart_id']],);
    } else {
      await dbClient.insert('cart', {
        'user_id': userId,
        'p_id': pId,
        'quantity': quantity,
        'status': 'active',
      });
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final dbClient = await db;
    return await dbClient.rawQuery('''
      SELECT cart.*, products.title, products.imageUrl, products.price
      FROM cart
      JOIN products ON cart.p_id = products.p_id
      WHERE cart.user_id = ? AND cart.status = ?
    ''', [userId, 'active']);
  }

  Future<void> updateCartItemQuantity(int cartId, int quantity) async {
    final dbClient = await db;
    await dbClient.update('cart', {'quantity': quantity}, where: 'cart_id = ?', whereArgs: [cartId],);
  }
  Future<void> removeCartItem(int cartId) async {
    final dbClient = await db;
    await dbClient.delete('cart', where: 'cart_id = ?', whereArgs: [cartId]);
  }

  Future<void> clearCart(int userId) async {
    final dbClient = await db;
    await dbClient.update('cart', {'status': 'removed'}, where: 'user_id = ? AND status = ?', whereArgs: [userId, 'active'],);
  }

  Future<double> getTotal(int userId) async {
    final dbClient = await db;
    final result = await dbClient.rawQuery('''
    SELECT SUM(c.quantity * p.price) as total
    FROM cart c
    JOIN products p ON c.p_id = p.p_id
    WHERE c.user_id = ? AND c.status = ?
  ''', [userId, 'active']);

    return result.first['total'] != null ? (result.first['total'] as num).toDouble() : 0.0;
  }

  Future<bool> isProductInCart(int userId, int pId) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'cart',
      where: 'user_id = ? AND p_id = ? AND status = ?',
      whereArgs: [userId, pId, 'active'],
    );
    return result.isNotEmpty;
  }

  /// category

  Future<int> insertCategory(CategoriesssItem category) async {
    final dbClient = await db;
    return await dbClient.insert('categories', category.toMap());
  }

  Future<List<CategoriesssItem>> getAllCategories() async {
    final dbClient = await db;
    final maps = await dbClient.query('categories');
    return maps.map((map) => CategoriesssItem.fromMap(map)).toList();
  }

  Future<int> updateCategory(CategoriesssItem category) async {
    final dbClient = await db;
    return await dbClient.update('categories', category.toMap(), where: 'id = ?', whereArgs: [category.id],);
  }

  Future<int> deleteCategory(int id) async {
    final dbClient = await db;
    return await dbClient.delete('categories', where: 'id = ?', whereArgs: [id]);
  }


  ///product

  Future<int> insertProduct(ProductItem product) async {
    final dbClient = await db;
    return await dbClient.insert('products', product.toMap());
  }

  Future<ProductItem?> getProductById(String id) async {
    final dbClient = await db;
    final maps = await dbClient.query('products', where: 'p_id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ProductItem.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ProductItem>> getAllProducts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('products');
    return maps.map((map) => ProductItem.fromMap(map)).toList();
  }
  Future<int> updateProduct(ProductItem product) async {
    final dbClient = await db;
    return await dbClient.update('products', product.toMap(), where: 'p_id = ?', whereArgs: [product.p_id],);
  }
  Future<int> deleteProduct(int id) async {
    final dbClient = await db;
    return await dbClient.delete('products', where: 'p_id = ?', whereArgs: [id]);
  }
}