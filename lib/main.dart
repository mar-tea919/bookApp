import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xFF212121),
        accentColor: const Color(0xFFffffff),
        canvasColor: const Color(0xFF303030),
      ),
      home: FirestoreLoad(),
    );
  }
}

class FirestoreLoad extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class FireUp extends StatefulWidget{
  @override
  AppendBooks createState() => AppendBooks();
}

class _MyFirestorePageState extends State<FirestoreLoad> {
  // ドキュメント情報を入れる箱を用意
  final Stream<QuerySnapshot> _bookStream=FirebaseFirestore.instance.collection('books').snapshots();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text('My 本棚'),
              onTap: () {},
            ),
            ListTile(
              title: Text('書籍の登録'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FireUp(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Third'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.menu),onPressed: () {}),
        title: Text('Syoribu 蔵書管理App Beta'),
        centerTitle: true,
      ),
      body: buildBookList(),
    );
  }

  Widget buildBookList(){

    return StreamBuilder<QuerySnapshot>(
      stream: _bookStream,
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("エラーが発生しました。");
        }

        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document){
            Map<String,dynamic> data=document.data()! as Map<String,dynamic>;
            return ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text(data['bookname']),
              subtitle: Text("在庫数:${data['zaiko']}"),
              onTap: () {},
            );
          }).toList(),
        );
      },
    );
  }
}

class AppendBooks extends State<FireUp>{
  @override
  Widget build(BuildContext context) {

    CollectionReference bk=FirebaseFirestore.instance.collection('books');

    final bookController=TextEditingController();
    final zaikoController=TextEditingController();

    Future<void> addFirestoredata(){
      return bk.add({
        'bookname':bookController.text,
        'zaiko' : zaikoController.text
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("書籍追加ページ"),
      ),
      body:Column(
        children: [
          TextField(
            controller: bookController,
          ),
          TextField(
            controller: zaikoController,
          ),
          RaisedButton(
              child: Text('決定'),
              onPressed: () {
                //Firebaseにアップしてから戻る
                addFirestoredata();
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }
}