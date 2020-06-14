import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../config.dart';
import '../../../../ui/accounts/login/buttons.dart';
import '../../../blocs/vendor_bloc.dart';
import '../../../models/vendor_product_model.dart';
import 'package:http/http.dart' as http;
import '../../../../resources/api_provider.dart';
import 'attributes.dart';
import 'select_categories.dart';

class AddVendorProduct extends StatefulWidget {
  final vendorBloc = VendorBloc();

  AddVendorProduct({Key key, VendorBloc vendorBloc}) : super(key: key);
  @override
  _AddVendorProductState createState() => _AddVendorProductState();
}

class _AddVendorProductState extends State<AddVendorProduct> {
  VendorProduct product = new VendorProduct();
  final _formKey = GlobalKey<FormState>();
  Config config = Config();

 File imageFile;
  bool isImageUploading = false;

  @override
  void initState() {
    super.initState();
    product.type = 'simple';
    product.status = 'publish';
    product.catalogVisibility = 'visible';
    product.taxStatus = 'taxable';
    product.stockStatus = 'instock';
    product.backOrders = 'no';
    product.images = List<ProductImage>();
    product.categories = List<ProductCategory>();
    product.attributes = List<Attribute>();
  }

  void handleTypeValueChanged(String value) {
    setState(() {
      product.type = value;
    });
  }

  void handleStatusTypeValueChanged(String value) {
    setState(() {
      product.status = value;
    });
  }

  void handlecatalogVisibilityTypeValueChanged(String value) {
    setState(() {
      product.catalogVisibility = value;
    });
  }

  void handlestockStatusValueChanged(String value) {
    setState(() {
      product.stockStatus = value;
    });
  }

  void handlebackOrdersValueChanged(String value) {
    setState(() {
      product.backOrders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Products'),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Product Name",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter products name";
                        }
                      },
                      onSaved: (val) => setState(() => product.name = val),
                    ),
                    //Text(urls),

                    const SizedBox(height: 16.0),
                    Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 150,
                            height: 40,
                            child: AccentButton(
                                onPressed: _choose,
                                text: "Choose Image"),
                          ),
                        ),
                        product.images?.length >= 0
                            ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: product.images.length + 1,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                                itemBuilder: (BuildContext context, int index) {
                                  if (product.images.length != index) {
                                    return Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 1.0,
                                        margin: EdgeInsets.all(4.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Image.network(
                                            product.images[index].src,
                                            fit: BoxFit.cover));
                                  } else if (product.images.length == index &&
                                      isImageUploading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return Container();
                                  }
                                })
                            : Text("No Image Selected"),
                      ],
                    ),

                    _buildCategoryTile(),

                    _buildAttributesTile(),

                    const SizedBox(height: 16.0),
                    Text("Type", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'simple',
                          groupValue: product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          "Simple",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'grouped',
                          groupValue: product.type,
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
                        groupValue: product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        "External",
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio<String>(
                        value: 'variable',
                        groupValue: product.type,
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
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          "Draft",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'pending',
                          groupValue: product.status,
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
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          "Private",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'publish',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          "Publish",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    Text("Cataloge Visibility", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'visible',
                          groupValue: product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          "Visible",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'catalog',
                          groupValue: product.catalogVisibility,
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
                          groupValue: product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          "Search",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'hidden',
                          groupValue: product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          "Hidden",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),


                    const SizedBox(height: 16.0),
                    Text("Stock Status", style: Theme.of(context).textTheme.subhead),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'instock',
                          groupValue: product.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          "Instock",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'outofstock',
                          groupValue: product.stockStatus,
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
                          groupValue: product.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          "onbackorder",
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
                          groupValue: product.backOrders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          "No",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'notify ',
                          groupValue: product.backOrders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          "Notify",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'yes',
                          groupValue: product.backOrders,
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
                      onSaved: (val) => setState(() => product.weight),
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "sku",
                      ),
                      onSaved: (val) => setState(() => product.sku = val),
                    ),

                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Short Description"),
                      onSaved: (val) =>
                          setState(() => product.shortDescription = val),
                    ),

                    TextFormField(
                      decoration: InputDecoration(labelText: "Description"),
                      onSaved: (val) =>
                          setState(() => product.description = val),
                    ),

                    TextFormField(
                      decoration: InputDecoration(labelText: "Regular Price"),
                      /*validator: (value) {
                        if (value.isEmpty) {
                          return "please enter regular price";
                        }
                      },*/
                      onSaved: (val) =>
                          setState(() => product.regularPrice = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Sale Price"),
                      /*validator: (value) {
                        if (value.isEmpty) {
                          return "please enter sale price";
                        }
                      },*/
                      onSaved: (val) => setState(() => product.salePrice = val),
                    ),

                    TextFormField(
                      decoration: InputDecoration(labelText: "Purchase Note"),
                      onSaved: (val) =>
                          setState(() => product.purchaseNote = val),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: AccentButton(
                          onPressed: () {
                            print(product);
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              widget.vendorBloc.addProduct(product);
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
    // set state image uploading true
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
        product.images.add(picture);
        isImageUploading = false;
      });
    }
  }

  _buildCategoryTile() {
    String option = '';
    product.categories.forEach((value) =>
        {option = option.isEmpty ? value.name : option + ', ' + value.name});
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectCategories(product: product))),
      title: Text("Categories"),
      //isThreeLine: true,
      subtitle: option.isNotEmpty
          ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      trailing: Icon(CupertinoIcons.forward),
    );
  }

  _buildAttributesTile() {
    String option = '';
    product.attributes.forEach((value) =>
        {option = option.isEmpty ? value.name : option + ', ' + value.name});
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        title: Text('Attributes'),
        //dense: true,
        trailing: Icon(CupertinoIcons.forward),
        subtitle: option.isNotEmpty
            ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectAttributes(
                vendorBloc: widget.vendorBloc,
                product: product,
              ),
            ),
          );
        });
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
