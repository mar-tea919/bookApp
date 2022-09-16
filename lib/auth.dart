import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

class Auth extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    const providerConfigs=[EmailProviderConfiguration(),GoogleProviderConfiguration(clientId: '...')];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      initialRoute: FirebaseAuth.instance.currentUser==null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in':(context){
          return SignInScreen(
           providerConfigs: providerConfigs,
           actions: [
             AuthStateChangeAction<SignedIn>((context, state) {
               Navigator.pushReplacementNamed(context, '/profile');
             }),

           ],
          );
        },
        '/profile':(context){
          return ProfileScreen(
            providerConfigs: providerConfigs,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
    );
  }
}