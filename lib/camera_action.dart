import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_app/view_camera_preview.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

  @override
  void initState() {
    super.initState();

    availableCameras().then((camerasList) {
      this.cameras = camerasList;
      if (this.cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });
        this._initCameraController(this.cameras[selectedCameraIdx]);
      } else {
        print("No camera available");
      }
    }).catchError((err) => print(err));
  }

  @override
  void dispose() {
    super.dispose();
    this.controller?.dispose();
  }

  Future<String> getImagePath() async {
    return join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (this.controller != null) {
      await controller?.dispose();
    }

    this.controller =
        CameraController(cameraDescription, ResolutionPreset.medium);

    this.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (this.controller.value.hasError) {
        print("this.controller.value.hasError");
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await this.controller.initialize();
    } on CameraException catch (e) {
      print("CameraException ${e.description}");
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (this.controller == null || !this.controller.value.isInitialized) {
      return Center(
        child: const Text(
          'Loading',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    final cameraView = AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          cameraView,
          RaisedButton(
            child: Text("Take Pick"),
            onPressed: () async {
              print("clicked");
              final path = await this.getImagePath();
              await controller.takePicture(path);
              this.imagePath = path;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: path),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return _cameraPreviewWidget();
    return Scaffold(
      body: _cameraPreviewWidget(),
      appBar: AppBar(
        title: Text('Camera'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.backspace),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
