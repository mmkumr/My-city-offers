import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  GlobalKey<FormState> updateCategory = GlobalKey<FormState>();
  TextEditingController _category = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text("name of the category " + index.toString()),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          _category.text =
                              "name of the category " + index.toString();
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
                                      print(_category.text);
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
                        onPressed: () {},
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
}
