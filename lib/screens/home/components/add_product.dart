import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/services/databaseServices.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../constants.dart';
import '../../../size_config.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String title, description;
  bool processing = false;
  String imageUrl;
  int price;
  int rating;
  bool isPopular;
  List<String> images = [];
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  File imageFile;
  PickedFile image;
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  pickImage() async {
    final _picker = ImagePicker();

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      if (!mounted) return;
      setState(() {
        imageFile = File(image.path);
      });
    } else {
      print('Grant Permissions and try again');
    }
  }

  uploadImageToDb(PickedFile image, String name) async {
    final _storage = firebase_storage.FirebaseStorage.instance;
    if (image != null) {
      //Upload to Firebase
      var snapshot =
          await _storage.ref().child('products/' + name).putFile(imageFile);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      print("downl;oadUrl:");
      print(downloadUrl);
      if (!mounted) return;
      setState(() {
        imageUrl = downloadUrl;
      });
      print("imageUrl:");
      print(imageUrl);
    } else {
      print('No Path Received');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Container(
            color: kPrimaryColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  getProportionateScreenWidth(20),
                  getProportionateScreenWidth(30),
                  getProportionateScreenWidth(20),
                  getProportionateScreenHeight(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(56),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: kPrimaryColor,
                      onPressed: () {},
                      child: Text(
                        "AushadhE",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          // if all are valid then go to success screen
                          setState(() {
                            processing = true;
                          });

                          await uploadImageToDb(image, title);

                          await DatabaseServices().addProduct(title,
                              description, price, rating, imageUrl, isPopular);
                          KeyboardUtil.hideKeyboard(context);
                          setState(() {
                            processing = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false);
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      )),
                ],
              ),
            ),
          ),
        ),
        body: processing
            ? Center(
                child: SpinKitFadingCircle(color: kPrimaryColor, size: 100))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Text(
                      "Add a New Product",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Please make sure you fill all the details correctly.",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                keyboardType: TextInputType.name,
                                onSaved: (newValue) => title = newValue,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(error: "Please enter Title");
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(error: "Please enter Title");
                                    return "";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Title",
                                  hintText: "Enter Title of Product",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                keyboardType: TextInputType.streetAddress,
                                onSaved: (newValue) => description = newValue,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(
                                        error: "Please enter Description");
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(error: "Please enter Description");
                                    return "";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Description",
                                  hintText: "Enter Description of Product",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (newValue) =>
                                    price = int.parse(newValue),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(error: "Please enter Price");
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(error: "Please enter Price");
                                    return "";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Price",
                                  hintText: "Enter Price of Product",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                keyboardType: TextInputType.name,
                                onSaved: (newValue) =>
                                    rating = int.parse(newValue),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(error: "Please enter Rating");
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(error: "Please enter Rating");
                                    return "";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Rating",
                                  hintText: "Enter Rating of Product",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                keyboardType: TextInputType.name,
                                onSaved: (newValue) {
                                  if (newValue == "true") {
                                    setState(() {
                                      isPopular = true;
                                    });
                                  } else {
                                    setState(() {
                                      isPopular = false;
                                    });
                                  }
                                },
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(
                                        error: "Please enter isPopular Status");
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(
                                        error: "Please enter isPopular Status");
                                    return "";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "isPopular",
                                  hintText: "Mention either true or false",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FormError(errors: errors),
                          ),
                          SizedBox(height: 10),
                          (image != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    child: Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 20),
                            child: DefaultButton(
                              text: "Upload Image!",
                              press: () => pickImage(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class FirebaseStorage {}
