import 'package:main/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
  static String name = "/contact";
}

class _ContactState extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _body = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(
          child: Text("Contact US"),
        ),
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Container(
            child: Column(
              children: <Widget>[
                new ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.deepOrange,
                  ),
                  title: Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Text(
                        "Phone",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text("+918337908779"),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                new ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  title: Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text("mmkumr@gmail.com"),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                new ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: Colors.greenAccent,
                  ),
                  title: Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Text(
                        "Address",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text("Brahmapur, Ganjam, Odisha"),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      child: loading == true
                          ? CircularProgressIndicator()
                          : Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Contact Form",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        14.0, 0.0, 14.0, 8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.grey.withOpacity(0.2),
                                      elevation: 0.0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: TextFormField(
                                          controller: _email,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
                                            icon: Icon(Icons.email),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "The Email field cannot be empty";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        14.0, 8.0, 14.0, 8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.grey.withOpacity(0.2),
                                      elevation: 0.0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: TextFormField(
                                          controller: _subject,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Subject",
                                            icon: Icon(Icons.subject),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "The Subject field cannot be empty";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        14.0, 8.0, 14.0, 8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.grey.withOpacity(0.2),
                                      elevation: 0.0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: TextFormField(
                                          maxLines: 4,
                                          controller: _body,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Body",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "The body field cannot be empty";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        14.0, 8.0, 14.0, 8.0),
                                    child: Material(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Color(0xff38AFF9),
                                        elevation: 0.0,
                                        child: MaterialButton(
                                          onPressed: () {},
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            "Send",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
