class Config {
  static Config _singleton = new Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  String url = 'https://emall.ae';

  String consumerKey = 'ck_6faf35d0915316a1f2fce325ff3957eae7b89943';

  String consumerSecret = 'cs_69e25ac75ba0c96e6edee0161d85ede969fddbfe';

  String mapApiKey = 'AIzaSyAbCInw-fLOIHaZqnozjUIfWa-u1hbbU4c';

  Map<String, dynamic> appConfig = Map<String, dynamic>();

  ///
  /// Loading a configuration [map] into the current app config.
  ///
  Config loadFromMap(Map<String, dynamic> map) {
    appConfig.addAll(map);
    return _singleton;
  }


  ///
  /// Reads a value of any type from persistent storage for the given [key].
  ///
  dynamic get(String key) => appConfig[key];

  ///
  /// Reads a [bool] value from persistent storage for the given [key], throwing an exception if it's not a bool.
  ///
  bool getBool(String key) => appConfig[key];

  ///
  /// Reads a [int] value from persistent storage for the given [key], throwing an exception if it's not an int.
  ///
  int getInt(String key) => appConfig[key];

  ///
  /// Reads a [double] value from persistent storage for the given [key], throwing an exception if it's not a double.
  ///
  double getDouble(String key) => appConfig[key];

  ///
  /// Reads a [String] value from persistent storage for the given [key], throwing an exception if it's not a String.
  ///
  String getString(String key) => appConfig[key];

  ///
  /// Clear the persistent storage. Only for Unit testing!
  ///
  void clear() => appConfig.clear();

  /// Write a value from persistent storage, throwing an exception if it's not
  /// the correct type
  @Deprecated("use updateValue instead")
  void setValue(key, value) => value.runtimeType != appConfig[key].runtimeType
      ? throw ("wrong type")
      : appConfig.update(key, (dynamic) => value);

  ///
  /// Update the given [value] for the given [key] in the storage.
  ///
  /// The updated value is *NOT* persistent
  /// Throws an exception if the given [value] has not the same [Type].
  ///
  void updateValue(String key, dynamic value) {
    if (appConfig[key] != null &&
        value.runtimeType != appConfig[key].runtimeType) {
      throw ("The persistent type of ${appConfig[key].runtimeType} does not match the given type ${value.runtimeType}");
    }
    appConfig.update(key, (dynamic) => value);
  }

  ///
  /// Adds the given [value] at the given [key] to the storage.
  ///
  /// The key and value is *NOT* persistent
  ///
  void addValue(String key, dynamic value) =>
      appConfig.putIfAbsent(key, () => value);

  ///
  /// Adds the given [map] to the storage.
  ///
  add(Map<String, dynamic> map) => appConfig.addAll(map);


}


/*

  String url = 'http://35.226.27.186/woocommerce';

  String consumerKey = 'ck_76973960a31c0cab6dd116611693abf161de5db7';

  String consumerSecret = 'cs_449e4f6508c90bd6a4c056a40318c6e1c6bcf532';


  String url = 'http://localhost:8888/wcfm';

  String consumerKey = 'ck_4a73578d64d0d3f996d69603590c9754b5aab15b';

  String consumerSecret = 'cs_d8486ede4990b0edbb6d850d3845b2b0e26d1410';


 */

//var url = 'http://localhost:8888/wcfm';
//var url = 'https://shop.saudasulf.com';
//var url = 'http://35.226.27.186/woocommerce';
//var url = 'https://buygo.xyz/woocommerce';
//var consumerKey = 'ck_76973960a31c0cab6dd116611693abf161de5db7';
//var consumerSecret = 'cs_449e4f6508c90bd6a4c056a40318c6e1c6bcf532';

//var url = 'https://dadosh.com';
//var consumerKey = 'ck_29d2b1801b13b9be0d2a05e68d3634792162c474';
//var consumerSecret = 'cs_c12c5406cc9ab3211499a4fa3af748f0d8d4831c';

//var url = 'https://ghost.delivery/uygulama';
//var consumerKey = 'ck_0484fed992809ee45afc47f1b5e0521d6f33caef';
//var consumerSecret = 'cs_ce2fa18b044a29849a79936f908807211bac58ae';

//var url = 'http://130.211.141.170/ionic4';
//var consumerKey = 'ck_6ecd7d7ccd67ed65225ba0b5a16f3582fde8b24e';
//var consumerSecret = 'cs_86f81e2c3e9e6a64a954ec006a1c9eea0d3aebb2';

//var url = 'http://130.211.141.170/ionic4';
//var consumerKey = 'ck_6ecd7d7ccd67ed65225ba0b5a16f3582fde8b24e';
//var consumerSecret = 'cs_86f81e2c3e9e6a64a954ec006a1c9eea0d3aebb2';

//var url = 'http://localhost:8888/wcfm';
//var consumerKey = 'ck_eb39c991775162b1f80915d3ff9bced78e7275c3';
//var consumerSecret = 'cs_2a804056884437c4962b1a201699ab7730b2f76b';

//var url = 'http://arabvape.com';
//var url = 'https://morslon.com';
//var consumerKey = 'ck_eb39c991775162b1f80915d3ff9bced78e7275c3';
//var consumerSecret = 'cs_2a804056884437c4962b1a201699ab7730b2f76b';

/*  var url = 'http://localhost:8888/dokan';
  var consumerKey = 'ck_0b80d24b7258363f1fe81c369beb621a063544c4';
  var consumerSecret = 'cs_97481e9961428dea92b49d1a34f21a2aaeabad36';*/

/*var url = 'http://localhost:8888/wpmarket';
  var consumerKey = 'ck_e5a049f502c5957ead36a91839bd2b6cfe794f05';
  var consumerSecret = 'cs_705c618b055153e24f58ac67bb12ce0da9032c85';*/

/*var url = 'https://erbil.online';
  var consumerKey = 'ck_b6746d2ed8389324cfa727325bb9e5ff5ed969af';
  var consumerSecret = 'cs_59484bb970c25e26ce990f120b7a4e68aae1ef13';*/


/*var url = 'https://ekitimarket.com';
  var consumerKey = 'ck_d85743aaaa0a491c2affe528f5db81c4ee1b530d';
  var consumerSecret = 'cs_10700b26ecb2f31773c0147ad867c25835e36925';*/

//var url = 'http://130.211.141.170/wc-marketplace';
//var consumerKey = 'ck_1833cc4a6b6b0eaa1e25a1e2f25c111f7af24efc';
// var consumerSecret = 'cs_1767a5bf30e3a2212cbfc264a64069c16c5f0333';


//var url = 'http://www.isbrothers.com';
//var url = 'http://localhost:8888/wcfm';
//var url = 'https://awalpets.com';
//var url = 'https://morslon.com';

//var url = 'http://35.226.27.186/marketplace';
//var url = 'https://dallaspresso.com';
//var url = 'http://130.211.141.170/wc-marketplace';

//var url = 'http://designing.website/demo';
//var url = 'http://mythoz.com/mart';
//var url = 'https://www.loviny.com';
//var url = 'https://dadosh.com';
//var url = 'https://499store.in';

//var url = 'https://bilinapo.com';
//var url = 'http://edragon.ae';
//var url = 'https://ekitimarket.com';
//var url = 'https://smartergem.com';
//var url = 'http://demo.ozoo.in';
//var url = 'https://okzion.com';