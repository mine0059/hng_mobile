import 'package:hng_mobile/utils/contract.dart';
import 'package:sqflite/sqflite.dart';

class ShoppingListModel {
  ShoppingListModel({required this.title});

  // The is from map to Object
  ShoppingListModel.fromMap(Map map) {
    id = map[ShoppingContract.listColumnId] as int?;
    title = map[ShoppingContract.listColumnTitle] as String?;
  }

  // This is from Object to map
  Map<String, Object?> toMap() {
    final map = <String, Object?>{ShoppingContract.listColumnTitle: title};

    if (id != null) {
      map[ShoppingContract.listColumnId] = id;
    }

    return map;
  }

  int? id;
  String? title;
}

class ShoppingItemModel {
  ShoppingItemModel({
    required this.title,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.done,
    this.listId,
  });

  ShoppingItemModel.fromMap(Map map) {
    id = map[ShoppingContract.itemColumnId] as int?;
    listId = map[ShoppingContract.itemColumnListId] as int?;
    title = map[ShoppingContract.itemColumnTitle] as String?;
    quantity = map[ShoppingContract.itemColumnQuantity] as double?;
    unit = map[ShoppingContract.itemColumnUnit] as String?;
    price = map[ShoppingContract.itemColumnPrice] as double?;
    done = map[ShoppingContract.itemColumnDone] == 1;
  }

  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      ShoppingContract.itemColumnListId: listId,
      ShoppingContract.itemColumnTitle: title,
      ShoppingContract.itemColumnQuantity: quantity,
      ShoppingContract.itemColumnUnit: unit,
      ShoppingContract.itemColumnPrice: price,
      ShoppingContract.itemColumnDone: done
    };

    if (id != null) {
      map[ShoppingContract.itemColumnId] = id;
    }

    return map;
  }

  int? id;
  int? listId;
  String? title;
  double? quantity;
  String? unit;
  double? price;
  bool? done;
}

class ProductModel {
  ProductModel({
    this.id,
    required this.title,
    required this.quantity,
    required this.description,
    required this.price,
    this.imagePath,
  });

  ProductModel.fromMap(Map map) {
    id = map[ShoppingContract.productColumnId] as int?;
    title = map[ShoppingContract.productColumnTitle] as String?;
    quantity = map[ShoppingContract.productColumnQuantity] as double?;
    description = map[ShoppingContract.productColumnDescription] as String?;
    price = map[ShoppingContract.productColumnPrice] as double?;
    imagePath = map[ShoppingContract.productColumnImagePath] as String?;
  }

  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      ShoppingContract.productColumnTitle: title,
      ShoppingContract.productColumnQuantity: quantity,
      ShoppingContract.productColumnDescription: description,
      ShoppingContract.productColumnPrice: price,
      ShoppingContract.productColumnImagePath: imagePath,
    };

    if (id != null) {
      map[ShoppingContract.productColumnId] = id;
    }

    return map;
  }

  int? id;
  String? title;
  double? quantity;
  String? description;
  double? price;
  String? imagePath;
}

// below is the actual sQL Helper.
class ShoppingHelper {
  late Database db;

