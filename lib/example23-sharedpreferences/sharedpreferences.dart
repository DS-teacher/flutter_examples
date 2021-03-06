import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _agreed;

  @override
  void initState() {
    super.initState();
    _loadAgreed();
    _loadCounter();
  }

  _loadAgreed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _agreed = prefs.getBool(MyAlertDialog.showAgreeGetaddress) ?? false;
    if (!_agreed) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => MyAlertDialog());
    }
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter') ?? 0;
    setState(() {});
  }

  //Incrementing counter after click
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = (prefs.getInt('counter') ?? 0) + 1;
    prefs.setInt('counter', _counter);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyAlertDialog extends StatefulWidget {
  static const String showAgreeGetaddress = 'showAgreeGetaddress';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAlertDialogState();
  }
}

class MyAlertDialogState extends State<MyAlertDialog> {
  bool _selected = false;

  _agreed() async {
    if (_selected) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(MyAlertDialog.showAgreeGetaddress, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      elevation: 24,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('是否允许应用拨打电话和管理通话？'),
          CheckboxListTile(
            title: Text('不再显示'),
            value: _selected,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (v) {
              _selected = v;
              setState(() {});
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('NO'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('YES'),
          onPressed: () {
            _agreed();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
