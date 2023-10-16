import 'package:flutter/material.dart';
import 'package:studentdb/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Base',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Notes> notes = [];

  _loadnotes() async {
    DataBaseHelper dataBaseHelper = DataBaseHelper();
    final notelist = await dataBaseHelper.queryAll();
    setState(() {
      notes = notelist;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadnotes();
  }

  final nameCont = TextEditingController();

  final cnicCont = TextEditingController();
  int selectedId = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return ListTile(
                    title: Text(note.st_name!),
                    subtitle: Text(note.st_cnic! as String),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              nameCont.text = note.st_name!;
                              cnicCont.text = note.st_cnic as String;
                              selectedId = note.st_id! as int;
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              DataBaseHelper dataBaseHelper = DataBaseHelper();
                              await dataBaseHelper.delete(note.st_id! as int);
                              _loadnotes();
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: nameCont,
              decoration: InputDecoration(labelText: "Student Name"),
            ),
            TextField(
              controller: cnicCont,
              decoration: InputDecoration(labelText: "Student CNIC"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      DataBaseHelper helper = DataBaseHelper();
                      await helper.insert(Notes(
                          st_name: nameCont.text, st_cnic: cnicCont.text));
                      _loadnotes();
                    },
                    child: Text("Insert")),
                ElevatedButton(
                    onPressed: () async {
                      DataBaseHelper helper = DataBaseHelper();
                      await helper.update(Notes(
                          st_id: selectedId,
                          st_name: nameCont.text,
                          st_cnic: cnicCont.text));

                      _loadnotes();
                      selectedId = -1;
                    },
                    child: Text("Update"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
