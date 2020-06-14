// To parse this JSON data, do
//
//     final blocksModel = blocksModelFromJson(jsonString);

import 'dart:convert';
import 'category_model.dart';
import '../models/product_model.dart';
import 'customer_model.dart';

BlocksModel blocksModelFromJson(String str) => BlocksModel.fromJson(json.decode(str));

class BlocksModel {
  List<Block> blocks;
  List<Child> pages;
  Settings settings;
  Dimensions dimensions;
  List<Product> featured;
  List<Product> onSale;
  List<Category> categories;
  int maxPrice;
  String loginNonce;
  String currency;
  String language;
  List<Language> languages;
  List<Currency> currencies;
  bool status;
  List<Product> recentProducts;
  Customer user;
  LocaleText localeText;


  BlocksModel({
    this.blocks,
    this.pages,
    this.settings,
    this.dimensions,
    this.featured,
    this.onSale,
    this.categories,
    this.maxPrice,
    this.loginNonce,
    this.currency,
    this.languages,
    this.currencies,
    this.status,
    this.recentProducts,
    this.user,
    this.language,
    this.localeText

  });

  factory BlocksModel.fromJson(Map<String, dynamic> json) => BlocksModel(
    blocks: json["blocks"] == null ? null : List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
    recentProducts: json["recentProducts"] == null ? null : List<Product>.from(json["recentProducts"].map((x) => Product.fromJson(x))),
    pages: json["pages"] == null ? [] : List<Child>.from(json["pages"].map((x) => Child.fromJson(x))),
    settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
    featured: json["featured"] == null ? null : List<Product>.from(json["featured"].map((x) => Product.fromJson(x))),
    onSale: json["on_sale"] == null ? null : List<Product>.from(json["on_sale"].map((x) => Product.fromJson(x))),
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    maxPrice: json["max_price"] == null ? null : json["max_price"],
    loginNonce: json["login_nonce"] == null ? null : json["login_nonce"],
    currency: json["currency"] == null ? null : json["currency"],
    languages: json["languages"] == null ? [] : List<Language>.from(json["languages"].map((x) => Language.fromJson(x))),
    currencies: json["currencies"] == null ? [] : List<Currency>.from(json["currencies"].map((x) => Currency.fromJson(x))),
    user: json["user"] == null ? null : Customer.fromJson(json["user"]),
      localeText: json["locale"] == null ? null : LocaleText.fromJson(json["locale"]),
      language: 'en'
  );

}

class LocaleText {
  String home;
  String category;
  String categories;
  String cart;
  String addToCart;
  String buyNow;
  String outOfStock;
  String inStock;
  String account;
  String product;
  String products;
  String signIn;
  String signUp;
  String orders;
  String order;
  String wishlist;
  String address;
  String settings;
  String localeTextContinue;
  String save;
  String filter;
  String apply;
  String featured;
  String newArrivals;
  String sales;
  String shareApp;
  String username;
  String password;
  String firstName;
  String lastName;
  String phoneNumber;
  String address2;
  String email;
  String city;
  String pincode;
  String location;
  String select;
  String selectLocation;
  String states;
  String state;
  String country;
  String countires;
  String relatedProducts;
  String justForYou;
  String youMayAlsoLike;
  String billing;
  String shipping;
  String discount;
  String subtotal;
  String total;
  String tax;
  String fee;
  String orderSummary;
  String thankYou;
  String payment;
  String paymentMethod;
  String shippingMethod;
  String billingAddress;
  String shippingAddress;
  String noOrders;
  String noMoreOrders;
  String noWishlist;
  String noMoreWishlist;
  String localeTextNew;
  String otp;
  String reset;
  String resetPassword;
  String newPassword;
  String requiredField;
  String pleaseEnter;
  String pleaseEnterUsername;
  String pleaseEnterPassword;
  String pleaseEnterFirstName;
  String pleaseEnterLastName;
  String pleaseEnterCity;
  String pleaseEnterPincode;
  String pleaseEnterState;
  String pleaseEnterValidEmail;
  String pleaseEnterPhoneNumber;
  String pleaseEnterOtp;
  String pleaseEnterAddress;
  String logout;
  String pleaseWait;
  String language;
  String currency;
  String forgotPassword;
  String alreadyHaveAnAccount;
  String dontHaveAnAccount;
  String theme;
  String light;
  String dart;
  String system;
  String noProducts;
  String noMoreProducts;
  String chat;
  String call;
  String info;
  String edit;
  String welcome;
  String checkout;
  String items;
  String couponCode;
  String pleaseEnterCouponCode;
  String emptyCart;
  String youOrderHaveBeenReceived;
  String thankYouForShoppingWithUs;
  String thankYouOrderIdIs;
  String youWillReceiveAConfirmationMessage;
  String add;
  String quantity;

