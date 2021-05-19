import 'package:blog_aplication/pages/signinpage.dart';
import 'package:flutter/material.dart';
import './signuppage.dart';

class Welcomepage extends StatefulWidget {
  @override
  _WelcomepageState createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(75),
                      bottomRight: Radius.circular(75))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Center(
                    child: Text(
                  "Welcome to Samiul's Blog",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                )),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            boxContainer("assets/google.png", "Signup with Google", null),
            boxContainer("assets/fb.png", "Signup with Facebook", null),
            boxContainer(
                "assets/email.png", "Signup with Email", onEmailOnClick),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have An Account ?"),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Signinpage()));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  onEmailOnClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Signuppage()));
  }

  Widget boxContainer(String path, String text, onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 75,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  path,
                  height: 25,
                  width: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
