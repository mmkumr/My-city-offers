import 'package:city_offers/contact.dart';
import 'package:city_offers/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sidebar extends StatefulWidget {
  Sidebar({Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Profile.name);
              },
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                accountName: Text(
                  "John Wick",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  "doglover@gmail.com",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, Profile.name);
              },
              leading: Icon(
                Icons.person,
                color: Colors.amber,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.addressCard,
                color: Colors.amber,
              ),
              title: Text(
                "About us",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.share,
                color: Colors.amber,
              ),
              title: Text(
                "Share app",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.fileSignature,
                color: Colors.amber,
              ),
              title: Text(
                "Privacy Policies",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(Contact.name);
              },
              leading: Icon(
                Icons.phone,
                color: Colors.amber,
              ),
              title: Text(
                "Contact US",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      elevation: 20,
    );
  }
}
