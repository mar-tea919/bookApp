import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class Barcode extends StatefulWidget {
  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Barcode Scanner Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: scan,
                    child: Text("Scan"),
                  ),
                ),
              ),
              Text(readData),
            ],
          ),
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