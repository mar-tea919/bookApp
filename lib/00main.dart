// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// Future<void> main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Syoribu Books',
//       theme: ThemeData(
//         brightness:Brightness.dark,
//         primarySwatch: Colors.blueGrey,
//         primaryColor: const Color(0xFF212121),
//         accentColor: const Color(0xFFffffff),
//         canvasColor: const Color(0xFF303030),
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key ,key}) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   var _navIndex=0;
//   var _label='';
//   List<Widget> titles=[nowLent(),Lent(),others()];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('処理部図書館 Beta'),
//       ),
//
//       body: titles[_navIndex],
//
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.computer),
//             label:'貸出状況',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assignment_rounded),
//             label:'蔵書一覧',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.apps),
//             label:'設定',
//           ),
//         ],
//         currentIndex: _navIndex,
//         onTap: (int index){
//           setState(() {
//             _navIndex=index;
//           });
//         },
//       ),
//     );
//   }
// }
//
// class nowLent extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return const Scaffold(
//       body: Center(child: Text('Test Page1')),
//     );
//   }
// }
//
// class Lent extends StatelessWidget{
//   final firestore=FirebaseFirestore.instance;
//   @override
//   Widget build(BuildContext context){
//     return const Scaffold(),
//     );
//   }
// }
//
// class others extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return const Scaffold(
//       body: Center(child: Text('Test Page3')),
//     );
//   }
// }
//
//
// //コードを一時的に逃がしてます