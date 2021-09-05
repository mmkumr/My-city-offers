import 'package:city_offers/cities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
  static String name = "signup";
}

class _SignupState extends State<Signup> {
  String _chosenValue = "Male";
  @override
  Widget build(BuildContext context) {
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
                    left: 20,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 10,
                    child: ListTile(
                      title: Text("Select Email"),
                    ),
                  ),
                ),
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
                      title: Text("Select Phone no."),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    //controller: _name,
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
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Cities.name);
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
}
