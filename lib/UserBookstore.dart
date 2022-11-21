import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BooksList extends StatefulWidget{
  @override
  _MybooksList createState() => _MybooksList();
}

class _MybooksList extends State<BooksList>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My 本棚'),
        centerTitle: true,
      ),
      body: buildBookList(),
    );
  }

  Widget buildBookList(){

    final String? uid=FirebaseAuth.instance.currentUser?.uid.toString();
    if(uid!=null){
      final Stream<QuerySnapshot> _bookStream=FirebaseFirestore.instance.collection(uid).snapshots();
      
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
              return SizedBox(
                  height: 130,
                  child: Card(
                      margin: EdgeInsets.fromLTRB(10,5,10,5),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(
                          data['name'],
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text("在庫数:${data['stock']}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => returnBook(data['name']),
                              )
                          );
                        },
                      )
                  )
              );
            }).toList(),
          );
        },
      );
    }else{
      return Center(
        child: Container(
          child: Text(
              'ログインしていません',
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
      );
    }
  }
}


class returnBook extends StatefulWidget{
  returnBook(this.data);
  String data;

  @override
  _returnBookState createState() => _returnBookState(data);
}

class _returnBookState extends State<returnBook>{

  final String? uid=FirebaseAuth.instance.currentUser?.uid.toString();

  _returnBookState(this.data);
  String data;

  void removeFromUser(){
    if(uid!=null){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('data'),
            ElevatedButton(
                onPressed: () {
                  removeFromUser();
                  Navigator.pop(context);
                },
                child: Text('返却')
            )
          ],
        ),
      ),
    );
  }

}