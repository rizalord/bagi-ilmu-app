import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unord/blocs/education_bloc.dart';
import 'package:unord/blocs/subject_bloc.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/services/auth_service.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final picker = ImagePicker();
  List<Map> educations = [
        {'id': 0, 'text': 'Pendidikan'},
      ],
      subjects = [
        {'id': 0, 'text': 'Mapel'},
      ];
  int pickedEducation = 0, pickedSubject = 0;
  bool isProggress = false;
  int _tabIndex = 0;
  // ignore: avoid_init_to_null
  File pickedImage = null;
  // ignore: avoid_init_to_null

  @override
  void initState() {
    super.initState();
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
                    'Upload catatan kamu',
                    style: TextStyle(
                      color: Color(0xFFFE4014),
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
    if (croppedFile != null)
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
        CropAspectRatioPreset.ratio5x3,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Color(0xFFFE4014),
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.ratio5x3,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    return croppedFile;
  }

  void submit() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    // ignore: avoid_init_to_null
    String message = null;
    if (pickedImage == null)
      message = "Upload image first";
    else if (title.length < 5)
      message = "Title must at least 6 characters";
    else if (pickedEducation == 0)
      message = "Select education first";
    else if (pickedSubject == 0) message = "Select subject first";

    if (message == null) {
      setState(() {
        isProggress = true;
      });

      var userData = Hive.box(boxName).get('user_data', defaultValue: null);

      if (userData != null) {
        Response response = await NetworkHelper().post('notes', {
          'title': title,
          'description': description,
          'subject': pickedSubject,
          'education': pickedEducation,
          'user': userData['id'],
        });

        await uploadImage(response.data['id']);

        if (response.data['statusCode'] != null) {
          message = response.data['message'].first['messages'].first['message'];
          setState(() {
            isProggress = false;
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Berhasil menambah',
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

  Future<bool> uploadImage(int id) async {
    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        pickedImage.path,
        filename: pickedImage.path.split('/').last,
      ),
      "ref": 'note',
      "refId": id,
      'field': 'image',
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
              'Tambah Catatan',
              style: TextStyle(color: Color(0xFFFA694C)),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).textSelectionColor,
            iconTheme: IconThemeData(color: Color(0xFFFA694C)),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * .55,
                  color: Color(0xFFF9F9F9),
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  child: pickedImage == null
                      ? Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: showImageMenu,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFFFE4014).withOpacity(.41),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      color: Color(0xFFFE4014),
                                      size: 80,
                                    ),
                                    Text(
                                      'Upload',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Color(0xFFFE4014),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              width: 1,
                              color: Color(0xFFFE4014).withOpacity(.41),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Image.file(
                                    File(pickedImage.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: GestureDetector(
                                  onTap: showImageMenu,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: Color(0xFFFFFFFF).withOpacity(.81),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            Color(0xFFFE4014).withOpacity(.41),
                                      ),
                                    ),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.pencilAlt,
                                        size: 16,
                                        color:
                                            Color(0xFFFE4014).withOpacity(.9),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFFE4014).withOpacity(.68),
                    ),
                  ),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      hintText: "Judul",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xFF4A4A4A).withOpacity(.5),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * .4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFFE4014).withOpacity(.68),
                    ),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      hintText: "Deskripsi",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xFF4A4A4A).withOpacity(.5),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        padding: EdgeInsets.symmetric(
                          horizontal: 13,
                        ),
                        width:
                            (MediaQuery.of(context).size.width * .5) - 15 - 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFFE4014).withOpacity(.68),
                          ),
                        ),
                        child: BlocBuilder<EducationBloc, List<Map>>(
                          builder: (_, educationBloc) {
                            List<Map> newData = List.from(educations);
                            newData.addAll(educationBloc);

                            return DropdownButton(
                              underline: Container(),
                              isExpanded: true,
                              hint: Text("Pilih Jenjang Pendidikan"),
                              value: pickedEducation,
                              items: newData.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value['text']),
                                  value: value['id'],
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  pickedEducation = value;
                                });
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        padding: EdgeInsets.symmetric(
                          horizontal: 13,
                        ),
                        width:
                            (MediaQuery.of(context).size.width * .5) - 15 - 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFFE4014).withOpacity(.68),
                          ),
                        ),
                        child: BlocBuilder<SubjectBloc, List<Map>>(
                          builder: (_, subjectBloc) {
                            List<Map> newData = List.from(subjects);
                            newData.addAll(subjectBloc);

                            return DropdownButton(
                              underline: Container(),
                              isExpanded: true,
                              hint: Text("Pilih Mapel"),
                              value: pickedSubject,
                              items: newData.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value['text']),
                                  value: value['id'],
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  pickedSubject = value;
                                });
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFFE4014).withOpacity(.68),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFFE4014).withOpacity(.68),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: submit,
                      child: Container(
                        height: MediaQuery.of(context).size.width * .15,
                        child: Center(
                          child: Text(
                            'Tambah',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
