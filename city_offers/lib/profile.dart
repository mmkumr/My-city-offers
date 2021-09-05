import 'package:city_offers/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
  static String name = "profile";
}

class _ProfileState extends State<Profile> {
  String _chosenValue = "Male";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    //controller: _name,
                    initialValue: "John wick",
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      icon: Icon(Icons.person),
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
                    left: 20,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: ListTile(
                      title: Text("doglover@gmail.com"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                  ),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text("8337908779"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    //controller: _name,
                    initialValue: "22",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      icon: Icon(FontAwesomeIcons.idCard),
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
                    decoration: InputDecoration(
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
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(Home.name);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blue,
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
}
