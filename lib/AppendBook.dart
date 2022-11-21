import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

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

    final booknameController=TextEditingController();
    final stockController=TextEditingController();

    Future<void> addFirestoredata(){
      return bk.add({
        'name':booknameController.text,
        'stock' : stockController.text,
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
                  controller: booknameController,
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
                  controller: stockController,
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
          readData = 'カメラの権限が与えられていません';
        });
      }
      else {
        setState(() => readData = '不明なエラーです : $e');
      }
    }
    on FormatException{
      setState(() => readData = '読み込みに失敗しました');
    } catch (e) {
      setState(() => readData = '不明なエラーです : $e');
    }
  }
}
