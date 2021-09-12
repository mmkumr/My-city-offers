import 'package:flutter/material.dart';

class Offers extends StatefulWidget {
  final List list;
  Offers({Key? key, required this.list}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.725,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.list.length == 0 ? 0 : widget.list.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Flexible(
                child: GridTile(
                  child: Image.asset(
                    "assets/img/offer.jpg",
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
                        child: Text("Copy code"),
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