  LocaleText({
    this.home,
    this.category,
    this.categories,
    this.cart,
    this.addToCart,
    this.buyNow,
    this.outOfStock,
    this.inStock,
    this.account,
    this.product,
    this.products,
    this.signIn,
    this.signUp,
    this.orders,
    this.order,
    this.wishlist,
    this.address,
    this.settings,
    this.localeTextContinue,
    this.save,
    this.filter,
    this.apply,
    this.featured,
    this.newArrivals,
    this.sales,
    this.shareApp,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address2,
    this.email,
    this.city,
    this.pincode,
    this.location,
    this.select,
    this.selectLocation,
    this.states,
    this.state,
    this.country,
    this.countires,
    this.relatedProducts,
    this.justForYou,
    this.youMayAlsoLike,
    this.billing,
    this.shipping,
    this.discount,
    this.subtotal,
    this.total,
    this.tax,
    this.fee,
    this.orderSummary,
    this.thankYou,
    this.payment,
    this.paymentMethod,
    this.shippingMethod,
    this.billingAddress,
    this.shippingAddress,
    this.noOrders,
    this.noMoreOrders,
    this.noWishlist,
    this.noMoreWishlist,
    this.localeTextNew,
    this.otp,
    this.reset,
    this.resetPassword,
    this.newPassword,
    this.requiredField,
    this.pleaseEnter,
    this.pleaseEnterUsername,
    this.pleaseEnterPassword,
    this.pleaseEnterFirstName,
    this.pleaseEnterLastName,
    this.pleaseEnterCity,
    this.pleaseEnterPincode,
    this.pleaseEnterState,
    this.pleaseEnterValidEmail,
    this.pleaseEnterPhoneNumber,
    this.pleaseEnterOtp,
    this.pleaseEnterAddress,
    this.logout,
    this.pleaseWait,
    this.language,
    this.currency,
    this.forgotPassword,
    this.alreadyHaveAnAccount,
    this.dontHaveAnAccount,
    this.theme,
    this.light,
    this.dart,
    this.system,
    this.noProducts,
    this.noMoreProducts,
    this.chat,
    this.call,
    this.info,
    this.edit,
    this.welcome,
    this.checkout,
    this.items,
    this.couponCode,
    this.pleaseEnterCouponCode,
    this.emptyCart,
    this.youOrderHaveBeenReceived,
    this.thankYouForShoppingWithUs,
    this.thankYouOrderIdIs,
    this.youWillReceiveAConfirmationMessage,
    this.add,
    this.quantity
  });

