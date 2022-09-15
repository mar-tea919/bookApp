import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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
              leading: const Icon(Icons.menu_book),
              title: Text(data['name']),
              subtitle: Text("在庫数:${data['stock']}"),
              onTap: () {},
            );
          }).toList(),
        );
      },
    );
  }
}
