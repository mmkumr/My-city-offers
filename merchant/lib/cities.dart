import 'package:algolia/algolia.dart';
import 'add_items.dart';
import 'package:flutter/material.dart';

class Cities extends StatefulWidget {
  Cities({Key? key}) : super(key: key);

  @override
  _CitiesState createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {
  String search = "";

  final Algolia _algoliaApp = Algolia.init(
    applicationId: 'IGCCEEE2PN', //ApplicationID
    apiKey:
        'adcbe1179ab3d23997ae867d2d604e4b', //search-only api key in flutter code
  );

  String _searchTerm = "";

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("cities").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  List<String> selectedCities = <String>[];
  List<String> selectedAreas = <String>[];
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(
          child: TextFormField(
            //controller: _name,
            initialValue: " ",
            onChanged: (word) {
              setState(() {
                _searchTerm = word;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              icon: Icon(Icons.search),
              hintText: "Type your location",
              labelStyle: TextStyle(
                color: Color(0xff6DFFF0),
                fontWeight: FontWeight.bold,
                fontSize: 10,
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Select the Areas for Ad.",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(_operation(_searchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Start Typing",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  List<AlgoliaObjectSnapshot>? currSearchStuff = snapshot.data;

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:

                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return CustomScrollView(
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {},
                                        leading: Checkbox(
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                                  getColor),
                                          value: selectedAreas.contains(
                                              currSearchStuff![index]
                                                  .data["name"]),
                                          onChanged: (value) =>
                                              changeSelectedCity(
                                                  currSearchStuff[index]
                                                      .data["name"],
                                                  currSearchStuff[index]
                                                      .data["parent"]),
                                        ),
                                        title: Center(
                                          child: Text(
                                            currSearchStuff[index]
                                                .data["parent"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Area Name: " +
                                              currSearchStuff[index]
                                                  .data["name"],
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                    ],
                                  );
                                },
                                childCount: currSearchStuff!.length,
                              ),
                            ),
                          ],
                        );
                  }
                }
              },
            ),
          ),
          MaterialButton(
            color: Colors.amber,
            onPressed: () {
              if (selectedAreas.isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddItems(areas: selectedAreas, cities: selectedCities),
                  ),
                );
              }
            },
            child: Text(
              "Next",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  changeSelectedCity(String area, String city) {
    if (selectedAreas.contains(area)) {
      setState(() {
        selectedAreas.remove(area);
        selectedCities.remove(city);
      });
    } else {
      setState(() {
        selectedAreas.insert(0, area);
        selectedCities.insert(0, city);
      });
    }
  }
}
