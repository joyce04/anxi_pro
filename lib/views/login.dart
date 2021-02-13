import 'package:anxi_pro/color_scheme.dart';
import 'package:anxi_pro/helper/functions.dart';
import 'package:flutter/material.dart';
import 'package:anxi_pro/services/auth.dart';
import 'package:anxi_pro/views/signup.dart';
import 'package:anxi_pro/widgets/widgets.dart';

import 'dashboard.dart';

class LogIn extends StatefulWidget {
  @override
  __LogInState createState() => __LogInState();
}

class __LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthService authService = new AuthService();

  bool _isLoading = false;

  logIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.signInWithEmailAndPassword(email, password).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: purple,
        appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: _isLoading
            ? Container(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : Form(
                key: _formKey,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Spacer(),
                        TextFormField(
                            validator: (val) {
                              return val.isEmpty
                                  ? "Enter email"
                                  : null; //TODO email format validation
                            },
                            decoration: InputDecoration(hintText: 'Email'),
                            onChanged: (val) {
                              email = val;
                            }), //provides validators
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.isEmpty ? "Enter Password" : null;
                            },
                            decoration: InputDecoration(hintText: 'password'),
                            onChanged: (val) {
                              password = val;
                            }), //provides validators
                        SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                            onTap: () {
                              logIn();
                            },
                            child: purpleButton(context, 'Log In')),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?  ",
                              style: TextStyle(fontSize: 15.5),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 15.5,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ))));
  }
}
