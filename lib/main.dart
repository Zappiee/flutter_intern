import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_contact/classess.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const isFormattedDate = 'isFormatted';
const contactListPref = 'contacts';
const jsonSample = 'assets/contact_sample.json';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Contact Generator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Welcome to Random Contact Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  List<Contact> _currentContacts = List.empty();
  List<Contact> _fullContacts = List.empty();
  DateTime currentTime = DateTime.now();
  bool isFormatted = true;
  late Future<bool> _isFormatted;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> initFromPreferences() async {
    final SharedPreferences prefs = await _prefs;
    var sample = await DefaultAssetBundle.of(context).loadString(jsonSample);
    setState(() {
      isFormatted = prefs.getBool(isFormattedDate) ?? true;
      var temp = prefs.getString(contactListPref) ?? sample;
      var jsonMap = jsonDecode(temp);
      
      var contactListObj = Contacts.fromJson(jsonMap);
      contactListObj.sortByTime();
      _fullContacts = List.of(contactListObj.contactList);
      _currentContacts = List.of(_fullContacts.take(10));
      _fullContacts.removeRange(0, 10);
    });
  }

  Future<void> toggleDateFormat() async {
    final SharedPreferences prefs = await _prefs;
    //final bool isFormatted = !(prefs.getBool(IS_FORMATTED_DATE) ?? true);

    setState(() {
      isFormatted = !isFormatted;
      prefs.setBool(isFormattedDate, isFormatted);
    });
  }

  Future<void> appendAndSaveData() async {
    final SharedPreferences prefs = await _prefs;
    return Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        List<Contact> appendList = [];
        for (var i = 0; i < 5; i++) {
          appendList.add(Contact.randomContact());
        }
        _fullContacts.addAll(appendList);

        var _contacts = _fullContacts + _currentContacts;
        var jsonString = jsonEncode(Contacts(_contacts).toJson());

        prefs.setString(contactListPref, jsonString);

        _fullContacts.sort((a, b) {
          int aDate = a.dt.millisecondsSinceEpoch;
          int bDate = b.dt.millisecondsSinceEpoch;
          return bDate.compareTo(aDate);
        });
        currentTime = DateTime.now();
      });
      _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('5 Random Contact Generated'),
        ),
      );
    });
  }

  @override
  initState() {
    _scaffoldKey = GlobalKey();
    initFromPreferences();
    super.initState();
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _biggerFont = TextStyle(fontSize: 18.0);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: toggleDateFormat,
                child: const Icon(Icons.access_time_rounded),
              )),
        ],
      ),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString(jsonSample),
          builder: (context, snapshot) {
            if (_currentContacts.isEmpty) {
              var jsonData = json.decode(snapshot.data.toString());
              //var _contacts = jsonData['_contacts'];
              if (jsonData != null) {
                var contactListObj = Contacts.fromJson(jsonData);
                contactListObj.sortByTime();
                _fullContacts = List.of(contactListObj.contactList);
                _currentContacts = List.of(_fullContacts.take(10));
                _fullContacts.removeRange(0, 10);
              }
            }

            currentTime = DateTime.now();
            return ListView.builder(
                itemCount: (_currentContacts.length + 1),
                itemBuilder: (context, i) {
                  if (i >= _currentContacts.length) {
                    if (_fullContacts.isNotEmpty) {
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          var temp = List.of(_fullContacts.take(10));
                          _fullContacts.removeRange(
                              0,
                              (_fullContacts.length < 10
                                  ? _fullContacts.length
                                  : 10));
                          _currentContacts.addAll(temp);
                          _currentContacts.sort((a, b) {
                            int aDate = a.dt.millisecondsSinceEpoch;
                            int bDate = b.dt.millisecondsSinceEpoch;
                            return bDate.compareTo(aDate);
                          });
                        });
                      });
                      /*return const ListTile(
                        title: Text("Loading", textAlign: TextAlign.center),
                      );*/
                      return const SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return const ListTile(
                        title: Text("You have reached end of the list",
                            textAlign: TextAlign.center),
                      );
                    }
                  } else {
                    var contact = _currentContacts[i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Text((i + 1).toString()),
                        title: Text(contact.user, style: _biggerFont),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(contact.phone)),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(isFormatted
                                    ? contact.getTimeStampString(
                                        currentTime.millisecondsSinceEpoch)
                                    : contact.dateTime)),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        onPrimary: Colors.white,
                                        shadowColor: Colors.greenAccent,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        minimumSize:
                                            const Size(35, 35), //////// HERE
                                      ),
                                      onPressed: () {
                                        Share.share(
                                            "Contact\nName:${contact.user}\nPhone:${contact.phone}");
                                      },
                                      icon: const Icon(Icons.share),
                                      label: const Text("Share"),
                                    )))
                          ],
                        ),
                      ),
                    );
                  }
                });
          },
        ),
        onRefresh: appendAndSaveData,
        /*() {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              List<Contact> appendList = [];
              for (var i = 0; i < 5; i++) {
                appendList.add(Contact.randomContact());
              }
              _fullContacts.addAll(appendList);
              _fullContacts.sort((a, b) {
                int aDate = a.dt.millisecondsSinceEpoch;
                int bDate = b.dt.millisecondsSinceEpoch;
                return bDate.compareTo(aDate);
              });
              currentTime = DateTime.now();
            });
            _scaffoldKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text('Page Refreshed'),
              ),
            );
          });
        },*/
      ),
    ));
  }
}
