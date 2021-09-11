import 'package:main/Auth.dart';
import 'package:main/contact.dart';
import 'package:main/profile.dart';
import 'package:main/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  Sidebar({Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
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
                  child: user.status == Status.Authenticated
                      ? ClipOval(
                          child: Image.network(
                            user.userDetails["photoUrl"],
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.black,
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
            Visibility(
              visible: user.status == Status.Authenticated,
              child: ListTile(
                onTap: () {
                  user.signOut();
                  Navigator.of(context).pushReplacementNamed(Auth.name);
                },
                leading: Icon(
                  Icons.logout,
                  color: Colors.amber,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