  factory LocaleText.fromJson(Map<String, dynamic> json) => LocaleText(
    home: json["Home"] == null ? null : json["Home"],
    category: json["Category"] == null ? null : json["Category"],
    categories: json["Categories"] == null ? null : json["Categories"],
    cart: json["Cart"] == null ? null : json["Cart"],
    addToCart: json["Add to cart"] == null ? null : json["Add to cart"],
    buyNow: json["Buy now"] == null ? null : json["Buy now"],
    outOfStock: json["Out of stock"] == null ? null : json["Out of stock"],
    inStock: json["In stock"] == null ? null : json["In stock"],
    account: json["Account"] == null ? null : json["Account"],
    product: json["Product"] == null ? null : json["Product"],
    products: json["Products"] == null ? null : json["Products"],
    signIn: json["Sign In"] == null ? null : json["Sign In"],
    signUp: json["Sign Up"] == null ? null : json["Sign Up"],
    orders: json["Orders"] == null ? null : json["Orders"],
    order: json["Order"] == null ? null : json["Order"],
    wishlist: json["Wishlist"] == null ? null : json["Wishlist"],
    address: json["Address"] == null ? null : json["Address"],
    settings: json["Settings"] == null ? null : json["Settings"],
    localeTextContinue: json["Continue"] == null ? null : json["Continue"],
    save: json["Save"] == null ? null : json["Save"],
    filter: json["Filter"] == null ? null : json["Filter"],
    apply: json["Apply"] == null ? null : json["Apply"],
    featured: json["Featured"] == null ? null : json["Featured"],
    newArrivals: json["New Arrivals"] == null ? null : json["New Arrivals"],
    sales: json["Sales"] == null ? null : json["Sales"],
    shareApp: json["Share app"] == null ? null : json["Share app"],
    username: json["Username"] == null ? null : json["Username"],
    password: json["Password"] == null ? null : json["Password"],
    firstName: json["First Name"] == null ? null : json["First Name"],
    lastName: json["Last Name"] == null ? null : json["Last Name"],
    phoneNumber: json["Phone Number"] == null ? null : json["Phone Number"],
    address2: json["Address 2"] == null ? null : json["Address 2"],
    email: json["Email"] == null ? null : json["Email"],
    city: json["City"] == null ? null : json["City"],
    pincode: json["Pincode"] == null ? null : json["Pincode"],
    location: json["Location"] == null ? null : json["Location"],
    select: json["Select"] == null ? null : json["Select"],
    selectLocation: json["Select location"] == null ? null : json["Select location"],
    states: json["States"] == null ? null : json["States"],
    state: json["State"] == null ? null : json["State"],
    country: json["Country"] == null ? null : json["Country"],
    countires: json["Countires"] == null ? null : json["Countires"],
    relatedProducts: json["Related Products"] == null ? null : json["Related Products"],
    justForYou: json["Just for you"] == null ? null : json["Just for you"],
    youMayAlsoLike: json["You may also like"] == null ? null : json["You may also like"],
    billing: json["Billing"] == null ? null : json["Billing"],
    shipping: json["Shipping"] == null ? null : json["Shipping"],
    discount: json["Discount"] == null ? null : json["Discount"],
    subtotal: json["Subtotal"] == null ? null : json["Subtotal"],
    total: json["Total"] == null ? null : json["Total"],
    tax: json["Tax"] == null ? null : json["Tax"],
    fee: json["Fee"] == null ? null : json["Fee"],
    orderSummary: json["Order summary"] == null ? null : json["Order summary"],
    thankYou: json["Thank You"] == null ? null : json["Thank You"],
    payment: json["Payment"] == null ? null : json["Payment"],
    paymentMethod: json["Payment method"] == null ? null : json["Payment method"],
    shippingMethod: json["Shipping method"] == null ? null : json["Shipping method"],
    billingAddress: json["Billing address"] == null ? null : json["Billing address"],
    shippingAddress: json["Shipping address"] == null ? null : json["Shipping address"],
    noOrders: json["No orders"] == null ? null : json["No orders"],
    noMoreOrders: json["No more orders "] == null ? null : json["No more orders "],
    noWishlist: json["No wishlist"] == null ? null : json["No wishlist"],
    noMoreWishlist: json["No more wishlist "] == null ? null : json["No more wishlist "],
    localeTextNew: json["New"] == null ? null : json["New"],
    otp: json["OTP"] == null ? null : json["OTP"],
    reset: json["Reset"] == null ? null : json["Reset"],
    resetPassword: json["Reset password"] == null ? null : json["Reset password"],
    newPassword: json["New password"] == null ? null : json["New password"],
    requiredField: json["Required Field"] == null ? null : json["Required Field"],
    pleaseEnter: json["Please enter"] == null ? null : json["Please enter"],
    pleaseEnterUsername: json["Please enter username"] == null ? null : json["Please enter username"],
    pleaseEnterPassword: json["Please enter password"] == null ? null : json["Please enter password"],
    pleaseEnterFirstName: json["Please enter first name"] == null ? null : json["Please enter first name"],
    pleaseEnterLastName: json["Please enter last name"] == null ? null : json["Please enter last name"],
    pleaseEnterCity: json["Please enter city"] == null ? null : json["Please enter city"],
    pleaseEnterPincode: json["Please enter pincode"] == null ? null : json["Please enter pincode"],
    pleaseEnterState: json["Please enter state"] == null ? null : json["Please enter state"],
    pleaseEnterValidEmail: json["Please enter valid email"] == null ? null : json["Please enter valid email"],
    pleaseEnterPhoneNumber: json["Please enter phone number"] == null ? null : json["Please enter phone number"],
    pleaseEnterOtp: json["Please enter otp"] == null ? null : json["Please enter otp"],
    pleaseEnterAddress: json["Please enter address"] == null ? null : json["Please enter address"],
    logout: json["Logout"] == null ? null : json["Logout"],
    pleaseWait: json["Please wait"] == null ? null : json["Please wait"],
    language: json["Language"] == null ? null : json["Language"],
    currency: json["Currency"] == null ? null : json["Currency"],
    forgotPassword: json["Forgot password"] == null ? null : json["Forgot password"],
    alreadyHaveAnAccount: json["Already have an account"] == null ? null : json["Already have an account"],
    dontHaveAnAccount: json["Dont have an account"] == null ? null : json["Dont have an account"],
    theme: json["Theme"] == null ? null : json["Theme"],
    light: json["Light"] == null ? null : json["Light"],
    dart: json["Dart"] == null ? null : json["Dart"],
    system: json["System"] == null ? null : json["System"],
    noProducts: json["No products"] == null ? null : json["No products"],
    noMoreProducts: json["No more products"] == null ? null : json["No more products"],
    chat: json["Chat"] == null ? null : json["Chat"],
    call: json["Call"] == null ? null : json["Call"],
    info: json["Info"] == null ? null : json["Info"],
    edit: json["Edit"] == null ? null : json["Edit"],
    welcome: json["Welcome"] == null ? null : json["Welcome"],
    checkout: json["Checkout"] == null ? null : json["Checkout"],
    items: json["Items"] == null ? null : json["Items"],
    couponCode: json["Coupon code"] == null ? null : json["Coupon code"],
    pleaseEnterCouponCode: json["Please enter coupon code"] == null ? null : json["Please enter coupon code"],
    emptyCart: json["Empty Cart"] == null ? null : json["Empty Cart"],
    youOrderHaveBeenReceived: json["You order have been received"] == null ? null : json["You order have been received"],
    thankYouForShoppingWithUs: json["Thank you for shopping with us"] == null ? null : json["Thank you for shopping with us"],
    thankYouOrderIdIs: json["Thank you order id is"] == null ? null : json["Thank you order id is"],
    youWillReceiveAConfirmationMessage: json["You will receive a confirmation message"] == null ? null : json["You will receive a confirmation message"],
    add: json["Add"] == null ? null : json["Add"],
    quantity: json["Quantity"] == null ? null : json["Quantity"],
  );

