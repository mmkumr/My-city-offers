import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EditItem extends StatefulWidget {
  EditItem({Key? key}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
}

class _EditItemState extends State<EditItem> {
  String filetype = "Image";
  String _type = "Offer";
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List _category = [
    Categories(id: 1, name: "Sports"),
    Categories(id: 2, name: "Eating"),
    Categories(id: 3, name: "Competition"),
    Categories(id: 4, name: "Shopping"),
    Categories(id: 5, name: "Others"),
  ];
  List _selectedCategories = [];
  TextEditingController _description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _description.text =
        "IIM Ahmedabad's Centre for Innovation Incubation and Entrepreneurship (CIIE) is one of India's leading centres catalyzing the entrepreneurship ecosystem in the country through its various interventions and initiatives.";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("Add item"),
      ),
      body: Container(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/img/offer.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          "Tap to change the image/video",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      backgroundColor: Colors.white,
                      buttonText: Text("Categories"),
                      title: Text("Select Categories"),
                      buttonIcon: Icon(
                        Icons.arrow_drop_down_circle,
                      ),
                      items: _category
                          .map((e) => MultiSelectItem(e, e.name))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        setState(() {
                          _selectedCategories = values;
                        });
                      },
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
                        return "The name field cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.amber,
                    child: Text("Update"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
