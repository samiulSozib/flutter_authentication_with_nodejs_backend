import 'dart:convert';

import 'package:blog_aplication/NetworkHandler.dart';
import 'package:blog_aplication/pages/signinpage.dart';
import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  @override
  _SignuppageState createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  bool visibility = true;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
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
                    "Signup With Email",
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
                emailTextField(),
                passwordTextField(),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    await checkUser();
                    if (_globalKey.currentState.validate() && validate) {
                      print("validate");
                      Map<String, String> data = {
                        "username": _usernameController.text,
                        "email": _emailController.text,
                        "password": _passwordController.text
                      };
                      print(data);
                      var response =
                          await networkHandler.post("/user/register", data);
                      print(response.statusCode);
                      setState(() {
                        _usernameController.text = "";
                        _emailController.text = "";
                        _passwordController.text = "";
                        circular = false;
                      });
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Signinpage()));
                      }
                    } else {
                      setState(() {
                        circular = false;
                      });
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
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        validate = false;
        errorText = "Username can not be empty";
      });
    } else {
      var response = await networkHandler
          .get("/user/chceckusername/${_usernameController.text}");

      if (response["Status"]) {
        setState(() {
          validate = false;
          errorText = "Username alrady used";
        });
      } else {
        setState(() {
          validate = true;
        });
      }
    }
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
                  hintText: "Enter Unique Username"),
            )
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return "Email can not be empty";
                }
                if (!value.contains("@")) {
                  return "Email is not valid";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  hintText: "Enter Email"),
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
              validator: (value) {
                if (value.isEmpty) {
                  return "Password can not be empty";
                }
                if (value.length < 8) {
                  return "Password must be greater than 8 chars";
                }
                return null;
              },
              decoration: InputDecoration(
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
                  hintText: "Enter more then 7 digit Password"),
              obscureText: visibility,
            )
          ],
        ),
      ),
    );
  }
}
