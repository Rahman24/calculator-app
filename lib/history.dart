import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> elements = [];

  // ignore: non_constant_identifier_names
  Future<void> rowElements() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> expressions = prefs.getStringList("exp") ?? [];
    List<String> answers = prefs.getStringList("ans") ?? [];

    for (var i = 0; i < expressions.length; i++) {
      var a = expressions[i] + "=" + answers[i];
      setState(() {
        elements.add(a);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rowElements();
  }

  Future<void> deleteHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('exp');
    prefs.remove('ans');
    setState(() {
      elements = [];
    });
    const snackBar = SnackBar(
        content: Text(
      'History Deleted',
      style: TextStyle(fontSize: 20),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("History",
              style: TextStyle(fontSize: 26, color: Colors.amber)),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              size: 40,
              color: Colors.amber,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                deleteHistory();
              },
              icon: const Icon(
                Icons.delete_outline,
                size: 30,
                color: Colors.amber,
              ),
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: elements.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "No History",
                      style: TextStyle(fontSize: 30, color: Colors.white30),
                    )
                  ],
                ),
              )
            : ListView.builder(
                reverse: true,
                itemCount: elements.length,
                itemBuilder: (context, index) {
                  final item = elements[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, elements[index]);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  color:
                                      const Color.fromARGB(30, 255, 255, 255),
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  )))));
                }));
  }
}
