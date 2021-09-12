import 'package:admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  GlobalKey<FormState> updateCategory = GlobalKey<FormState>();
  TextEditingController _category = TextEditingController();
  List categories = [];
  bool start = true;
  @override
  Widget build(BuildContext context) {
    if (start) {
      getCategories();
      setState(() {
        start = false;
      });
    }

    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "Categories",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text(categories[index]),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          _category.text = categories[index];
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Add category"),
                              content: Form(
                                key: updateCategory,
                                child: TextFormField(
                                  controller: _category,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Category name",
                                    labelStyle: TextStyle(
                                      color: Color(0xff6DFFF0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field cannot be empty.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    if (updateCategory.currentState!
                                        .validate()) {
                                      categories[index] = _category.text;
                                      user.updateCategory(categories);
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                          msg: "Category added");
                                    }
                                  },
                                  child: Text("Add"),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("cancel"),
                                ),
                              ],
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Categories(),
                            ),
                          );
                        },
                        color: Colors.amber,
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          categories.remove(categories[index]);
                          user.updateCategory(categories);
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Categories(),
                            ),
                          );
                          Fluttertoast.showToast(msg: "Category deleted");
                        },
                        color: Colors.amber,
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  getCategories() {
    final user = Provider.of<UserProvider>(context);
    user.getCategories().then((value) {
      if (mounted)
        setState(() {
          categories = value;
        });
    });
  }
}
