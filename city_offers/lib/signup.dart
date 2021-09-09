import 'package:city_offers/Auth.dart';
import 'package:city_offers/cities.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';

class Signup extends StatefulWidget {
  final String area;
  final String city;
  Signup({Key? key, required this.area, required this.city}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
  static String name = "signup";
}

class _SignupState extends State<Signup> {
  String _chosenValue = "Male";
  int _phone = 0;
  @override
  initState() {
    super.initState();
    phone();
  }

  TextEditingController _age = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Signup",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Form(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                  ),
                  child: Card(
                    shadowColor: Colors.grey,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      onTap: () async {
                        await MobileNumber.getSimCards!.then((value) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Select phone no."),
                              content: Container(
                                height: h * 0.3,
                                width: w * 0.3,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        color: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              _phone = int.parse(value[index]
                                                  .number
                                                  .toString());
                                            });
                                          },
                                          title: Text(
                                            value[index].number.toString(),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          );
                        });
                      },
                      title: Text(
                        _phone == 0 ? "Select Phone no." : _phone.toString(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: _age,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      icon: Icon(
                        FontAwesomeIcons.idCard,
                        color: Colors.white,
                      ),
                      hintText: "Age",
                      labelStyle: TextStyle(
                        color: Color(0xff6DFFF0),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The name field cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    top: 20,
                  ),
                  child: DropdownButtonFormField<String>(
                    focusColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Gender',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    value: _chosenValue,
                    elevation: 10,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    items: <String>["Male", 'Female', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _chosenValue = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: MaterialButton(
                    height: 60,
                    minWidth: 150,
                    onPressed: () async {
                      if (_phone != 0 && _age.text.isNotEmpty) {
                        if (await user.updateData(
                              user.user.photoURL.toString(),
                              user.user.displayName.toString(),
                              user.user.email.toString(),
                              _phone.toString(),
                              _age.text,
                              widget.area,
                              widget.city,
                              _chosenValue,
                              user.user.uid,
                            ) ==
                            true) {
                          Fluttertoast.showToast(msg: "Login Successfull");
                          Navigator.of(context).pushReplacementNamed(Auth.name);
                        } else {
                          Fluttertoast.showToast(msg: "Login failed");
                          user.user.delete();
                          Navigator.pushReplacementNamed(context, Auth.name);
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Fill all the fields");
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Text(
                          "Create Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  phone() async {
    if (await MobileNumber.hasPhonePermission == false) {
      MobileNumber.requestPhonePermission;
    }
  }
}
