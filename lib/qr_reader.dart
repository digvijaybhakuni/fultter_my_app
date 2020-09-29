import 'dart:io';
import 'dart:typed_data';

import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DisplayQRData extends StatelessWidget {
  final String qrData;

  const DisplayQRData(this.qrData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Display QR DATA')),
        body: Container(
          child: Padding(
            child: Text(qrData),
            padding: EdgeInsets.all(5.0),
          ),
        ));
  }
}

class QRReader {
  static Future<String> scanCam() async {
    String barcode = await scanner.scan();
    print(" scan barcode " + barcode);
    return barcode;
  }

  static Future<String> scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    print(" scan Photo " + barcode);
    return barcode;
  }

  Future<String> scanPath(String path) async {
    String barcode = await scanner.scanPath(path);
    print(" scan Path "+ barcode);
    return barcode;
  }

  Future<String> scanBytes() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    Uint8List bytes = file.readAsBytesSync();
    String barcode = await scanner.scanBytes(bytes);
    print(" scan Bytes "+ barcode);
    return barcode;
  }

  Future<Uint8List> generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    // this.setState(() => this.bytes = result);
    return result;
  }


}
