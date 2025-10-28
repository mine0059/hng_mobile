class ShoppingContract {
  ShoppingContract._();

  static const dbName = "shopping.db";
  static const databaseVersion = 1;

  static const tableShopingList = "shoppinglist";
  static const listColumnId = "id";
  static const listColumnTitle = "title";
  static const tableShoppingItem = "shoppingItem";
  static const itemColumnId = "id";
  static const itemColumnListId = "listid";
  static const itemColumnTitle = "title";
  static const itemColumnQuantity = "quantity";
  static const itemColumnUnit = "unit";
  static const itemColumnPrice = "price";
  static const itemColumnDone = "done";

  // This is for product database
  static const tableProductList = "productlist";
  static const productColumnId = "id";
  static const productColumnTitle = "title";
  static const productColumnQuantity = "quantity";
  static const productColumnDescription = "description";
  static const productColumnPrice = "price";
  static const productColumnImagePath = "imagePath";
}
