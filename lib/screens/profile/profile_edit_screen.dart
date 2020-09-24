import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unord/blocs/tab_bloc.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final emailController = TextEditingController();
  final surnameController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final phoneController = TextEditingController();
  final picker = ImagePicker();

  bool isProggress = false;
  int _tabIndex = 0;
  // ignore: avoid_init_to_null
  File pickedImage = null;
  // ignore: avoid_init_to_null
  Map userData = null;

  @override
  void initState() {
    super.initState();
    setFormData();
  }

  void setFormData() {
    Box db = Hive.box(boxName);
    var userData = db.get('user_data', defaultValue: null);

    if (userData != null) {
      surnameController.text = userData['username'];
      emailController.text = userData['email'];
      cityController.text = userData['city'] == null ? '-' : userData['city'];
      provinceController.text =
          userData['province'] == null ? '-' : userData['province'];
      phoneController.text =
          userData['phone_number'] == null ? '-' : userData['phone_number'];

      this.userData = userData;
    } else
      Modular.to.pop();
  }

  void showImageMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Upload foto asli kamu sendiri',
                    style: TextStyle(
                      color: _tabIndex == 0
                          ? Theme.of(context).primaryColor
                          : _tabIndex == 1
                              ? Colors.orange[700]
                              : Colors.purple[700],
                    ),
                  ),
                ),
                Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Camera'),
                      onTap: pickByCamera,
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Gallery'),
                      onTap: pickByGallery,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void pickByCamera() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    File croppedFile = await cropImage(pickedFile.path);
    setState(() {
      pickedImage = croppedFile;
    });
    Modular.to.pop();
  }

  void pickByGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile = await cropImage(pickedFile.path);
    setState(() {
      pickedImage = croppedFile;
    });
    Modular.to.pop();
  }

  Future<File> cropImage(path) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: _tabIndex == 0
            ? Theme.of(context).primaryColor
            : _tabIndex == 1
                ? Colors.orange[700]
                : Colors.purple[700],
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    return croppedFile;
  }

  void submit() async {
    String name = surnameController.text.trim();
    String city = cityController.text.replaceAll('-', '').trim();
    String province = provinceController.text.replaceAll('-', '').trim();
    String phoneNumber = phoneController.text.replaceAll('-', '').trim();

    var userData = Hive.box(boxName).get('user_data', defaultValue: null);

    // ignore: avoid_init_to_null
    String message = null;

    if (name.length < 5)
      message = "Name must at least 6 characters";
    else if (name.length > 12) message = "Name is too long";

    if (message == null) {
      setState(() {
        isProggress = true;
      });

      if (userData != null) {
        if (pickedImage != null) await uploadImage();

        Response response =
            await NetworkHelper().put('users/' + userData['id'].toString(), {
          'username': name,
          'city': city.length == 0 ? null : city,
          'province': province.length == 0 ? null : province,
          'phone_number': phoneNumber.length == 0 ? null : phoneNumber,
        });

        if (response.data['statusCode'] != null) {
          message = response.data['message'].first['messages'].first['message'];
          setState(() {
            isProggress = false;
          });
        } else {
          if (AuthService().saveUserData({'user': response.data})) {
            Fluttertoast.showToast(
                msg: 'Berhasil diubah',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black.withOpacity(.7),
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {
              isProggress = false;
            });
            Modular.to.pop();
          }
        }
      } else {
        message = 'Terjadi kesalahan, silahkan coba lagi nanti';
        setState(() {
          isProggress = false;
        });
      }
    }

    if (message != null)
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(.7),
          textColor: Colors.white,
          fontSize: 16.0);
  }

  Future<bool> uploadImage() async {
    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        pickedImage.path,
        filename: pickedImage.path.split('/').last,
      ),
      "ref": 'user',
      "refId": userData['id'],
      'field': 'image',
      'source': 'users-permissions',
    });

    Response response = await NetworkHelper().post("upload", formData);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).textSelectionColor,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<TabBloc, int>(builder: (_, tabIndex) {
                  _tabIndex = tabIndex;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: showImageMenu,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * .48,
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.width * .3,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width * .3,
                                      ),
                                      child: pickedImage != null
                                          ? Image.file(pickedImage)
                                          : userData != null
                                              ? userData['image'] != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: URLs.host
                                                              .substring(
                                                                  0,
                                                                  URLs.host
                                                                          .length -
                                                                      1) +
                                                          userData['image'][
                                                                      'formats']
                                                                  ['thumbnail']
                                                              ['url'],
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/default_user_icon.png',
                                                      fit: BoxFit.cover,
                                                    )
                                              : Image.asset(
                                                  'assets/images/default_user_icon.png',
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: tabIndex == 0
                                            ? Theme.of(context).primaryColor
                                            : tabIndex == 1
                                                ? Colors.orange[700]
                                                : Colors.purple[700],
                                        borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              .3,
                                        ),
                                        border: Border.all(
                                            width: 1, color: Colors.white),
                                      ),
                                      child: Icon(
                                        Icons.photo_camera,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 0,
                                bottom: 30,
                                left: 40,
                                right: 40,
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: tabIndex == 0
                                            ? Theme.of(context).primaryColor
                                            : tabIndex == 1
                                                ? Colors.orange[700]
                                                : Colors.purple[700],
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                    ),
                                    controller: emailController,
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                        color: tabIndex == 0
                                            ? Theme.of(context).primaryColor
                                            : tabIndex == 1
                                                ? Colors.orange[700]
                                                : Colors.purple[700],
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                    ),
                                    controller: surnameController,
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'No HP',
                                      labelStyle: TextStyle(
                                        color: tabIndex == 0
                                            ? Theme.of(context).primaryColor
                                            : tabIndex == 1
                                                ? Colors.orange[700]
                                                : Colors.purple[700],
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                    ),
                                    controller: phoneController,
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Kota',
                                      labelStyle: TextStyle(
                                        color: tabIndex == 0
                                            ? Theme.of(context).primaryColor
                                            : tabIndex == 1
                                                ? Colors.orange[700]
                                                : Colors.purple[700],
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                    ),
                                    controller: cityController,
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Provinsi',
                                      labelStyle: TextStyle(
                                        color: tabIndex == 0
                                            ? Theme.of(context).primaryColor
                                            : tabIndex == 1
                                                ? Colors.orange[700]
                                                : Colors.purple[700],
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0),
                                        ),
                                      ),
                                    ),
                                    controller: provinceController,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * .8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: tabIndex == 0
                                ? Theme.of(context).primaryColor
                                : tabIndex == 1
                                    ? Colors.orange[700]
                                    : Colors.purple[700],
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * .8,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: submit,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .8,
                                height: MediaQuery.of(context).size.width * .15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * .8),
                                ),
                                child: Center(
                                  child: Text(
                                    'UPDATE PROFILE',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        isProggress
            ? Positioned.fill(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black.withOpacity(.4),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
