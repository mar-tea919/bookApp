import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget{
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login>{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseUser> _handleSignIn() async{
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;

    try{
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();
      if(currentUser == null) return null;

      final GoogleSignInAuthentication googleAuth= await currentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      return user;
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: Text('Auth')
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24.0),
            FlatButton(
              child: Text('Sign In'),
              onPressed: () => _handleSignIn().then((FirebaseUser user){
                print(user);
                Navigator.pushReplacementNamed(context,"/");
              }).catchError((e)=>print(e))
            )
          ],
        ),
      ),
    );
  }
}