  Map<String, dynamic> toJson() => {
    "Home": home == null ? null : home,
    "Category": category == null ? null : category,
    "Categories": categories == null ? null : categories,
    "Cart": cart == null ? null : cart,
    "Add to cart": addToCart == null ? null : addToCart,
    "Buy now": buyNow == null ? null : buyNow,
    "Out of stock": outOfStock == null ? null : outOfStock,
    "In stock": inStock == null ? null : inStock,
    "Account": account == null ? null : account,
    "Product": product == null ? null : product,
    "Products": products == null ? null : products,
    "Sign In": signIn == null ? null : signIn,
    "Sign Up": signUp == null ? null : signUp,
    "Orders": orders == null ? null : orders,
    "Order": order == null ? null : order,
    "Wishlist": wishlist == null ? null : wishlist,
    "Address": address == null ? null : address,
    "Settings": settings == null ? null : settings,
    "Continue": localeTextContinue == null ? null : localeTextContinue,
    "Save": save == null ? null : save,
    "Filter": filter == null ? null : filter,
    "Apply": apply == null ? null : apply,
    "Featured": featured == null ? null : featured,
    "New Arrivals": newArrivals == null ? null : newArrivals,
    "Sales": sales == null ? null : sales,
    "Share app": shareApp == null ? null : shareApp,
    "Username": username == null ? null : username,
    "Password": password == null ? null : password,
    "First Name": firstName == null ? null : firstName,
    "Last Name": lastName == null ? null : lastName,
    "Phone Number": phoneNumber == null ? null : phoneNumber,
    "Address 2": address2 == null ? null : address2,
    "Email": email == null ? null : email,
    "City": city == null ? null : city,
    "Pincode": pincode == null ? null : pincode,
    "Location": location == null ? null : location,
    "Select": select == null ? null : select,
    "Select location": selectLocation == null ? null : selectLocation,
    "States": states == null ? null : states,
    "State": state == null ? null : state,
    "Country": country == null ? null : country,
    "Countires": countires == null ? null : countires,
    "Related Products": relatedProducts == null ? null : relatedProducts,
    "Just for you": justForYou == null ? null : justForYou,
    "You may also like": youMayAlsoLike == null ? null : youMayAlsoLike,
    "Billing": billing == null ? null : billing,
    "Shipping": shipping == null ? null : shipping,
    "Discount": discount == null ? null : discount,
    "Subtotal": subtotal == null ? null : subtotal,
    "Total": total == null ? null : total,
    "Tax": tax == null ? null : tax,
    "Fee": fee == null ? null : fee,
    "Order summary": orderSummary == null ? null : orderSummary,
    "Thank You": thankYou == null ? null : thankYou,
    "Payment": payment == null ? null : payment,
    "Payment method": paymentMethod == null ? null : paymentMethod,
    "Shipping method": shippingMethod == null ? null : shippingMethod,
    "Billing address": billingAddress == null ? null : billingAddress,
    "Shipping address": shippingAddress == null ? null : shippingAddress,
    "No orders": noOrders == null ? null : noOrders,
    "No more orders ": noMoreOrders == null ? null : noMoreOrders,
    "No wishlist": noWishlist == null ? null : noWishlist,
    "No more wishlist ": noMoreWishlist == null ? null : noMoreWishlist,
    "New": localeTextNew == null ? null : localeTextNew,
    "OTP": otp == null ? null : otp,
    "Reset": reset == null ? null : reset,
    "Reset password": resetPassword == null ? null : resetPassword,
    "New password": newPassword == null ? null : newPassword,
    "Required Field": requiredField == null ? null : requiredField,
    "Please enter": pleaseEnter == null ? null : pleaseEnter,
    "Please enter username": pleaseEnterUsername == null ? null : pleaseEnterUsername,
    "Please enter password": pleaseEnterPassword == null ? null : pleaseEnterPassword,
    "Please enter first name": pleaseEnterFirstName == null ? null : pleaseEnterFirstName,
    "Please enter last name": pleaseEnterLastName == null ? null : pleaseEnterLastName,
    "Please enter city": pleaseEnterCity == null ? null : pleaseEnterCity,
    "Please enter pincode": pleaseEnterPincode == null ? null : pleaseEnterPincode,
    "Please enter state": pleaseEnterState == null ? null : pleaseEnterState,
    "Please enter valid email": pleaseEnterValidEmail == null ? null : pleaseEnterValidEmail,
    "Please enter phone number": pleaseEnterPhoneNumber == null ? null : pleaseEnterPhoneNumber,
    "Please enter otp": pleaseEnterOtp == null ? null : pleaseEnterOtp,
    "Please enter address": pleaseEnterAddress == null ? null : pleaseEnterAddress,
    "Logout": logout == null ? null : logout,
    "Please wait": pleaseWait == null ? null : pleaseWait,
    "Language": language == null ? null : language,
    "Currency": currency == null ? null : currency,
    "Forgot password": forgotPassword == null ? null : forgotPassword,
    "Already have an account": alreadyHaveAnAccount == null ? null : alreadyHaveAnAccount,
    "Dont have an account": dontHaveAnAccount == null ? null : dontHaveAnAccount,
    "Theme": theme == null ? null : theme,
    "Light": light == null ? null : light,
    "Dart": dart == null ? null : dart,
    "System": system == null ? null : system,
    "No products": noProducts == null ? null : noProducts,
    "No more products": noMoreProducts == null ? null : noMoreProducts,
    "Chat": chat == null ? null : chat,
    "Call": call == null ? null : call,
    "Info": info == null ? null : info,
    "Edit": edit == null ? null : edit,
    "Welcome": welcome == null ? null : welcome,
    "Checkout": checkout == null ? null : checkout,
    "Items": items == null ? null : items,
    "Coupon code": couponCode == null ? null : couponCode,
    "Please enter coupon code": pleaseEnterCouponCode == null ? null : pleaseEnterCouponCode,
    "Empty Cart": emptyCart == null ? null : emptyCart,
    "You order have been received": youOrderHaveBeenReceived == null ? null : youOrderHaveBeenReceived,
    "Thank you for shopping with us": thankYouForShoppingWithUs == null ? null : thankYouForShoppingWithUs,
    "Thank you order id is": thankYouOrderIdIs == null ? null : thankYouOrderIdIs,
    "You will receive a confirmation message": youWillReceiveAConfirmationMessage == null ? null : youWillReceiveAConfirmationMessage,
  };
}

