import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

String info='';
String email='';
String password='';

class UserLogin extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            return AccountsInfoPage(email);
          }
          return LoginPage();
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  @override
  Widget build(BuildContext context) {
    var _screenSize=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: _screenSize.height*0.1,
                width: _screenSize.width*0.8,
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'メールアドレス'),
                  onChanged: (String value){
                    setState(() {
                      email=value;
                    });
                  },
                ),
              ),
              Container(
                  height: _screenSize.height*0.1,
                  width: _screenSize.width*0.8,
                  margin: EdgeInsets.all(10),
                  child:TextFormField(
                    decoration: InputDecoration(labelText: 'パスワード'),
                    onChanged: (String value){
                      setState(() {
                        password=value;
                      });
                    },
                  )
              ),
              Container(
                height: _screenSize.height*0.05,
                width: _screenSize.width*0.3,
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try{
                      final FirebaseAuth auth=FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                          email: email,
                          password: password
                      );
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => UserLogin()
                        ),
                      );
                    }catch (e){
                      setState(() {
                        info="ログイン失敗";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountsInfoPage extends StatefulWidget{
  AccountsInfoPage(this.email);
  String? email;

  @override
  _AccountsInfoPageState createState() => _AccountsInfoPageState(email);
}

class _AccountsInfoPageState extends State<AccountsInfoPage>{
  _AccountsInfoPageState(this.email);
  String? email;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン情報'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("メールアドレス:${email!}"),
            ElevatedButton(
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  email='';
                  password='';
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => UserLogin()
                    ),
                  );
                },
                child: Text('ログアウト')
            ),
          ],
        ),
      ),
    );
  }
}