import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../HomeScreen.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLogin = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signIn() async {
    try {
      setState(() {
        isLogin = true;
      });
      var auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      print(auth.user!);

      await FirebaseFirestore.instance.collection("User").doc().set({
        'email': nameController.text,
        'password': passwordController.text,
        'UID': auth.user!.uid
      });

      Fluttertoast.showToast(msg: 'Login Sucessfull.');
      setState(() {
        isLogin = false;
      });
    } on Exception catch (e) {
      if (e.toString().contains('firebase_auth/invalid-credential')) {
        Fluttertoast.showToast(msg: 'Invalid credential.Please try again.');
        setState(() {
          isLogin = false;
        });
      }
      print(e);
    }
  }

  bool isGoogleLogin = false;
  bool SingIn = false;

  signInWithGoogle() async {
    try {
      setState(() {
        isGoogleLogin = true;
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser?.email);

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isGoogleLogin = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(
                name: googleUser!.displayName!,
                email: googleUser!.email,
                type: 'GoogleLogIn',
                image: googleUser.photoUrl!,
              )));
      // final GoogleSignInAccount? User = await GoogleSignIn().signOut();
    } catch (e) {
      setState(() {
        isGoogleLogin = false;
      });
      print(e);
    }
  }

  // bool isSignOutwithGoogle = false;
  //
  // SignOutwithGoogle() async {
  //   try {
  //     setState(() {
  //       isSignOutwithGoogle = true;
  //     });
  //     final GoogleSignInAccount? User = await GoogleSignIn().signOut();
  //     setState(() {
  //       isSignOutwithGoogle = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isSignOutwithGoogle = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter email';
              }
            },
            controller: nameController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter password';
                }
              },
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          (isLogin == true)
              ? ElevatedButton(
                  onPressed: null, child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      signIn();
                    }
                  },
                  child: Text(
                    "Login".toUpperCase(),
                  ),
                ),
          SizedBox(height: defaultPadding),
          (isGoogleLogin == true)
              ? ElevatedButton(
                  onPressed: null, child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    signInWithGoogle();
                  },
                  child: Text(
                    "Login With Google".toUpperCase(),
                  ),
                ),
          SizedBox(height: defaultPadding),
          // (isSignOutwithGoogle == true)
          //     ? ElevatedButton(
          //         onPressed: null, child: CircularProgressIndicator())
          //     : ElevatedButton(
          //         onPressed: () {
          //           SignOutwithGoogle();
          //         },
          //         child: Text(
          //           "SignOut",
          //           style: TextStyle(fontSize: 20),
          //         ),
          //         style: ElevatedButton.styleFrom(
          //           shape: StadiumBorder(),
          //           padding: EdgeInsets.symmetric(vertical: 16),
          //           backgroundColor: Colors.purple,
          //         ),
          //       ),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
