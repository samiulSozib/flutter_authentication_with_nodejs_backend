import 'dart:convert';

import 'package:blog_aplication/NetworkHandler.dart';
import 'package:blog_aplication/pages/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './homepage.dart';

class Signinpage extends StatefulWidget {
  @override
  _SigninpageState createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  bool visibility = true;
  final _globalKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  NetworkHandler networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _globalKey,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Center(
                      child: Text(
                    "Sign In With Email",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                SizedBox(
                  height: 50,
                ),
                usernameTextField(),
                passwordTextField(),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    Map<String, String> data = {
                      "username": _usernameController.text,
                      "password": _passwordController.text
                    };

                    var response =
                        await networkHandler.post("/user/login", data);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      print(output["token"]);
                      setState(() {
                        validate = true;
                        circular = false;
                      });
                      await storage.write(key: "token", value: output["token"]);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage()),
                          (route) => false);
                    } else {
                      validate = false;
                      circular = false;
                      errorText = "Authentication Fail";
                    }
                  },
                  child: circular
                      ? CircularProgressIndicator()
                      : Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 100,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New User ?"),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Signuppage()));
                        },
                        child: Text("Sign Up",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                  errorText: validate ? null : errorText,
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  hintText: "Enter Username"),
            )
          ],
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: visibility,
              decoration: InputDecoration(
                  errorText: validate ? null : errorText,
                  suffixIcon: IconButton(
                      icon: Icon(
                          visibility ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      }),
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  hintText: "Enter Password"),
            )
          ],
        ),
      ),
    );
  }
}
