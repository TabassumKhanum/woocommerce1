import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config.dart';
import '../../../../models/app_state_model.dart';
import '../../../../ui/accounts/login/buttons.dart';
import '../../../blocs/vendor_bloc.dart';
import '../../../models/product_variation_model.dart';
import '../../../models/vendor_product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../resources/api_provider.dart';
import '../variation_products/vatiation_product_list.dart';
import 'attributes.dart';
import 'select_categories.dart';
import 'package:intl/intl.dart';

class EditVendorProduct extends StatefulWidget {
  final VendorBloc vendorBloc;
  final VendorProduct product;

  ProductVariation variationProduct;

  EditVendorProduct({Key key, this.vendorBloc, this.product}) : super(key: key);
  @override
  _EditVendorProductState createState() => _EditVendorProductState();
}

class _EditVendorProductState extends State<EditVendorProduct> {
  AppStateModel _appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  final _apiProvider = ApiProvider();
  File imageFile;
  bool isImageUploading = false;
  Config config = Config();

  @override
  void initState() {
    super.initState();
  }

  void handleTypeValueChanged(String value) {
    setState(() {
      widget.product.type = value;
    });
  }

  void handleStatusTypeValueChanged(String value) {
    setState(() {
      widget.product.status = value;
    });
  }

  void handlestockStatusValueChanged(String value) {
    setState(() {
      widget.product.stockStatus = value;
    });
  }

  void handlecatalogVisibilityTypeValueChanged(String value) {
    setState(() {
      widget.product.catalogVisibility = value;
    });
  }

