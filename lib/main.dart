import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Image Labeling',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange, fontFamily: 'Bebas-Regular'),
        home: MyHomePage(title: 'Image Labeling'),
        routes: <String, WidgetBuilder>{
          //5
          '/screen1': (BuildContext context) => new about(), //6
          '/home': (BuildContext context) => new MyHomePage(), //6
          //
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void about(BuildContext context) {
    print("Button 1"); //1
    Navigator.of(context).pushNamed('/screen1'); //2
  }

  File img;
  String found = 'No Result';

  void getimageandLabel(File imagefile) async {
    String result = '';
    final visionimage = FirebaseVisionImage.fromFile(imagefile);
    final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();

    final List<ImageLabel> labels =
        await imageLabeler.processImage(visionimage);
    for (ImageLabel label in labels) {
      final String text = label.text;
      final double confidence = label.confidence * 100;
      result += '\n${confidence.toStringAsFixed(0)}% there is a $text';
      if (result.length > 0)
        setState(() {
          this.found = result;
          this.img = imagefile;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Image Labeling'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            color: Colors.white,
            onPressed: () {
              about(context);
            },
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            this.img == null
                ? Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      'image_labeling@2x.png',
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  )
                : Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(
                      this.img,
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
            Text(
              'Results : ',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bebas-Regular',
                  color: Colors.deepOrange),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                this.found,
                style: TextStyle(fontFamily: 'Roboto-Medium', fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
              heroTag: 1,
              icon: Icon(Icons.camera),
              label: Text('Camera'),
              onPressed: () {
                setState(() async {
                  img = await ImagePicker.pickImage(source: ImageSource.camera);
                  getimageandLabel(img);
                });
              }),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          FloatingActionButton.extended(
              heroTag: 2,
              icon: Icon(Icons.image),
              label: Text('Galerie'),
              onPressed: () {
                setState(() async {
                  img =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  getimageandLabel(img);
                });
              })
        ],
      ),
    );
  }
}

class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

class _aboutState extends State<about> {
  void button2(BuildContext context) {
    print("Button 2");
    Navigator.of(context).pop(true);
  }

  _launchURL() async {
    const url = 'https://github.com/AlaaDz31';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext ctct) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('About'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.asset(
                  'download.png',
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      'With ML Kits image labeling APIs, you can recognize entities in an image without having to provide any additional contextual metadata, using either an on-device API or a cloud-based API. mage labeling gives you insight into the content of images. When you use the API, you get a list of the entities that were recognized: people, things, places, activities, and so on. Each label found comes with a score that indicates the confidence the ML model has in its relevance. With this information, you can perform tasks such as automatic metadata generation and content moderation.',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Text(
                        'Visit my Github',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto-Medium',
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {_launchURL();},
                    ),
                   
                    Icon(
                      MdiIcons.githubCircle,
                      color: Colors.deepOrange,
                      size: 40,
                    ),
                   
                  ],
                ),
              )
            ])));
  }
}
