import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fretboard Drills',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Quicksand',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          title: TextStyle(fontSize: 90.0, fontWeight: FontWeight.bold),
          headline: TextStyle(fontSize: 25.0),
        ),
      ),
      home: MyHomePage(title: 'Fretboard Drills'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentNote = 'note';
  String _currentString = 'string';
  String _currentFinger = 'finger';

  bool _preferenceWindow = false;

  bool _isGenerating = false;
  int _speed = 20;

  String _chosenDrill = 'Chromatic';
  bool _isChromatic = true;
  String _chosenKey = 'C';

  var _notes = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];
  var _strings = [
    '1st String',
    '2nd String',
    '3rd String',
    '4th String',
    '5th String',
    '6th String'
  ];
  var _fingers = ['Index', 'Middle', 'Ring', 'Pinky'];

  var _scales = {"Major":[0,2,4,5,7,9,11],"Pentatonic":[0,3,5,7,10],"Blues (Minor)":[0,3,5,6,7,10],"Melodic Minor":[0,2,3,5,7,9,11],"Harmonic Minor":[0,2,3,5,7,8,11]};

  void _generateNote() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_isChromatic) {
        _currentNote = _notes[(new Random()).nextInt(_notes.length)];
      } else {
        _currentNote = _notes[_scales[_chosenDrill][(new Random()).nextInt(_scales[_chosenDrill].length)]];
      }
      
      _currentString = _strings[(new Random()).nextInt(_strings.length)];
      _currentFinger = _fingers[(new Random()).nextInt(_fingers.length)];
    });
  }

  void _generator() {
    if (_isGenerating) {
      new Timer(new Duration(milliseconds: (10000 / _speed).round()), () {
        if (_isGenerating) {
          _generateNote();
          _generator();
        }
      });
    }
  }

  void _toggleGenerator() {
    setState(() {
      _isGenerating = !_isGenerating;
      if (_isGenerating) {
        _generateNote();
        _generator();
      }
    });
  }

  bool _isTempoInRange(tempo) {
    int max = 100;
    int min = 1;
    return min <= tempo && tempo <= max;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text(widget.title),
      ),
      */
      body: Center(
        child: Column(children: <Widget>[
          /* Align(alignment: Alignment.topRight,
             child: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert),)), */
          Expanded(
            flex: 7,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('$_currentNote',
                      style: Theme.of(context).textTheme.title),
                  Text('$_currentString',
                      style: Theme.of(context).textTheme.headline),
                  Text('$_currentFinger',
                      style: Theme.of(context).textTheme.headline),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: _preferenceWindow
                  ? Container(
                      color: Theme.of(context).accentColor,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.settings),
                              color: Colors.white,
                              iconSize: 30.0,
                              onPressed: () => {
                                setState(() {
                                  _preferenceWindow = !_preferenceWindow;
                                })
                              },
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton<String>(
                                    value: _chosenDrill,
                                    /*
                                    underline: Container(
                                      height: 1,
                                      color: Colors.black,
                                    ), */
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _chosenDrill = newValue;
                                        _isChromatic = _chosenDrill == 'Chromatic';
                                      });
                                    },
                                    items: <String>[
                                      'Chromatic',
                                      'Major',
                                      'Pentatonic',
                                      'Blues (Minor)',
                                      'Melodic Minor',
                                      'Harmonic Minor'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  _isChromatic ? Container() : DropdownButton<String>(
                                    value: _chosenKey,
                                    /*
                                    underline: Container(
                                      height: 1,
                                      color: Colors.black,
                                    ), */
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _chosenKey = newValue;
                                      });
                                    },
                                    items: <String>[
                                      'C',
                                      'C#',
                                      'D',
                                      'D#',
                                      'E',
                                      'F',
                                      'F#',
                                      'G',
                                      'G#',
                                      'A',
                                      'A#',
                                      'B'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ]),
                          ]))
                  : Container(
                      color: Theme.of(context).accentColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.settings),
                            color: Colors.white,
                            iconSize: 30.0,
                            onPressed: () => {
                              setState(() {
                                _preferenceWindow = !_preferenceWindow;
                              })
                            },
                          ),
                          IconButton(
                            icon: (_isGenerating
                                ? Icon(Icons.pause_circle_filled)
                                : Icon(Icons.play_circle_filled)),
                            color: Colors.white,
                            iconSize: 70.0,
                            onPressed: _toggleGenerator,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_up),
                                color: Colors.white,
                                iconSize: 30.0,
                                onPressed: () => {
                                  setState(() {
                                    if (_isTempoInRange(_speed + 1)) {
                                      _speed += 1;
                                    }
                                  })
                                },
                              ),
                              Text('$_speed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                  )),
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_down),
                                color: Colors.white,
                                iconSize: 30.0,
                                onPressed: () => {
                                  setState(() {
                                    if (_isTempoInRange(_speed - 1)) {
                                      _speed -= 1;
                                    }
                                  })
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
        ]),
      ),
    );
  }
}

/*
mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ), ],  */