class Block {
  int id;
  List<Child> children;
  List<Product> products;
  String title;
  String headerAlign;
  String titleColor;
  String style;
  String bannerShadow;
  String padding;
  String margin;
  int paddingTop;
  int paddingRight;
  int paddingBottom;
  int paddingLeft;
  int marginTop;
  int marginRight;
  int marginBottom;
  int marginLeft;
  String bgColor;
  String blockType;
  int linkId;
  double borderRadius;
  double childWidth;
  String blockBgColor;
  //String sort;
  String blockBlockType;
  String filterBy;
  double paddingBetween;
  //String blockChildWidth;
  double childHeight;
  double elevation;
  int itemPerRow;
  String saleEnds;
  int layoutGridCol;

  Block({
    this.id,
    this.children,
    this.products,
    this.title,
    this.headerAlign,
    this.titleColor,
    this.style,
    this.bannerShadow,
    this.padding,
    this.margin,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.paddingLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.marginLeft,
    this.bgColor,
    this.blockType,
    this.linkId,
    this.borderRadius,
    this.childWidth,
    this.blockBgColor,
    //this.sort,
    this.blockBlockType,
    this.filterBy,
    this.paddingBetween,
    //this.blockChildWidth,
    this.childHeight,
    this.elevation,
    this.itemPerRow,
    this.saleEnds,
    this.layoutGridCol,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    id: json["id"] == null ? null : json["id"],
    children: json["children"] == null || json["children"] == '' ? null : List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
    products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    title: json["title"] == null ? null : json["title"],
    headerAlign: json["header_align"] == null ? null : json["header_align"],
    titleColor: json["title_color"] == null ? null : json["title_color"],
    style: json["style"] == null ? null : json["style"],
    bannerShadow: json["banner_shadow"] == null ? null : json["banner_shadow"],
    padding: json["padding"] == null ? null : json["padding"],
    margin: json["margin"] == null ? null : json["margin"],
    paddingTop: json["paddingTop"] == null ? null : json["paddingTop"],
    paddingRight: json["paddingRight"] == null ? null : json["paddingRight"],
    paddingBottom: json["paddingBottom"] == null ? null : json["paddingBottom"],
    paddingLeft: json["paddingLeft"] == null ? null : json["paddingLeft"],
    marginTop: json["marginTop"] == null ? null : json["marginTop"],
    marginRight: json["marginRight"] == null ? null : json["marginRight"],
    marginBottom: json["marginBottom"] == null ? null : json["marginBottom"],
    marginLeft: json["marginLeft"] == null ? null : json["marginLeft"],
    bgColor: json["bgColor"] == null ? null : json["bgColor"],
    blockType: json["blockType"] == null ? null : json["blockType"],
    linkId: json["linkId"] == null ? null : json["linkId"],
    borderRadius: json["borderRadius"] == null ? null : json["borderRadius"].toDouble(),
    childWidth: json["childWidth"] == null ? null : json["childWidth"].toDouble(),
    blockBgColor: json["bg_color"] == null ? null : json["bg_color"],
    //sort: json["sort"] == null ? null : json["sort"],
    blockBlockType: json["block_type"] == null ? null : json["block_type"],
    filterBy: json["filter_by"] == null ? null : json["filter_by"],
    paddingBetween: json["paddingBetween"] == null ? null : json["paddingBetween"].toDouble(),
    //blockChildWidth: json["child_width"] == null ? null : json["child_width"],
    childHeight: json["childHeigth"] == null ? null : json["childHeigth"].toDouble(),
    elevation: json["elevation"] == null ? null : json["elevation"].toDouble(),
    itemPerRow: json["itemPerRow"] == null ? null : json["itemPerRow"],
    saleEnds: json["sale_ends"] == null ? null : json["sale_ends"],
    layoutGridCol: json["itemPerRow"] == null ? null : json["itemPerRow"],
  );

}

class Child {
  String title;
  String description;
  String url;
  String sort;
  String attachmentId;
  String thumb;
  String image;
  String height;
  String width;

