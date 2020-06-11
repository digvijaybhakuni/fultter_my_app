import 'package:flutter/material.dart';

import 'package:my_app/camera_action.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/view_camera_preview.dart';

void main() => runApp(MyApp());

@immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{
    '/': (context) => MyHomePage(title: 'DB Works X'),
    '/camera': (context) => TakePictureScreen(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        initialRoute: '/',
        routes: routes);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar '));

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        //backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              widget.scaffoldKey.currentState.showSnackBar(widget.snackBar);
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Next page',
            onPressed: () {
              print('Next Page');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Counter:',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text('$_counter',
                      style: Theme.of(context).textTheme.headline4)
                ],
              ),
            ),
            RaisedButton.icon(
              onPressed: () {
                print('try to open camera');
                // Navigator.pushNamed(context, '/camera');
                optionsCameraDialogBox(context);
              },
              icon: Icon(Icons.camera,
                  color: Theme.of(context).accentIconTheme.color),
              label: Text("Get Image",
                  style: Theme.of(context).accentTextTheme.button),
              color: Theme.of(context).accentColor,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future takeImageWithCamera(context) async {
  final image = await ImagePicker().getImage(source: ImageSource.camera);
  // final image = await ImagePicker.pickImage(source: ImageSource.camera);
  print(image);
  Navigator.pop(context);
  openImageTaken(context, image.path);
}

Future takeImageWithGallery(context) async {
  final image = await ImagePicker().getImage(source: ImageSource.gallery);
  print(image);
  Navigator.pop(context);
  openImageTaken(context, image.path);
}

void openImageTaken(context, path) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DisplayPictureScreen(imagePath: path),
    ),
  );
}

Future<void> optionsCameraDialogBox(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('My Take a picture'),
                  onTap: () async {
                    final _ = await Navigator.pushNamed(context, '/camera');
                    print(_);
                    Navigator.pop(context);
                    return _;
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: () => takeImageWithCamera(context)),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: () => takeImageWithGallery(context),
                ),
              ],
            ),
          ),
        );
      });
}
