import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import './auth.dart';
import './bookstore.dart';
import './barcode.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'MyBooks'),
          BottomNavigationBarItem(icon: Icon(Icons.tune),label: 'Customize'),
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.menu),onPressed: () {}),
        title: const Text('Syoribu-Library β'),
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


//本を追加するページ(Cloud FirestoreのAdd部分)
class AppendBooks extends State<FireUp>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formkey=GlobalKey<FormState>();

    CollectionReference bk=FirebaseFirestore.instance.collection('books');

    final bookController=TextEditingController();
    final zaikoController=TextEditingController();

    Future<void> addFirestoredata(){
      return bk.add({
        'name':bookController.text,
        'stock' : zaikoController.text,
        'isLent': 0,
        'writer': "Null",
        'barcode' :readData,
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("書籍追加ページ"),
      ),
      body:Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),

              child:Form(
                key: _formkey,
                child:TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value){
                    if(value!.isEmpty){
                      return '値を入力してください';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus();
                  },
                  decoration: const InputDecoration(
                    labelText: "書籍名",
                    hintText: "ここに書籍名を入力 *",
                    icon: Icon(Icons.article_outlined),
                  ),
                  controller: bookController,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Form(
                child:TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return '値を入力してください';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                  decoration: const InputDecoration(
                    labelText: "在庫数",
                    hintText: "書籍の在庫数を入力",
                    icon: Icon(Icons.bar_chart_outlined),
                  ),
                  controller: zaikoController,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    width: 130,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: scan,
                      child: Text('バーコード読込'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 80,
                  width: 200,
                  child: Text(
                    readData,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 180,
              height: 60,
              child: ElevatedButton(
                  child: const Text('決定'),
                  onPressed: () {
                    //Firebaseにアップしてから戻る
                    if(_formkey.currentState!.validate()){
                      addFirestoredata();
                      Navigator.pop(context);
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  String readData = "";
  String typeData = "";

  Future scan() async {
    try {
      var scan = await BarcodeScanner.scan();
      setState(() => {
        readData = scan.rawContent,
        typeData = scan.format.name,
      });
    }
    on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          readData = 'Camera permissions are not valid.';
        });
      }
      else {
        setState(() => readData = 'Unexplained error : $e');
      }
    }
    on FormatException{
      setState(() => readData = 'Failed to read (I used the back button before starting the scan).');
    } catch (e) {
      setState(() => readData = 'Unknown error : $e');
    }
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
                    context, MaterialPageRoute(builder: (context) => Auth()));
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