  Future<void> open(String path) async {
    db = await openDatabase(
      path,
      version: ShoppingContract.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE ${ShoppingContract.tableShopingList} (
        ${ShoppingContract.listColumnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ShoppingContract.listColumnTitle} TEXT NOT NULL)
        ''');
      await txn.execute('''
      CREATE TABLE ${ShoppingContract.tableShoppingItem} (
        ${ShoppingContract.itemColumnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ShoppingContract.itemColumnListId} INTEGER,
        ${ShoppingContract.itemColumnTitle} TEXT NOT NULL,
        ${ShoppingContract.itemColumnQuantity} REAL DEFAULT 0.0 NOT NULL,
        ${ShoppingContract.itemColumnUnit} TEXT DEFAULT "kg" NOT NULL,
        ${ShoppingContract.itemColumnPrice} REAL DEFAULT 0.0 NOT NULL,
        ${ShoppingContract.itemColumnDone} INTEGER NOT NULL
      )
    ''');

      await txn.execute('''
      CREATE TABLE ${ShoppingContract.tableProductList} (
        ${ShoppingContract.productColumnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ShoppingContract.productColumnTitle} TEXT NOT NULL,
        ${ShoppingContract.productColumnQuantity} REAL DEFAULT 0.0 NOT NULL,
        ${ShoppingContract.productColumnDescription} TEXT NOT NULL,
        ${ShoppingContract.productColumnPrice} REAL DEFAULT 0.0 NOT NULL,
        ${ShoppingContract.productColumnImagePath} TEXT
      )
    ''');
    });
  }

  // Database migrations
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await db.execute(
          'ALTER TABLE ${ShoppingContract.tableShopingList} ADD COLUMN description TEXT');
    }
  }

  void _onDowngrade(Database db, int oldVersion, int newVersion) {}

  Future<void> insertShoppingList(ShoppingListModel shoppingList) async {
    shoppingList.id = await db.insert(
        ShoppingContract.tableShopingList, shoppingList.toMap());

    // Performing batch processing in SqfLite
    Batch batch = db.batch();
    batch.insert(
        ShoppingContract.tableShoppingItem,
        ShoppingItemModel(
                title: 'Vegitables',
                quantity: 0,
                unit: 'kg',
                price: 0,
                done: false)
            .toMap());
    batch.insert(
        ShoppingContract.tableShoppingItem,
        ShoppingItemModel(
                title: 'Fruits', quantity: 0, unit: 'kg', price: 0, done: false)
            .toMap());
  }

  Future<ShoppingListModel?> getShoppingList(int id) async {
    try {
      List<Map> shoppinglists =
          await db.query(ShoppingContract.tableShopingList,
              columns: [
                ShoppingContract.listColumnId,
                ShoppingContract.listColumnTitle,
              ],
              where: '${ShoppingContract.listColumnId} = ?',
              whereArgs: [id]);

      if (shoppinglists.isNotEmpty) {
        return ShoppingListModel.fromMap(shoppinglists.first);
      }
    } on DatabaseException catch (_) {
      return null;
    }

    return null;
  }

  Future<List<ShoppingListModel>> getShoppingLists() async {
    List<Map> shoppingLists = await db.query(ShoppingContract.tableShopingList);

    List<ShoppingListModel> lists = [];
    if (shoppingLists.isNotEmpty) {
      for (Map shoppingList in shoppingLists) {
        lists.add(ShoppingListModel.fromMap(shoppingList));
      }
    }

    return lists;
  }

  Future<int> updateShoppingList(ShoppingListModel shoppingList) async {
    return await db.update(
        ShoppingContract.tableShopingList, shoppingList.toMap(),
        where: '${ShoppingContract.listColumnId} = ?',
        whereArgs: [shoppingList.id]);
  }

  Future<int> deleteShoppingList(int id) async {
    final deleteId = await db.delete(ShoppingContract.tableShopingList,
        where: '${ShoppingContract.listColumnId} = ?', whereArgs: [id]);

    // delete items in the shopping list
    await db.delete(ShoppingContract.tableShoppingItem,
        where: '${ShoppingContract.itemColumnListId} = ?', whereArgs: [id]);
    return deleteId;
  }

  Future<ShoppingItemModel> insertShoppingItem(
      ShoppingItemModel shoppingItem) async {
    shoppingItem.id = await db.insert(
        ShoppingContract.tableShoppingItem, shoppingItem.toMap());

    return shoppingItem;
  }

  Future<ShoppingItemModel?> getShoppingItem(int id) async {
    try {
      List<Map> shoppingItem =
          await db.query(ShoppingContract.tableShoppingItem,
              columns: [
                ShoppingContract.itemColumnId,
                ShoppingContract.itemColumnTitle,
                ShoppingContract.itemColumnQuantity,
                ShoppingContract.itemColumnUnit,
                ShoppingContract.itemColumnPrice,
                ShoppingContract.itemColumnDone,
              ],
              where: '${ShoppingContract.itemColumnId} = ?',
              whereArgs: [id]);

      if (shoppingItem.isNotEmpty) {
        return ShoppingItemModel.fromMap(shoppingItem.first);
      }
    } on DatabaseException catch (_) {
      return null;
    }

    return null;
  }

  Future<List<ShoppingItemModel>> getShoppingItems(int? listId) async {
    List<Map> shoppingItems = await db.query(ShoppingContract.tableShoppingItem,
        columns: [
          ShoppingContract.itemColumnId,
          ShoppingContract.itemColumnTitle,
          ShoppingContract.itemColumnQuantity,
          ShoppingContract.itemColumnUnit,
          ShoppingContract.itemColumnPrice,
          ShoppingContract.itemColumnDone,
        ],
        where: '${ShoppingContract.itemColumnListId} = ?',
        whereArgs: [listId]);

    List<ShoppingItemModel> items = [];
    if (shoppingItems.isNotEmpty) {
      for (Map shoppingItem in shoppingItems) {
        items.add(ShoppingItemModel.fromMap(shoppingItem));
      }
    }

    return items;
  }

  Future<int> deleteShoppingItem(int id) async {
    return await db.delete(ShoppingContract.tableShoppingItem,
        where: '${ShoppingContract.listColumnId} = ?', whereArgs: [id]);
  }

  Future<int> updateShoppingItem(ShoppingItemModel shoppingItem) async {
    return await db.update(
        ShoppingContract.tableShoppingItem, shoppingItem.toMap(),
        where: '${ShoppingContract.itemColumnId} = ?',
        whereArgs: [shoppingItem.id]);
  }

  /// PRODUCT TABLE METHODS BELOW
  // insert products
  Future<void> insertProductList(ProductModel product) async {
    product.id =
        await db.insert(ShoppingContract.tableProductList, product.toMap());
  }

  Future<ProductModel?> getProduct(int id) async {
    try {
      List<Map> products = await db.query(ShoppingContract.tableProductList,
          columns: [
            ShoppingContract.productColumnId,
            ShoppingContract.productColumnTitle,
            ShoppingContract.productColumnQuantity,
            ShoppingContract.productColumnDescription,
            ShoppingContract.productColumnPrice,
            ShoppingContract.productColumnImagePath,
          ],
          where: '${ShoppingContract.productColumnId} = ?',
          whereArgs: [id]);
      if (products.isNotEmpty) {
        return ProductModel.fromMap(products.first);
      }
    } on DatabaseException catch (_) {
      return null;
    }

    return null;
  }

  Future<List<ProductModel>> getProducts() async {
    List<Map> products = await db.query(ShoppingContract.tableProductList);

    List<ProductModel> productList = [];
    if (products.isNotEmpty) {
      for (Map product in products) {
        productList.add(ProductModel.fromMap(product));
      }
    }

    return productList;
  }

  Future<int> updateProduct(ProductModel product) async {
    return await db.update(ShoppingContract.tableProductList, product.toMap(),
        where: '${ShoppingContract.productColumnId} = ?',
        whereArgs: [product.id]);
  }

  Future<int> deleteProduct(int id) async {
    return await db.delete(ShoppingContract.tableProductList,
        where: '${ShoppingContract.productColumnId} = ?', whereArgs: [id]);
  }
}
