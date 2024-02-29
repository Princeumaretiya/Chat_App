import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isSingup = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signIn() async {
    try {
      setState(() {
        isSingup = true;
      });
      var auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      print(auth.user!);

      await FirebaseFirestore.instance.collection("User").doc().set({
        'email' :nameController.text,
        'password' : passwordController.text,
        'UID':auth.user!.uid
      });

      Fluttertoast.showToast(msg: 'Sing Up Sucessfull.');
      setState(() {
        isSingup = false;
      });
    } on Exception catch (e) {
      print(e);
      if (e.toString().contains('firebase_auth/email-already-in-use')) {
        Fluttertoast.showToast(msg: 'Email Already Exist');
        setState(() {
          isSingup = false;
        });
      } else if (e.toString().contains('firebase_auth/weak-password')) {
        Fluttertoast.showToast(msg: 'Weak Password');
        setState(() {
          isSingup = false;
        });
      }

      print(e);
    }
  }

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
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter email';
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
          SizedBox(height: defaultPadding / 2),
          (isSingup == true)
              ? ElevatedButton(
                  onPressed: null, child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      signIn();
                    }
                  },
                  child: Text("Sign Up".toUpperCase()),
                ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
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