  Child({
    this.title,
    this.description,
    this.url,
    this.sort,
    this.attachmentId,
    this.thumb,
    this.image,
    this.height,
    this.width,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    url: json["url"] == null ? null : json["url"],
    sort: json["sort"] == null ? null : json["sort"],
    attachmentId: json["attachment_id"] == null ? null : json["attachment_id"],
    thumb: json["thumb"] == null ? null : json["thumb"],
    image: json["image"] == null ? null : json["image"],
    height: json["height"] == null ? null : json["height"],
    width: json["width"] == null ? null : json["width"],
  );
}

class Settings {
  int maxPrice;
  String currency;
  int showFeatured;
  int showOnsale;
  int showLatest;
  int pullToRefresh;
  String onesignalAppId;
  String googleProjectId;
  String googleWebClientId;
  String rateAppIosId;
  String rateAppAndroidId;
  String rateAppWindowsId;
  String shareAppAndroidLink;
  String shareAppIosLink;
  String supportEmail;
  int enableProductChat;
  int enableHomeChat;
  String whatsappNumber;
  String appDir;
  int switchLocations;
  String language;
  String productShadow;
  int enableSoldBy;
  int enableSoldByProduct;
  int enableVendorChat;
  int enableVendorMap;
  int enableWallet;
  int enableRefund;
  int switchWpml;
  int switchAddons;
  int switchRewardPoints;
  int switchWebViewCheckout;

