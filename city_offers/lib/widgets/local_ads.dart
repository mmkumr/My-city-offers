import 'package:flutter/material.dart';

class LocalAds extends StatefulWidget {
  LocalAds({Key? key}) : super(key: key);

  @override
  _LocalAdsState createState() => _LocalAdsState();
}

class _LocalAdsState extends State<LocalAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.725,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 8,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Flexible(
                child: GridTile(
                  child: Image.asset(
                    "assets/img/local_ad.png",
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.white70,
                        onPressed: () {},
                        child: Text("Details"),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                  ),
                  Expanded(
                    child: Center(
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.white70,
                        onPressed: () {},
                        child: Text("Interested"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
