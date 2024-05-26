// screens/login_screen.dart
import 'package:arjunagym/Provider/FirebaseResources.dart';
import 'package:arjunagym/Screens/HomeScreen.dart';
import 'package:arjunagym/Screens/ScaleUtils.dart';
import 'package:arjunagym/Screens/SignUpScreen.dart';
import 'package:arjunagym/Screens/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;
  bool _isLoading = false;
  final _loginkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();

  final TextEditingController pass = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _togglepasswordview() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  @override
  Widget build(BuildContext context) {
    ScaleUtils.init(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Form(
        key: _loginkey,
        child: Container(
          margin: EdgeInsets.fromLTRB(38*ScaleUtils.horizontalScale,38*ScaleUtils.verticalScale,38*ScaleUtils.horizontalScale,0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(25 * ScaleUtils.scaleFactor)),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                0, 32 * ScaleUtils.verticalScale, 0, 32 * ScaleUtils.verticalScale),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    hintText: 'Enter Your Email',
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(
                        fontSize: 16 * ScaleUtils.scaleFactor,
                        fontWeight: FontWeight.w500,
                        ),
                    labelStyle: TextStyle(
                      fontSize: 16 * ScaleUtils.scaleFactor,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(

                            width: 2 * ScaleUtils.horizontalScale)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(

                          width: 2 * ScaleUtils.horizontalScale),
                    ),
                    suffixIcon: Icon(
                      Icons.email,

                    )),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter email address';
                  } else if (!RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16 * ScaleUtils.verticalScale,
              ),
              TextFormField(
                controller: pass,
                decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    floatingLabelStyle: TextStyle(
                        fontSize: 16 * ScaleUtils.scaleFactor,
                        fontWeight: FontWeight.w500,
                      ),
                    labelStyle:
                    TextStyle(fontSize: 16 * ScaleUtils.scaleFactor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(

                            width: 2 * ScaleUtils.horizontalScale)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(

                          width: 2 * ScaleUtils.horizontalScale),
                    ),
                    suffix: InkWell(
                      onTap: _togglepasswordview,
                      child: Icon(
                        _isHidden
                            ? Icons.visibility_off
                            : Icons.visibility,

                      ),
                    ),
                    errorMaxLines: 2),
                obscureText: _isHidden,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the Password';
                  } else if (!RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                      .hasMatch(value)) {
                    return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 9 * ScaleUtils.verticalScale,
              ),
              InkWell(
                onTap: () {
                  if (email.text.isNotEmpty) {
                    auth.sendPasswordResetEmail(
                        email: email.text);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          Future.delayed(Duration(seconds: 13),
                                  () {
                                Navigator.of(context).pop(true);
                              });
                          return AlertDialog(
                            title: Center(
                              child: Column(
                                children: [
                                  Lottie.asset(
                                      'assets/email.json',
                                      height:
                                      0.15 * ScaleUtils.verticalScale,
                                      width: 0.5 *
                                          ScaleUtils.horizontalScale),
                                  Text(
                                    'Password Reset',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                        22 * ScaleUtils.scaleFactor,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'An email has been sent to ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                                Text(
                                  '${email.text}',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                Text(
                                  'Click the link in the email to change password.',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10 * ScaleUtils.verticalScale,
                                ),
                                Text(
                                  'Didn\'t get the email?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                Text(
                                  'Check entered email or check spam folder.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                                TextButton(
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                        fontSize:
                                        20 * ScaleUtils.scaleFactor,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                          context, true);
                                    }),
                              ],
                            ),
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Center(
                                child: Text(
                                  'Error',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize:
                                      24 * ScaleUtils.scaleFactor,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ),
                              content: Text(
                                'Enter email in the email field or check if the email is valid.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16 * ScaleUtils.scaleFactor),
                              ),
                              actions: [
                                TextButton(
                                    child: Text('Retry'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context, true);
                                    })
                              ]);
                        });
                  }
                },
                child: Text(
                  'Forgot Password?',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 16 * ScaleUtils.scaleFactor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 29 * ScaleUtils.verticalScale,
              ),
              Center(
                child: (_isLoading)
                    ? Loading()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(

                  ),
                  onPressed: () {
                    if (_loginkey.currentState!
                        .validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      authMethods
                          .logInByEmail(
                          email.text, pass.text)
                          .then((user) async {
                        if (user != null) {
                          print(user);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen()),
                                  (route) => false);
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext
                                context) {
                                  return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          'Error',
                                          style: TextStyle(
                                              color: Colors
                                                  .red,
                                              fontSize: 24 *
                                                  ScaleUtils.scaleFactor,
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                      ),
                                      content: Text(
                                        '       There is no user record \n corresponding to the identifier.',
                                        style: TextStyle(
                                            fontSize: 16*ScaleUtils.scaleFactor),
                                      ),
                                      actions: [
                                        TextButton(
                                            child: Text(
                                                'Retry'),
                                            onPressed:
                                                () {
                                              Navigator.pop(
                                                  context,
                                                  true);
                                            })
                                      ]);
                                });
                          }
                          showToast('Login failed');
                        }
                      });
                    }
                  },
                  child: Padding(
                    padding:  EdgeInsets.fromLTRB(
                        80*ScaleUtils.horizontalScale, 8*ScaleUtils.verticalScale, 80*ScaleUtils.horizontalScale, 8*ScaleUtils.verticalScale),
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18*ScaleUtils.scaleFactor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20*ScaleUtils.verticalScale,
              ),
              Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                      fontSize: 20*ScaleUtils.scaleFactor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20*ScaleUtils.verticalScale,
              ),

              SizedBox(height: 20*ScaleUtils.verticalScale),
              Column(
                children: [
                  Text(
                    "Don't have account?",
                    style: TextStyle(
                        fontSize: 15*ScaleUtils.scaleFactor,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  MaterialButton(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18*ScaleUtils.scaleFactor),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignUpScreen()));
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
