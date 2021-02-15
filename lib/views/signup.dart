import 'package:anxi_pro/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:anxi_pro/services/auth.dart';
import 'package:anxi_pro/widgets/widgets.dart';

import 'dashboard.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String username, email, password;
  AuthService authService = new AuthService();
  bool _isLoading = false;

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.signUpWithEmailAndPassword(email, password).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
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
          title: appBar(context, false),
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
                              return val.isEmpty ? "Enter user name" : null;
                            },
                            decoration: InputDecoration(hintText: 'user name'),
                            onChanged: (val) {
                              username = val;
                            }),
                        //provides validators
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                            validator: (val) {
                              return val.isEmpty ? "Enter email id" : null;
                            },
                            decoration: InputDecoration(hintText: 'Email'),
                            onChanged: (val) {
                              email = val;
                            }),
                        //provides validators
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
                            }),
                        //provides validators
                        SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                            onTap: () {
                              signUp();
                            },
                            child: purpleButton(context, 'Sign Up')),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account  ",
                              style: TextStyle(fontSize: 15.5),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LogIn()));
                                },
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                      fontSize: 15.5,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ))));
  }
}
