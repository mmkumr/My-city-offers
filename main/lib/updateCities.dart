import 'package:algolia/algolia.dart';
import 'package:main/Auth.dart';
import 'package:main/providers/user_provider.dart';
import 'package:main/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateCities extends StatefulWidget {
  UpdateCities({Key? key}) : super(key: key);

  @override
  _UpdateCitiesState createState() => _UpdateCitiesState();
  static String name = "UpdateCities";
}

class _UpdateCitiesState extends State<UpdateCities> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
      body: StreamBuilder<List<AlgoliaObjectSnapshot>>(
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
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                );
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
                            return DisplaySearchResult(
                              name: currSearchStuff![index].data["name"],
                              parent: currSearchStuff[index].data["parent"],
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
    );
  }
}

class DisplaySearchResult extends StatelessWidget {
  final String name;
  final String parent;

  DisplaySearchResult({
    Key? key,
    required this.name,
    required this.parent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return InkWell(
      onTap: () {
        user.updateArea(parent, name);
        Navigator.pushReplacementNamed(context, Auth.name);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "$parent",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Area Name: $name",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
