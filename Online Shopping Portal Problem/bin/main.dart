//Online Shopping Portal OODP Assignment - 2

import 'dart:io';

//Main Function
main(List<String> arguments) {
  Portal portal = Portal.Get_Portal();
  List<Product> products = portal.Get_Portal_Products();

  portal.Display_Products();

  Product HP_Laptop = products[0];
  Product Iphone_6s = products[1];
  Product HP_Back_Bag = products[2];
  Product Skull_Candy_Head_Phones = products[3];

  User user1 = new User();
  User user2 = new User();
  User user3 = new User();
  User user4 = new User();

  user1.Buy_Product(HP_Laptop);
  user2.Buy_Product(Iphone_6s);
  user3.Buy_Product(HP_Back_Bag);
  user4.Buy_Product(Skull_Candy_Head_Phones);

  portal.Display_Products();

  user1.Subscribe_Product(HP_Laptop);
  user2.Subscribe_Product(Iphone_6s);
  user3.Subscribe_Product(HP_Back_Bag);
  user4.Subscribe_Product(Skull_Candy_Head_Phones);

  HP_Laptop.Update_Quantity(10);
  Iphone_6s.Update_Quantity(1);
  HP_Back_Bag.Update_Quantity(2);
  Skull_Candy_Head_Phones.Update_Quantity(2);

  portal.Display_Products();
}

//Interface In Dart Language
abstract class Vendor_Inventory_System {
  List<Product> Get_Products();

  Vendor_Inventory_System Clone();
}

class Vendor_Inventory implements Vendor_Inventory_System {
  List<Product> _products; //Private Member In Dart Language

  Vendor_Inventory() {
    _products = new List<Product>();
  }

  void Add_Product(Product t) {
    _products.add(t);
  }

  void Load_Products() {
    _products.add(new Product(0, "HP Laptop", 1));
    _products.add(new Product(1, "Iphone 6s", 1));
    _products.add(new Product(2, "HP Back Bag", 5));
    _products.add(new Product(3, "Skull Candy Head Phones", 0));
    _products.add(new Product(4, "Lenovo Smart Tablet", 2));
    _products.add(new Product(5, "Xiaomi PowerBank", 3));
    _products.add(new Product(6, "LG Smart LED", 3));
  }

  @override
  List<Product> Get_Products() {
    if (_products.isEmpty) {
      Load_Products();
    }
    return _products;
  }

  @override
  Vendor_Inventory_System Clone() {
    Vendor_Inventory C;
    for (Product t in _products) {
      C.Add_Product(t);
    }
    return C;
  }
}

class Vendor {
  static Vendor _vendor = new Vendor(); //Private Member In Dart Language
  Vendor_Inventory_System _inventory =
      new Vendor_Inventory(); //Private Member In Dart Language

  //Private Constructor In Dart Language
  _Vendor() {}

  static Vendor Get_Vendor() {
    return _vendor;
  }

  List<Product> Get_Products() {
    return _inventory.Get_Products();
  }
}

//Interface In Dart Language
abstract class Inventory {
  List<Product> Get_Inventory_Products();
}

class Inventory_Adapter implements Inventory {
  Vendor_Inventory_System
      _vendor_Inventory_System; //Private Member In Dart Language

  Inventory_Adapter() {
    _vendor_Inventory_System = new Vendor_Inventory();
  }

  @override
  List<Product> Get_Inventory_Products() {
    return this._vendor_Inventory_System.Get_Products();
  }
}

class Portal_Inventory implements Inventory {
  Inventory_Adapter _inventory_Adapter; //Private Member In Dart Language

  Portal_Inventory() {
    _inventory_Adapter = new Inventory_Adapter();
  }

  @override
  List<Product> Get_Inventory_Products() {
    return _inventory_Adapter.Get_Inventory_Products();
  }
}

class Portal {
  static Portal _portal = new Portal(); //Private Member In Dart Language
  Inventory _inventory =
      new Portal_Inventory(); //Private Member In Dart Language

  //Private Constructor In Dart Language
  _Portal() {}

  //Static Function In Dart Language
  static Portal Get_Portal() {
    return _portal;
  }

  List<Product> Get_Portal_Products() {
    return _inventory.Get_Inventory_Products();
  }

  void Display_Products() {
    stdout.writeln(
        "-------------------------------- Portal Products --------------------------------");
    for (Product t in Get_Portal_Products()) {
      t.Show_Product_Info();
    }
    stdout.writeln(
        "---------------------------------------------------------------------------------\n");
  }
}

class Product {
  int _ID; //Private Member In Dart Language
  String _name; //Private Member In Dart Language
  int _quantity; //Private Member In Dart Language

  List<User> _Subscribed_Users =
      new List<User>(); //Private Member In Dart Language

  Product(int ID, String name, int quantity) {
    _ID = ID;
    _name = name;
    _quantity = quantity;
  }

  String Name() {
    return this._name;
  }

  int Quantity() {
    return this._quantity;
  }

  void Add_User(User t) {
    this._Subscribed_Users.add(t);
  }

  void Update_Quantity(int t) {
    if (_quantity == 0 && t > 0) {
      _quantity = t;
      stdout.writeln("Updated " +
          _name +
          " Product's Quantity = " +
          _quantity.toString() +
          " --- Product ID = " +
          _ID.toString() +
          "\n");
      Notify_All_Subscribed_Users();
    } else if (_quantity > 0 && t > 0) {
      _quantity += t;
      stdout.writeln("Updated " +
          _name +
          " Product's Quantity = " +
          _quantity.toString() +
          " --- Product ID = " +
          _ID.toString() +
          "\n");
    } else {
      stdout.writeln("Invalid Input");
    }
  }

  void Buying() {
    _quantity--;
  }

  void Notify_All_Subscribed_Users() {
    for (User t in _Subscribed_Users) {
      t.Notification();
    }
  }

  void Show_Product_Info() {
    stdout.writeln("Product ID: " +
        _ID.toString() +
        "\t --- name: " +
        Name() +
        "\t --- Available Quantity: " +
        Quantity().toString());
  }
}

abstract class Observer {
  static int Number_of_Observers = 0; //Static Member In Dart Language
  Product product;

  void Notification();
}

class User extends Observer {
  int _ID; //Private Member In Dart Language

  User() {
    product = null;
    Observer.Number_of_Observers++;
    _ID = Observer.Number_of_Observers;
  }

  void Subscribe_Product(Product t) {
    product = t;
    product.Add_User(this);
  }

  void Buy_Product(Product t) {
    if (t.Quantity() > 0) {
      t.Buying();
      stdout
          .writeln(t.Name() + " is Sold to User ID: " + _ID.toString() + "\n");
    } else {
      stdout.writeln(t.Name() + " is not Available in Stock\n");
    }
  }

  void Notification() {
    if (this.product.Quantity() >= 1)
      stdout.writeln("------------------------- User ID: " +
          _ID.toString() +
          " Notification --------------------------\n" +
          product.Name() +
          " is available Now in stock --- ID: " +
          product._ID.toString() +
          " --- Quantity: " +
          product.Quantity().toString() +
          "\n----------------------------------------------------------------------------");
    stdout.writeln();
  }
}
