import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'buttons.dart';
import 'history.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  var answer = '';
  final List<String> buttons = [
    'C',
    '( )',
    '%',
    'x\u02b8',
    'sin',
    'cos',
    'tan',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'DEL',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("  Calculator",
            style: TextStyle(fontSize: 26, color: Colors.amber)),
        actions: [
          IconButton(
            onPressed: () {
              waitForHistory(context);
            },
            icon: const Icon(
              Icons.history,
              size: 30,
              color: Colors.amber,
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userInput,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    child: Text(
                      answer,
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Button(
                      buttontapped: () {
                        setState(() {
                          userInput = '';
                          answer = '0';
                        });
                      },
                      buttonText: buttons[index],
                      color: const Color.fromARGB(57, 255, 255, 255),
                      textColor: Colors.white,
                    );
                  } else if (index == 1) {
                    return Button(
                      buttontapped: () {
                        setState(() {
                          putBracket();
                        });
                      },
                      buttonText: buttons[index],
                      color: const Color.fromARGB(57, 255, 255, 255),
                      textColor: Colors.white,
                    );
                  } else if (index == 2) {
                    return Button(
                      buttontapped: () {
                        setState(() {
                          userInput += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: const Color.fromARGB(57, 255, 255, 255),
                      textColor: Colors.white,
                    );
                  } else if (index == 22) {
                    return Button(
                      buttontapped: () {
                        setState(() {
                          userInput =
                              userInput.substring(0, userInput.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      iconbutton: Icons.backspace_outlined,
                      color: const Color.fromARGB(57, 255, 255, 255),
                      textColor: Colors.white,
                    );
                  } else if (index == 23) {
                    return Button(
                      buttontapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.amber,
                      textColor: Colors.black,
                    );
                  } else if (index == 3) {
                    return Button(
                      buttonText: buttons[index],
                      buttontapped: () {
                        setState(() {
                          userInput += '^';
                        });
                      },
                      color: const Color.fromARGB(57, 255, 255, 255),
                      textColor: Colors.white,
                    );
                  } else {
                    return Button(
                        buttontapped: () {
                          setState(() {
                            isTrig(buttons[index])
                                ? userInput += buttons[index] + '('
                                : userInput += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? const Color.fromARGB(57, 255, 255, 255)
                            : Colors.black,
                        textColor: Colors.white);
                  }
                }),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' ||
        x == 'x' ||
        x == '-' ||
        x == '+' ||
        x == '=' ||
        x == 'x\u02b8' ||
        x == 'sin' ||
        x == 'cos' ||
        x == 'tan') {
      return true;
    }
    return false;
  }

  bool isTrig(String x) {
    if (x == 'sin' || x == 'cos' || x == 'tan') {
      return true;
    }
    return false;
  }

  void putBracket() {
    var a = userInput
        .substring((userInput.length - 1) == -1 ? 0 : userInput.length - 1);
    if (isOperator(a) || a == '') {
      userInput += '(';
    } else {
      userInput += ')';
    }
  }

  Future<void> equalPressed() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? expressions = prefs.getStringList("exp") ?? [];
    List<String>? answers = prefs.getStringList("ans") ?? [];
    String finaluserinput = userInput;
    expressions.add(userInput);
    finaluserinput = userInput.replaceAll('x', '*');
    try {
      Parser p = Parser();
      Expression exp = p.parse(finaluserinput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      answer = eval.toString();
      answers.add(answer);
      prefs.setStringList("exp", expressions);
      prefs.setStringList("ans", answers);
    } catch (e) {
      answer = 'Math Error';
    }
  }

  void waitForHistory(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HistoryPage()));
    final r = result?.split('=');
    setState(() {
      userInput = r?[0] ?? '';
      answer = r?[1] ?? '';
    });
  }
}
