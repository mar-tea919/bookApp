import 'package:firebase_auth/firebase_auth.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
        brightness: Brightness.dark,
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

//ホーム、Firestoreで得た情報を表示する
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
              title: const Text('My 本棚'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BooksList(),
                    ),
                );
              },
            ),
            ListTile(
              title: const Text('書籍の登録'),
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
              title: const Text('設定'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Setup(),
                    ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.menu),onPressed: () {}),
        title: const Text('Syoribu 蔵書管理App'),
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
          return const Text("通信エラー");
        }

        if(!snapshot.hasData){
          return const Center(
              child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document){
            Map<String,dynamic> data=document.data()! as Map<String,dynamic>;
            return ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(data['bookname']),
              subtitle: Text("在庫数:${data['zaiko']}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => detailBook(data['bookname']),
                    ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}


//本を追加するページ(Cloud FirestoreのAdd部分)
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
        title: const Text("書籍追加ページ"),
      ),
      body:Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "書籍名",
                  hintText: "ここに書籍名を入力 *",
                  icon: Icon(Icons.article_outlined),
              ),
              controller: bookController,
            ),
            TextField(
              maxLength: 3,
              decoration: const InputDecoration(
                  labelText: "在庫数",
                  hintText: "書籍の在庫数を入力 *",
                  icon: Icon(Icons.bar_chart_outlined),
              ),
              controller: zaikoController,
            ),
            RaisedButton(
                child: const Text('決定'),
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

class BooksList extends StatefulWidget{
  @override
  _MybooksList createState() => _MybooksList();
}

class _MybooksList extends State<BooksList>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My 本棚'),
        centerTitle: true,
      ),
      body: buildBookList(),
    );
  }

  Widget buildBookList(){

    final Stream<QuerySnapshot> _bookStream=FirebaseFirestore.instance.collection('books').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _bookStream,
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return const Text("エラーが発生しました。");
        }

        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document){
            Map<String,dynamic> data=document.data()! as Map<String,dynamic>;
            return ListTile(
              leading: const Icon(Icons.article_outlined),
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

class detailBook extends StatefulWidget{

  detailBook(this.name);
  String? name;

  @override
  _MydetailBook createState() => _MydetailBook(name);
}

class _MydetailBook extends State<detailBook>{

  _MydetailBook(this.name);
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name!),
        centerTitle: true,
      ),
      body: Center(
        child: Text(name!),
      ),
    );
  }
}


class Setup extends StatefulWidget{
  @override
  FireSetup createState() => FireSetup();
}

class FireSetup extends State<Setup>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("あ"),
      ),
    );
  }
}