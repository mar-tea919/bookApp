import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syoribu Books',
      theme: ThemeData(
        brightness:Brightness.dark,
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xFF212121),
        accentColor: const Color(0xFFffffff),
        canvasColor: const Color(0xFF303030),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key ,key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _navIndex=0;
  var _label='';
  List<Widget> titles=[nowLent(),Lent(),others()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syoribu Books App'),
      ),

      body: titles[_navIndex],

      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.computer),
              title: Text('貸出状況'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_rounded),
              title: Text('貸出・返却'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              title: Text('設定'),
            ),
          ],
          currentIndex: _navIndex,
          onTap: (int index){
            setState(() {
              _navIndex=index;
            });
          },
      ),
    );
  }
}

class nowLent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(child: Text('Test Page1')),
    );
  }
}

class Lent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(child: Text('Test Page2')),
    );
  }
}

class others extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(child: Text('Test Page3')),
    );
  }
}