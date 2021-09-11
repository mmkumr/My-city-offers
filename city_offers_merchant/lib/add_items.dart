import 'dart:io';

import 'package:city_offers_merchant/cities.dart';
import 'package:city_offers_merchant/edit_item.dart';
import 'package:city_offers_merchant/main.dart';
import 'package:city_offers_merchant/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as Path;

class AddItems extends StatefulWidget {
  final List cities;
  final List areas;
  AddItems({Key? key, required this.areas, required this.cities})
      : super(key: key);

  @override
  _AddItemsState createState() => _AddItemsState();
}

class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
}

class _AddItemsState extends State<AddItems> {
  bool loading = false;
  double progress = 0;
  File? file;
  String? fileName;
  String filetype = "Image";
  String _type = "Offer";
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _valid = TextEditingController();
  List? categoriesList;
  List selectedCategoryList = [];
  String duration = "";

  List? _category = [];
  List _selectedCategories = [];
  List selectedAddress = [];
  String _uploadedFileURL = "";
  TextEditingController _description = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCategories().then((value) {
      categoriesList = value;
      for (int i = 0; i < categoriesList!.length; ++i) {
        setState(() {
          _category!.add(Categories(id: i, name: categoriesList![i]));
        });
      }
    });
    for (int i = 0; i < widget.areas.length; ++i) {
      setState(() {
        selectedAddress.add(
          {
            "city": widget.cities[i],
            "area": widget.areas[i],
          },
        );
      });
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("Add item"),
      ),
      body: loading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Center(
                child: Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: LinearProgressIndicator(
                    value: progress.toDouble(),
                    minHeight: 30,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                  ),
                  child: ListView(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (filetype == "Image") {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'jpeg'],
                            );
                            if (result != null) {
                              setState(() {
                                file = File(result.files.single.path);
                                fileName = result.files.first.name;
                              });
                            } else {
                              // User canceled the picker
                            }
                          } else if (filetype == "Video") {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['mp4', 'webm', 'mkv'],
                            );
                            if (result != null) {
                              setState(() {
                                file = File(result.files.single.path);
                                fileName = result.files.first.name;
                              });
                              final FlutterFFprobe flutterFFprobe =
                                  FlutterFFprobe();
                              MediaInformation mediaInformation =
                                  await flutterFFprobe
                                      .getMediaInformation(file!.path);
                              Map? mp = mediaInformation.getMediaProperties();
                              setState(() {
                                duration = mp!["duration"];
                              });
                            } else {
                              // User canceled the picker
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            color: Colors.white,
                            child: file != null
                                ? Center(
                                    child: Text(
                                        "Name of file: " + fileName.toString()))
                                : Icon(
                                    filetype == "Image"
                                        ? Icons.add_a_photo
                                        : Icons.videocam,
                                    color: Colors.amber,
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          focusColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'File Type',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          value: filetype,
                          elevation: 10,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          items: <String>["Image", 'Video']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              filetype = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          focusColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Type of promotion',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          value: _type,
                          elevation: 10,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          items: <String>["Offer", "Local Ad.", "Event"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _type = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white,
                          child: MultiSelectDialogField(
                            searchable: true,
                            selectedColor: Colors.black,
                            selectedItemsTextStyle:
                                TextStyle(color: Colors.white),
                            backgroundColor: Colors.white,
                            buttonText: Text("Categories"),
                            title: Text("Select Categories"),
                            buttonIcon: Icon(
                              Icons.arrow_drop_down_circle,
                            ),
                            items: _category!
                                .map((e) => MultiSelectItem(e, e.name))
                                .toList(),
                            listType: MultiSelectListType.CHIP,
                            onConfirm: (values) {
                              _selectedCategories = values;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _valid,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Validity of the ad in days",
                            labelText: "Validity of the ad in days",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xff6DFFF0),
                            )),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The days field cannot be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                            onTap: () {},
                            title: Text("Select Cities"),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Wrap(
                                children: [
                                  Text(
                                    "Selected cities: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  for (int i = 0;
                                      i < selectedAddress.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          shadowLightColor: Colors.grey,
                                          shape: NeumorphicShape.convex,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(10)),
                                          depth: 5,
                                          lightSource: LightSource.topLeft,
                                          color: Colors.amber,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Text(selectedAddress[i]["area"]),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 5,
                          controller: _description,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Description",
                            labelText: "Description",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xff6DFFF0),
                            )),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The description field cannot be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate() &&
                                _selectedCategories.isNotEmpty &&
                                file != null) {
                              for (int i = 0;
                                  i < _selectedCategories.length;
                                  ++i) {
                                setState(() {
                                  selectedCategoryList.insert(
                                      0, _selectedCategories[i].name);
                                });
                              }
                              if (filetype == "Video") {
                                if (double.parse(duration) > 30.0) {
                                  Fluttertoast.showToast(
                                      msg: "Duration is more than 30 secs.");
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Uploading files");
                                  setState(() {
                                    loading = true;
                                  });
                                  Reference storageReference = FirebaseStorage
                                      .instance
                                      .ref()
                                      .child('${Path.basename(file!.path)}');
                                  UploadTask uploadTask =
                                      storageReference.putFile(file!);
                                  uploadTask.snapshotEvents.listen((event) {
                                    setState(() {
                                      progress =
                                          event.bytesTransferred.toDouble() /
                                              event.totalBytes.toDouble();
                                    });
                                  });
                                  await (await uploadTask
                                          .whenComplete(() => null))
                                      .ref
                                      .getDownloadURL()
                                      .then((value) {
                                    setState(() {
                                      _uploadedFileURL = value;
                                      user.updatePost(
                                        _uploadedFileURL,
                                        filetype,
                                        _type,
                                        selectedCategoryList,
                                        _valid.text,
                                        selectedAddress,
                                        _description.text,
                                        user.userDetails["userId"],
                                      );
                                      loading = false;
                                    });
                                  });
                                  Fluttertoast.showToast(msg: "Uploaded file");
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Auth()),
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(msg: "Uploading files");
                                setState(() {
                                  loading = true;
                                });
                                Reference storageReference = FirebaseStorage
                                    .instance
                                    .ref()
                                    .child('${Path.basename(file!.path)}');
                                UploadTask uploadTask =
                                    storageReference.putFile(file!);
                                uploadTask.snapshotEvents.listen((event) {
                                  setState(() {
                                    progress =
                                        event.bytesTransferred.toDouble() /
                                            event.totalBytes.toDouble();
                                  });
                                });
                                await (await uploadTask
                                        .whenComplete(() => null))
                                    .ref
                                    .getDownloadURL()
                                    .then((value) {
                                  setState(() {
                                    _uploadedFileURL = value;
                                    user.updatePost(
                                      _uploadedFileURL,
                                      filetype,
                                      _type,
                                      selectedCategoryList,
                                      _valid.text,
                                      selectedAddress,
                                      _description.text,
                                      user.userDetails["userId"],
                                    );
                                    loading = false;
                                  });
                                });
                                Fluttertoast.showToast(msg: "Uploaded file");
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Auth()),
                                );
                              }
                            }
                          },
                          color: Colors.amber,
                          child: Text("Add item"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<List> getCategories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("categories").get().then((value) {
      return value.docs[0]["list"];
    });
  }
}
