import 'package:city_offers/Auth.dart';
import 'package:city_offers/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
  static String name = "profile";
}

class _ProfileState extends State<Profile> {
  String? _chosenValue;
  int _phone = 0;
  TextEditingController _name = TextEditingController();
  TextEditingController _age = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    phone();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    _name.text = user.userDetails["name"];
    _age.text = user.userDetails["age"];
    _phone = int.parse(user.userDetails["phone"]);
    _chosenValue = user.userDetails["gender"];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Text("Signup"),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Form(
            key: _form,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: ClipOval(
                      child: Image.network(
                        user.userDetails["photoUrl"],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: "Full Name",
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
                    top: 20,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.email),
                      title: Text(user.userDetails["email"]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Card(
                    elevation: 5,
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
                      leading: Icon(Icons.phone_android),
                      title: Text(
                        _phone == 0
                            ? user.userDetails["phone"]
                            : _phone.toString(),
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
                        return "The Age field cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Gender',
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
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        user
                            .updateData(
                          user.userDetails["photoUrl"],
                          _name.text,
                          user.userDetails["email"],
                          _phone.toString(),
                          _age.text,
                          user.userDetails["area"],
                          user.userDetails["city"],
                          _chosenValue.toString(),
                          user.userDetails["userId"],
                        )
                            .then((value) {
                          Fluttertoast.showToast(msg: "Details updated");
                        });
                        Navigator.of(context).pushReplacementNamed(Auth.name);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Text(
                          "Update Details",
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
