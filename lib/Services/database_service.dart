import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:now_apps/Model/my_order.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import '../Model/miniProduct.dart';
import '../Model/productsModel.dart';
import '../Model/retailer_registerModel.dart';
import '../Model/usersModel.dart';
import '../Model/my_cart.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  // Defining Table Names
  final String _usersTableName = 'Users';
  final String _usersIdColumnName = 'uid';
  final String _usersNameColumnName = 'name';
  final String _usersEmailColumnName = 'email';
  final String _usersPhoneColumnName = 'phone';
  // For the retailer form
  final String _RetailerTableName = 'Register_Retailer';
  final String _RetailerNameColumnName = 'r_name';
  final String _RetailerPhoneColumnName = 'r_phone';
  final String _RetailerAddressColumnName = 'r_address';
  // final String _RetailerLatLongColumnName = 'r_latLong';

  final String _RetailerLatitudeColumnName = 'r_lat';
  final String _RetailerLongitudeColumnName = 'r_long';

  // For the cart section
  final String _CartName = 'my_Cart';
  final String _CartIdColumnName = 'c_id';
  final String _CartNameColumnName = 'c_name';
  final String _CartCountColumnName = 'c_count';
  final String _CartPriceColumnName = 'c_price';
  final String _CartRetailerColumnName = 'c_retailer';
  // For the order section
  final String _OrderName = 'my_order';
  final String _OrderIdColumnName = 'o_id';
  final String _OrderNameColumnName = 'o_name';
  final String _OrderCountColumnName = 'o_count';
  final String _OrderPriceColumnName = 'o_price';
  final String _OrderRetailerColumnName = 'o_retailer';

  // Definedd db
  static Database? _db;
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    // just to delete the whole db
    // await deleteDatabase(databasePath);
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        // Creating Users table
        await db.execute('''
          CREATE TABLE $_usersTableName (
            Sno INTEGER PRIMARY KEY AUTOINCREMENT,
            $_usersIdColumnName TEXT NOT NULL,
            $_usersNameColumnName TEXT NOT NULL,
            $_usersPhoneColumnName TEXT NOT NULL,
            $_usersEmailColumnName TEXT NOT NULL
          )
        ''');
        // Creating Retailer table
        await db.execute('''
          CREATE TABLE $_RetailerTableName (
            Sno INTEGER PRIMARY KEY AUTOINCREMENT,
            $_RetailerNameColumnName TEXT NOT NULL,
            $_RetailerPhoneColumnName TEXT NOT NULL,
            $_RetailerAddressColumnName TEXT NOT NULL,
             $_RetailerLatitudeColumnName REAL NOT NULL,
            $_RetailerLongitudeColumnName REAL NOT NULL
          )
        ''');
        // Creating Products table
        await db.execute('''
          CREATE TABLE Products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            prodId TEXT NOT NULL,
            prodName TEXT NOT NULL,
            prodRkPrice TEXT NOT NULL
          )
        ''');
        // Creating Cart table
        await db.execute('''
          CREATE TABLE $_CartName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_CartIdColumnName TEXT NOT NULL,
            $_CartNameColumnName TEXT NOT NULL,
            $_CartCountColumnName INTEGER NOT NULL,
            $_CartPriceColumnName INTEGER NOT NULL,
            $_CartRetailerColumnName TEXT NOT NULL
          )
        ''');
        // Creating order table
        await db.execute('''
          CREATE TABLE $_OrderName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_OrderIdColumnName TEXT NOT NULL,
            $_OrderNameColumnName TEXT NOT NULL,
            $_OrderCountColumnName INTEGER NOT NULL,
            $_OrderPriceColumnName INTEGER NOT NULL,
           $_OrderRetailerColumnName TEXT NOT NULL
          )
        ''');
      },
    );
    return database;
  }

  //  Get those data's
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<void> deleteDb() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    await deleteDatabase(databasePath);
    _db = null;
    print("Deleted DB");
  }

  // Add user to Users table
  Future<void> addUser(
      String id, String name, String email, String phone) async {
    final db = await database;
    await db.insert(_usersTableName, {
      _usersIdColumnName: id,
      _usersNameColumnName: name,
      _usersEmailColumnName: email,
      _usersPhoneColumnName: phone
    });
  }

  // Add retailer to Register_Retailer table
  Future<void> addRetailRegister(
      String name, String phone, String address, String latLong) async {
    final db = await database;
    List<String> parts = latLong.split(',');
    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());
    try {
      await db.insert(_RetailerTableName, {
        _RetailerNameColumnName: name,
        _RetailerPhoneColumnName: phone,
        _RetailerAddressColumnName: address,
        // _RetailerLatLongColumnName: latLong
        _RetailerLatitudeColumnName: latitude,
        _RetailerLongitudeColumnName: longitude
      });
      print("Inserted retailer: $name");
    } catch (e) {
      print("Error inserting retailer: $e");
      throw e;
    }
  }

  // Get all users from Users table
  Future<List<Users>?> getUsers() async {
    final db = await database;
    final data = await db.query(_usersTableName);
    print(data);
    List<Users> users = data
        .map((e) => Users(
              name: e[_usersNameColumnName] as String,
              uid: e[_usersIdColumnName] as String,
              email: e[_usersEmailColumnName] as String,
              phone: e[_usersPhoneColumnName] as String,
            ))
        .toList();
    return users;
  }

  // Get all retailers from Register_Retailer table
  Future<List<RetailerRegister>?> getRetailerRegister() async {
    final db = await database;
    final data = await db.query(_RetailerTableName);
    print(data);
    List<RetailerRegister> registerRetailer = data
        .map((e) => RetailerRegister(
              latitude: e[_RetailerLatitudeColumnName] as double,
              longitude: e[_RetailerLongitudeColumnName] as double,
              name: e[_RetailerNameColumnName] as String,
              phone: e[_RetailerPhoneColumnName] as String,
              address: e[_RetailerAddressColumnName] as String,
            ))
        .toList();
    return registerRetailer;
  }

  // Fetche products from API and return as product model list.
  Future<List<ProductModel>> fetchProductsFromAPI() async {
    final apiUrl = 'https://www.jsonkeeper.com/b/GCQS';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final productsList =
          ProductsListModel.fromJson(jsonData).data?.products ?? [];
      return productsList
          .map((product) => ProductModel(
                prodId: product.prodId ?? '',
                prodName: product.prodName ?? '',
                prodPrice: product.prodRkPrice ?? '50.00',
              ))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Add list of products to Products table
  Future<void> addProducts(List<ProductModel> products) async {
    final db = await database;
    final batch = db.batch();
    for (var product in products) {
      // Check if the product already exists in the database
      final existingProducts = await db.query(
        'Products',
        where: 'prodId = ?',
        whereArgs: [product.prodId],
      );
      // If the product does not exist, add it to the batch
      if (existingProducts.isEmpty) {
        batch.insert('Products', {
          'prodId': product.prodId,
          'prodName': product.prodName,
          'prodRkPrice': product.prodPrice,
        });
      }
    }

    await batch.commit();
    print("Inserted products: ${products.length}");
  }

  // Get all products from Products table.
  Future<List<ProductModel>> getProductsFromDatabase() async {
    final db = await database;
    final data = await db.query('Products');
    print("Fetched products from DB: $data");
    return data.map((product) {
      return ProductModel(
        prodId: product['prodId']?.toString() ?? '',
        prodName: product['prodName']?.toString() ?? '',
        prodPrice: product['prodRkPrice']?.toString() ?? '50.00',
      );
    }).toList();
  }

  // checking the product is on the cart or not
  Future<bool> isProductInCart(String productId) async {
    final db = await database;
    final data = await db.query(
      _CartName,
      where: '$_CartIdColumnName = ?',
      whereArgs: [productId],
    );
    return data.isNotEmpty;
  }

  // Add a product to the cart with given id,( name and count, price)
  Future<void> addCart(
      String id, String name, int count, int price, String retailer) async {
    final db = await database;
    try {
      await db.insert(_CartName, {
        _CartIdColumnName: id,
        _CartNameColumnName: name,
        _CartCountColumnName: count,
        _CartPriceColumnName: price,
        _CartRetailerColumnName: retailer,
      });
      print('Cart added');
    } catch (e) {
      print("Error adding to cart: $e");
      throw e;
    }
  }

  // Add product as order
  Future<void> addOrder(
      String id, String name, int count, int price, String retailer) async {
    final db = await database;
    try {
      await db.insert(_OrderName, {
        _OrderIdColumnName: id,
        _OrderNameColumnName: name,
        _OrderCountColumnName: count,
        _OrderPriceColumnName: price,
        _OrderRetailerColumnName: retailer
      });
      print('Order added successfullyy');
    } catch (e) {
      print("Error adding to orderr: $e");
      throw e;
    }
  }

  // Get all items in the cart as a list of myCart objects
  Future<List<myCart>?> getCart() async {
    final db = await database;
    final data = await db.query(_CartName);
    print(data);
    List<myCart> cart = data
        .map((e) => myCart(
              name: e[_CartNameColumnName] as String,
              id: e[_CartIdColumnName] as String,
              count: e[_CartCountColumnName] as int,
              price: e[_CartPriceColumnName] as int,
              retailer: e[_CartRetailerColumnName] as String,
            ))
        .toList();
    return cart;
  }

// Getting the order
  Future<List<myOrder>?> getOrder() async {
    final db = await database;
    final data = await db.query(_OrderName);
    print(data);
    List<myOrder> order = data
        .map((e) => myOrder(
              name: e[_OrderNameColumnName] as String,
              id: e[_OrderIdColumnName] as String,
              count: e[_OrderCountColumnName] as int,
              price: e[_OrderPriceColumnName] as int,
              retailer: e[_OrderRetailerColumnName] as String,
            ))
        .toList();

    return order;
  }

  // Increment count of product in the cart
  Future<void> incrementProductCount(String productId) async {
    final db = await database;
    await db.execute('''
    UPDATE $_CartName
    SET $_CartCountColumnName = $_CartCountColumnName + 1
    WHERE $_CartIdColumnName = ?
  ''', [productId]);
  }

  // Decrement count of product in the cart
  Future<void> decrementProductCount(String productId) async {
    final db = await database;
    await db.execute('''
    UPDATE $_CartName
    SET $_CartCountColumnName = $_CartCountColumnName - 1
    WHERE $_CartIdColumnName = ?
  ''', [productId]);
  }

// Remove cart...
  Future<void> deleteProductFromCart(String productId) async {
    final db = await database;
    await db.delete(
      _CartName,
      where: '$_CartIdColumnName = ?',
      whereArgs: [productId],
    );
    print('Product deleted from cart');
  }

  // Remove product from the cart
  Future<void> cancleOrder(String productId) async {
    final db = await database;
    await db.delete(
      _OrderName,
      where: '$_OrderIdColumnName = ?',
      whereArgs: [productId],
    );
    print('Order cancled');
  }

  // Get count of a specific product in the cart
  Future<int> getProductCount(String productId) async {
    final db = await database;
    final data = await db.query(
      _CartName,
      columns: [_CartCountColumnName],
      where: '$_CartIdColumnName = ?',
      whereArgs: [productId],
    );
    if (data.isNotEmpty) {
      var countValue = data.first[_CartCountColumnName];
      if (countValue is String) {
        return int.parse(countValue);
      } else if (countValue is int) {
        return countValue;
      }
    }
    return 0;
  }
}
