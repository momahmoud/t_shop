import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/providers/admin_mode.dart';
import 'package:hi/providers/modal_hud.dart';
import 'package:hi/screens/admin/admin_screen.dart';
import 'package:hi/screens/signup_screen.dart';
import 'package:hi/services/auth.dart';
import 'package:hi/utilities/common.dart';
import 'package:hi/widgets/custom_textfield.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  Auth _auth = Auth();
  bool stayLogin = false;
  final adminPassword = '1234567';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(
          context,
        ).isLoading,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 25),
              child: Container(
                height: MediaQuery.of(context).size.height * .2,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/buy.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Text(
                        'Tasouk',
                        style: TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    CustomTextFormField(
                        hint: 'Email',
                        icon: Icons.email,
                        onClick: (value) => _email = value),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                        hint: 'Password',
                        icon: Icons.lock,
                        onClick: (value) => _password = value),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Checkbox(
                            value: stayLogin,
                            onChanged: (value) {
                              setState(() {
                                stayLogin = value;
                              });
                            }),
                        Text(
                          'Remmeber Me',
                          style:
                              GoogleFonts.oxygen(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Builder(
                      builder: (context) => FlatButton(
                        textColor: Colors.white,
                        onPressed: () {
                          if (stayLogin == true) {
                            stayUserLogin();
                          }
                          _submit(context);
                        },
                        child: Text(
                          'Log in',
                          style: GoogleFonts.oxygen(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        color: Colors.cyan,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(horizontal: 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Don\'t have an account?',
                  style: GoogleFonts.oxygen(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SignUpScreen.routeName);
                  },
                  child: Text(
                    ' Sign up',
                    style: GoogleFonts.oxygen(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<AdminMode>(context, listen: false)
                            .changeIsAdmin(true);
                      },
                      child: Text('i\'m an admin',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oxygen(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? mainColor
                                  : Colors.black)),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<AdminMode>(context, listen: false)
                            .changeIsAdmin(false);
                      },
                      child: Text('i\'m a user',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oxygen(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? Colors.black
                                  : mainColor)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    final modalHud = Provider.of<ModalHud>(context, listen: false);
    modalHud.changeIsLoading(true);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          try {
            await _auth.signIn(_email.trim(), _password.trim());
            modalHud.changeIsLoading(false);
            Navigator.of(context).pushNamed(AdminScreen.id);
          } on FirebaseAuthException catch (e) {
            modalHud.changeIsLoading(true);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(e.message)));
          }
        } else {
          modalHud.changeIsLoading(false);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Something went wrong !')));
        }
      } else {
        try {
          await _auth.signIn(_email.trim(), _password.trim());
          modalHud.changeIsLoading(false);
          Navigator.of(context).pushNamed(HomeScreen.id);
        } on FirebaseAuthException catch (e) {
          modalHud.changeIsLoading(true);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
    }
    modalHud.changeIsLoading(false);
  }

  void stayUserLogin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kStayLogin, stayLogin);
  }
}
