import 'package:flutter/material.dart';
import 'package:sqflite_ex/helper/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper _databaseHelper;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
  }

  @override
  void dispose() {
    _databaseHelper.deleteData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              if (_counter > 0) {
                _counter--;
                if (await _databaseHelper.getCount() > 0) {
                  _databaseHelper.updateData(_counter);
                } else {
                  _databaseHelper.insertData(_counter);
                }
                if (mounted) {
                  setState(() {});
                }
                print(await _databaseHelper.getAllValues());
              }
            },
            tooltip: 'Decrease',
            child: Icon(Icons.remove),
          ),
          SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            onPressed: () async {
              _counter++;
              if (await _databaseHelper.getCount() > 0) {
                _databaseHelper.updateData(_counter);
              } else {
                _databaseHelper.insertData(_counter);
              }
              if (mounted) {
                setState(() {});
              }
              print(await _databaseHelper.getAllValues());
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
