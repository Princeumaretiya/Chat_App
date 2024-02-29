import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Model.dart';
import 'Login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String email;
  final String type;
  final String image;

  const HomeScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.type,
      required this.image});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSignOut = false;

  signout() async {
    try {
      setState(() {
        isSignOut = true;
      });
      final GoogleSignInAccount? User = await GoogleSignIn().signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      setState(() {
        isSignOut = false;
      });
    } catch (e) {
      setState(() {
        isSignOut = false;
      });
    }
  }

  void initState() {
    getUserDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Welcome To HomePage')),
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(
                  "${widget.name}",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("${widget.email}"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Image.network(widget.image), //Text
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                ' My Profile ',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'LogOut',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                signout();
              },
            ),
          ],
        ),
      ),
      body: (userList.isEmpty)
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Text(userList[index].email!);
                    }),
              ],
            ),
    );
  }

  getUserDataFromFirebase() async {
    FirebaseFirestore.instance.collection('User').get().then((value) {
      print(value.docs.length);
      var data = value.docs;
      data.forEach((element) {
        setState(() {
          userList.add(UserModel.fromJson(element.data()));
        });
      });
    });
  }
}