  Settings({
    this.maxPrice,
    this.currency,
    this.showFeatured,
    this.showOnsale,
    this.showLatest,
    this.pullToRefresh,
    this.onesignalAppId,
    this.googleProjectId,
    this.googleWebClientId,
    this.rateAppIosId,
    this.rateAppAndroidId,
    this.rateAppWindowsId,
    this.shareAppAndroidLink,
    this.shareAppIosLink,
    this.supportEmail,
    this.enableProductChat,
    this.enableHomeChat,
    this.whatsappNumber,
    this.appDir,
    this.switchLocations,
    this.language,
    this.productShadow,
    this.enableSoldBy,
    this.enableSoldByProduct,
    this.enableVendorChat,
    this.enableVendorMap,
    this.enableWallet,
    this.enableRefund,
    this.switchWpml,
    this.switchAddons,
    this.switchRewardPoints,
    this.switchWebViewCheckout
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    maxPrice: json["max_price"] == null ? null : json["max_price"],
    currency: json["currency"] == null ? null : json["currency"],
    showFeatured: json["show_featured"] == null ? null : json["show_featured"],
    showOnsale: json["show_onsale"] == null ? null : json["show_onsale"],
    showLatest: json["show_latest"] == null ? null : json["show_latest"],
    pullToRefresh: json["pull_to_refresh"] == null ? null : json["pull_to_refresh"],
    onesignalAppId: json["onesignal_app_id"] == null ? null : json["onesignal_app_id"],
    googleProjectId: json["google_project_id"] == null ? null : json["google_project_id"],
    googleWebClientId: json["google_web_client_id"] == null ? null : json["google_web_client_id"],
    rateAppIosId: json["rate_app_ios_id"] == null ? null : json["rate_app_ios_id"],
    rateAppAndroidId: json["rate_app_android_id"] == null ? null : json["rate_app_android_id"],
    rateAppWindowsId: json["rate_app_windows_id"] == null ? null : json["rate_app_windows_id"],
    shareAppAndroidLink: json["share_app_android_link"] == null ? null : json["share_app_android_link"],
    shareAppIosLink: json["share_app_ios_link"] == null ? null : json["share_app_ios_link"],
    supportEmail: json["support_email"] == null ? null : json["support_email"],
    enableProductChat: json["enable_product_chat"] == null ? null : json["enable_product_chat"],
    enableHomeChat: json["enable_home_chat"] == null ? null : json["enable_home_chat"],
    whatsappNumber: json["whatsapp_number"] == null ? null : json["whatsapp_number"],
    appDir: json["app_dir"] == null ? null : json["app_dir"],
    switchLocations: json["switchLocations"] == null ? null : json["switchLocations"],
    language: json["language"] == null ? null : json["language"],
    productShadow: json["product_shadow"] == null ? null : json["product_shadow"],
    enableSoldBy: json["enable_sold_by"] == null ? null : json["enable_sold_by"],
    enableSoldByProduct: json["enable_sold_by_product"] == null ? null : json["enable_sold_by_product"],
    enableVendorChat: json["enable_vendor_chat"] == null ? null : json["enable_vendor_chat"],
    enableVendorMap: json["enable_vendor_map"] == null ? null : json["enable_vendor_map"],
    enableWallet: json["enable_wallet"] == null ? null : json["enable_wallet"],
    enableRefund: json["enable_refund"] == null ? null : json["enable_refund"],
    switchWpml: json["switchWpml"] == null ? null : json["switchWpml"],
    switchAddons: json["switchAddons"] == null ? null : json["switchAddons"],
    switchRewardPoints: json["switchRewardPoints"] == null ? null : json["switchRewardPoints"],
    switchWebViewCheckout: json["switchRewardPoints"] == null ? null : json["switchWebViewCheckout"],
  );
}

class Dimensions {
  int imageHeight;
  int productSliderWidth;
  int latestPerRow;
  int productsPerRow;
  int searchPerRow;
  int productBorderRadius;
  int suCatBorderRadius;
  int productPadding;

  Dimensions({
    this.imageHeight,
    this.productSliderWidth,
    this.latestPerRow,
    this.productsPerRow,
    this.searchPerRow,
    this.productBorderRadius,
    this.suCatBorderRadius,
    this.productPadding,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    imageHeight: json["imageHeight"] == null ? null : json["imageHeight"],
    productSliderWidth: json["productSliderWidth"] == null ? null : json["productSliderWidth"],
    latestPerRow: json["latestPerRow"] == null ? null : json["latestPerRow"],
    productsPerRow: json["productsPerRow"] == null ? null : json["productsPerRow"],
    searchPerRow: json["searchPerRow"] == null ? null : json["searchPerRow"],
    productBorderRadius: json["productBorderRadius"] == null ? null : json["productBorderRadius"],
    suCatBorderRadius: json["suCatBorderRadius"] == null ? null : json["suCatBorderRadius"],
    productPadding: json["productPadding"] == null ? null : json["productPadding"],
  );
}

class User {
  Data data;
  int id;
  Caps caps;
  String capKey;
  List<String> roles;
  dynamic filter;

  User({
    this.data,
    this.id,
    this.caps,
    this.capKey,
    this.roles,
    this.filter,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    id: json["ID"] == null ? null : json["ID"],
    //caps: json["caps"] == null ? null : Caps.fromJson(json["caps"]),
    //capKey: json["cap_key"] == null ? null : json["cap_key"],
    //roles: json["roles"] == null ? null : List<String>.from(json["roles"].map((x) => x)),
    //filter: json["filter"],
  );
}

class Caps {
  bool administrator;

  Caps({
    this.administrator,
  });

  factory Caps.fromJson(Map<String, dynamic> json) => Caps(
    administrator: json["administrator"] == null ? null : json["administrator"],
  );
}

class Data {
  String id;
  String userLogin;
  String userPass;
  String userNicename;
  String userEmail;
  String userUrl;
  DateTime userRegistered;
  String userActivationKey;
  String userStatus;
  String displayName;
  bool status;
  String url;
  String avatar;
  String avatarUrl;
  int points;
  String pointsVlaue;