  void handlebackOrdersValueChanged(String value) {
    setState(() {
      widget.product.backOrders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: widget.product.name,
                      decoration: InputDecoration(
                        labelText: "Product Name",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter product name";
                        }
                      },
                      onSaved: (val) =>
                          setState(() => widget.product.name = val),
                    ),

                    const SizedBox(height: 16.0),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /*  RaisedButton(
                                onPressed: _choose,
                                child: Text("Choose Image")
                            ),*/
                          ],
                        ),
                        widget.product.images?.length >= 0
                            ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: widget.product.images.length + 1,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                                itemBuilder: (BuildContext context, int index) {
                                  if (widget.product.images.length > index) {
                                    return Stack(
                                      children: <Widget>[
                                        Card(
                                            clipBehavior: Clip.antiAlias,
                                            elevation: 1.0,
                                            margin: EdgeInsets.all(4.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Image.network(
                                                widget
                                                    .product.images[index].src,
                                                fit: BoxFit.cover)),
                                        Positioned(
                                          top: -5,
                                          right: -5,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => removeImage(
                                                widget.product.images[index]),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (widget.product.images.length ==
                                          index &&
                                      isImageUploading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return Container(
                                        child: GestureDetector(
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 1.0,
                                        margin: EdgeInsets.all(4.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Image.asset(
                                          'lib/assets/images/upload_placeholder.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      onTap: () => _choose(),
                                    ));
                                  }
                                })
                            : null,
                      ],
                    ),
                    //Text(urls),

                    _buildCategoryTile(),

                    _buildAttributesTile(),

                    const SizedBox(height: 16.0),
                    Text("Type", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'simple',
                          groupValue: widget.product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          "Simple",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'grouped',
                          groupValue: widget.product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          "Grouped",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(children: <Widget>[
                      Radio<String>(
                        value: 'external',
                        groupValue: widget.product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        "External",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'variable',
                        groupValue: widget.product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        "Variable",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ]),

                    const SizedBox(height: 16.0),
                    Text("Status", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'draft',
                          groupValue: widget.product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          "Draft",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'pending',
                          groupValue: widget.product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          "Pending",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'private',
                          groupValue: widget.product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          "Private",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'publish',
                          groupValue: widget.product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          "Publish",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    Text("Catalog Visibility", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'visible',
                          groupValue: widget.product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          "Visible",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'catalog',
                          groupValue: widget.product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          "Catalog",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'search',
                          groupValue: widget.product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          "Search",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'hidden',
                          groupValue: widget.product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          "Hidden",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),

                    /* TextFormField(
                      initialValue: widget.product.stockQuantity.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Stock Quantity"),
                      onSaved: (val) => setState(
                              () => widget.product.stockQuantity = int.parse(val)),
                    ),*/

                    const SizedBox(height: 16.0),
                    Text("Stock Status", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'instock',
                          groupValue: widget.product.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          "Instock",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'outofstock',
                          groupValue: widget.product.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          "Outof Stock",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'onbackorder',
                          groupValue: widget.product.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          "On Backorder",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text("Back Orders", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'no',
                          groupValue: widget.product.backOrders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          "No",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'notify ',
                          groupValue: widget.product.backOrders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          "Notify",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'yes',
                          groupValue: widget.product.backOrders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          "Yes",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),

                    TextFormField(
                      decoration: InputDecoration(labelText: "weight"),
                      /* validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter weight';
                        }
                      },*/
                      onSaved: (val) => setState(() => widget.product.weight),
                    ),

                    TextFormField(
                      initialValue: widget.product.sku,
                      decoration: InputDecoration(
                        labelText: "sku",
                      ),
                      onSaved: (val) =>
                          setState(() => widget.product.sku = val),
                    ),

                    TextFormField(
                      initialValue: widget.product.shortDescription,
                      decoration:
                          InputDecoration(labelText: "Short Description"),
                      onSaved: (val) =>
                          setState(() => widget.product.shortDescription = val),
                    ),

                    TextFormField(
                      initialValue: widget.product.description,
                      decoration: InputDecoration(labelText: "Description"),
                      onSaved: (val) =>
                          setState(() => widget.product.description = val),
                    ),

                    TextFormField(
                      initialValue: widget.product.regularPrice,
                      decoration: InputDecoration(labelText: "Regular Price"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter regular price";
                        }
                      },
                      onSaved: (val) =>
                          setState(() => widget.product.regularPrice = val),
                    ),
                    TextFormField(
                      initialValue: widget.product.salePrice,
                      //widget.product.salePrice.toString(),
                      decoration: InputDecoration(labelText: "Sale Price"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "please enter sale price";
                        }
                      },
                      onSaved: (val) =>
                          setState(() => widget.product.salePrice = val),
                    ),

                    TextFormField(
                      initialValue: widget.product.purchaseNote,
                      decoration: InputDecoration(labelText: "Purchase Note"),
                      onSaved: (val) =>
                          setState(() => widget.product.purchaseNote),
                    ),

                    const SizedBox(height: 16.0),

                    widget.product.type == "variable" ?
                        ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          title: Text('Variations'),
                          trailing: Icon(CupertinoIcons.forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VariationProductList(
                                        vendorBloc: widget.vendorBloc,
                                        product: widget.product,
                                      ),
                                ),
                              );
                            }
                        )
                    /*FlatButton(
                       child: Text("Variations"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VariationProductList(
                                vendorBloc: widget.vendorBloc,
                              product: widget.product,
                              ),
                            ),
                          );
                        })*/
                        : Container(),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: AccentButton(
                          onPressed: () {
                            print(widget.product.name);
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              widget.vendorBloc.editProduct(widget.product);
                              Navigator.pop(context);
                            }
                          },
                          text: "Submit",
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _choose() async {
    //set state image uploading true
    //imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _upload();
    }
  }

  void _upload() async {
    setState(() {
      isImageUploading = true;
    });
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(config.url +
            "/wp-admin/admin-ajax.php?action=mstoreapp_upload_image"));
    var pic = await http.MultipartFile.fromPath("file", imageFile.path);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> fileUpload = jsonDecode(responseString);
    FileUploadResponse uploadedFile = FileUploadResponse.fromJson(fileUpload);
    print(uploadedFile.url);

    if (uploadedFile.url != null) {
      ProductImage picture = ProductImage();
      picture.src = uploadedFile.url;
      setState(() {
        widget.product.images.add(picture);
        isImageUploading = false;
      });
    }
  }

  removeImage(ProductImage imag) {
    if (widget.product.images.length > 1) {
      setState(() {
        widget.product.images.remove(imag);
      });
    } else {
      //TODO toas caanot remove only one image
    }
  }

  _buildCategoryTile() {
    String option = '';
    widget.product.categories.forEach((value) => {
      option = option.isEmpty ? value.name : option + ', ' + value.name
    });
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectCategories(product: widget.product))),
      title: Text("Categories"),
      //isThreeLine: true,
      subtitle: option.isNotEmpty ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
      trailing: Icon(CupertinoIcons.forward),
    );
  }

  _buildAttributesTile() {
    String option = '';
    widget.product.attributes.forEach((value) => {
      option = option.isEmpty ? value.name : option + ', ' + value.name
    });
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        title: Text('Attributes'),
        trailing: Icon(CupertinoIcons.forward),
        subtitle: option.isNotEmpty ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SelectAttributes(
                    vendorBloc: widget.vendorBloc,
                    product: widget.product,
                  ),
            ),
          );
        }
    );
  }

}

class FileUploadResponse {
  final String url;

  FileUploadResponse(this.url);

  FileUploadResponse.fromJson(Map<String, dynamic> json) : url = json['url'];

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}
