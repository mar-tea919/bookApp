//Package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

//UserFiles
import 'Auth.dart';
import 'UserBookstore.dart';
import 'AppendBook.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SyoribuBook());
}

class SyoribuBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final _scr=[
    FirestoreLoad(),
    BooksList(),
    Setup(),
  ];

  int _Selectedindex=0;

  void _ItemTap(int index){
    setState((){
      _Selectedindex=index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _scr[_Selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _Selectedindex,
        onTap: _ItemTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: '本棚'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: '貸出中'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: '設定'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
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

  AppendBooks appendBooks=AppendBooks();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syoribu-Library β'),
        centerTitle: true,
      ),
      body: buildBookList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_2),
        onPressed: appendBooks.scan,
      ),
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
            return SizedBox(
              height: 95,
                child:Card(
                  elevation: 3,
                  margin: const EdgeInsets.fromLTRB(20,5,20,5),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.article_outlined),
                    title: Text(data['name']),
                    subtitle: Text("在庫数:${data['stock']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => detailBook(data['name']),
                        ),
                      );
                    },
                  ),
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        tooltip: "本を借りる",
        child: const Icon(Icons.get_app),
      ),
    );
  }
}

class Setup extends StatefulWidget{
  @override
  FireSetup createState() => FireSetup();
}

class FireSetup extends State<Setup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("オプション"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('アカウント情報'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => UserLogin()));
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text('本を追加する'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FireUp()));
              },
            ),
          ),
        ],
      ),
    );
  }
}