  Data({
    this.id,
    this.userLogin,
    this.userPass,
    this.userNicename,
    this.userEmail,
    this.userUrl,
    this.userRegistered,
    this.userActivationKey,
    this.userStatus,
    this.displayName,
    this.status,
    this.url,
    this.avatar,
    this.avatarUrl,
    this.points,
    this.pointsVlaue,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["ID"] == null ? null : json["ID"],
    userLogin: json["user_login"] == null ? null : json["user_login"],
    userPass: json["user_pass"] == null ? null : json["user_pass"],
    userNicename: json["user_nicename"] == null ? null : json["user_nicename"],
    userEmail: json["user_email"] == null ? null : json["user_email"],
    userUrl: json["user_url"] == null ? null : json["user_url"],
    userRegistered: json["user_registered"] == null ? null : DateTime.parse(json["user_registered"]),
    userActivationKey: json["user_activation_key"] == null ? null : json["user_activation_key"],
    userStatus: json["user_status"] == null ? null : json["user_status"],
    displayName: json["display_name"] == null ? null : json["display_name"],
    status: json["status"] == null ? null : json["status"],
    url: json["url"] == null ? null : json["url"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    avatarUrl: json["avatar_url"] == null ? null : json["avatar_url"],
    points: json["points"] == null ? null : json["points"],
    pointsVlaue: json["points_vlaue"] == null ? null : json["points_vlaue"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id == null ? null : id,
    "user_login": userLogin == null ? null : userLogin,
    "user_pass": userPass == null ? null : userPass,
    "user_nicename": userNicename == null ? null : userNicename,
    "user_email": userEmail == null ? null : userEmail,
    "user_url": userUrl == null ? null : userUrl,
    "user_registered": userRegistered == null ? null : userRegistered.toIso8601String(),
    "user_activation_key": userActivationKey == null ? null : userActivationKey,
    "user_status": userStatus == null ? null : userStatus,
    "display_name": displayName == null ? null : displayName,
    "status": status == null ? null : status,
    "url": url == null ? null : url,
    "avatar": avatar == null ? null : avatar,
    "avatar_url": avatarUrl == null ? null : avatarUrl,
    "points": points == null ? null : points,
    "points_vlaue": pointsVlaue == null ? null : pointsVlaue,
  };
}

class Language {
  String code;
  String id;
  String nativeName;
  String major;
  dynamic active;
  String defaultLocale;
  String encodeUrl;
  String tag;
  String translatedName;
  String url;
  String countryFlagUrl;
  String languageCode;

  Language({
    this.code,
    this.id,
    this.nativeName,
    this.major,
    this.active,
    this.defaultLocale,
    this.encodeUrl,
    this.tag,
    this.translatedName,
    this.url,
    this.countryFlagUrl,
    this.languageCode,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json["code"] == null ? null : json["code"],
    id: json["id"] == null ? null : json["id"],
    nativeName: json["native_name"] == null ? null : json["native_name"],
    major: json["major"] == null ? null : json["major"],
    active: json["active"],
    defaultLocale: json["default_locale"] == null ? null : json["default_locale"],
    encodeUrl: json["encode_url"] == null ? null : json["encode_url"],
    tag: json["tag"] == null ? null : json["tag"],
    translatedName: json["translated_name"] == null ? null : json["translated_name"],
    url: json["url"] == null ? null : json["url"],
    countryFlagUrl: json["country_flag_url"] == null ? null : json["country_flag_url"],
    languageCode: json["language_code"] == null ? null : json["language_code"],
  );
}

class Currency {
  //Languages languages;
  dynamic rate;
  String position;
  String thousandSep;
  String decimalSep;
  String numDecimals;
  String rounding;
  int roundingIncrement;
  int autoSubtract;
  String code;
  DateTime updated;
  int previousRate;

  Currency({
    //this.languages,
    this.rate,
    this.position,
    this.thousandSep,
    this.decimalSep,
    this.numDecimals,
    this.rounding,
    this.roundingIncrement,
    this.autoSubtract,
    this.code,
    this.updated,
    this.previousRate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    //languages: json["languages"] == null ? null : Languages.fromJson(json["languages"]),
    //rate: json["rate"],
    //position: json["position"] == null ? null : json["position"],
    //thousandSep: json["thousand_sep"] == null ? null : json["thousand_sep"],
    //decimalSep: json["decimal_sep"] == null ? null : json["decimal_sep"],
    //numDecimals: json["num_decimals"] == null ? null : json["num_decimals"],
    //rounding: json["rounding"] == null ? null : json["rounding"],
    //roundingIncrement: json["rounding_increment"] == null ? null : json["rounding_increment"],
    //autoSubtract: json["auto_subtract"] == null ? null : json["auto_subtract"],
    code: json["code"] == null ? null : json["code"],
    //updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    //previousRate: json["previous_rate"] == null ? null : json["previous_rate"],
  );
}
