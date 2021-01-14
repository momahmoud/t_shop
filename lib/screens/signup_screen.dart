import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/providers/modal_hud.dart';
import 'package:hi/screens/home_screen.dart';
import 'package:hi/screens/login_screen.dart';
import 'package:hi/services/auth.dart';
import 'package:hi/utilities/common.dart';
import 'package:hi/widgets/custom_textfield.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  static const routeName = 'signup';
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  final Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: mainColor,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<ModalHud>(context,).isLoading,
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
                      CustomTextFormField(hint: 'Name', icon: Icons.person),
                      SizedBox(
                        height: 10,
                      ),
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
                      SizedBox(height: 20),
                      Builder(
                        builder: (context) => FlatButton(
                          textColor: Colors.white,
                          onPressed: () async {
                            final modalHud = Provider.of<ModalHud>(context,listen: false);
                            modalHud.changeIsLoading(true);
                            if (_formKey.currentState.validate()) {
                              try{
                              _formKey.currentState.save();
                              await _auth.signUp(_email.trim(), _password.trim());
                               modalHud.changeIsLoading(false);
                              Navigator.of(context).pushNamed(HomeScreen.id);
                              } on FirebaseAuthException catch(e){
                                 modalHud.changeIsLoading(true);
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message))
                                );
                              } 
                            }
                             modalHud.changeIsLoading(false);
                          },
                          child: Text(
                            'Sign up',
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
                  Text(' have an account?'),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.oxygen(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      
    );
  }
}
