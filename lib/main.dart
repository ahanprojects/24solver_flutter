// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_four_solver/algorithm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24Solver by Ahan Projects',
      theme: ThemeData(
        fontFamily: 'SourceSansPro',
        scaffoldBackgroundColor: Colors.black87,
        // scaffoldBackgroundColor: Color(0xffeef6ff),
        primarySwatch: createMaterialColor(Colors.black87),
      ),
      home: const MyHomePage(),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ctrl1 = TextEditingController();
  TextEditingController ctrl2 = TextEditingController();
  TextEditingController ctrl3 = TextEditingController();
  TextEditingController ctrl4 = TextEditingController();

  TextEditingController ctrl24 = TextEditingController(text: '24');
  int max = 5;
  int target = 24;

  bool disableSearch = true;
  bool disableDelete = true;

  @override
  Widget build(BuildContext context) {
    var width = (MediaQuery.of(context).size.width - 20 - 30) / 4;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                  onTap: changeTarget,
                  child: Text('$target Solver',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white))),
              Text('by Ahan Projects', style: TextStyle(fontSize: 18, color: Colors.white)),
              SizedBox(height: 20),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Color(0xffeef6ff),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                child: Column(children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      input(ctrl1, width),
                      SizedBox(width: 5),
                      input(ctrl2, width),
                      SizedBox(width: 5),
                      input(ctrl3, width),
                      SizedBox(width: 5),
                      input(ctrl4, width),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: disableDelete
                              ? null
                              : () {
                                  ctrl1.text = '';
                                  ctrl2.text = '';
                                  ctrl3.text = '';
                                  ctrl4.text = '';

                                  disableSearch = true;
                                  disableDelete = true;
                                  setState(() {});
                                },
                          icon: Icon(Icons.delete_rounded, color: disableDelete ? Colors.black26 : Colors.red)),
                      SizedBox(
                        width: width * 1.5,
                        child: ElevatedButton(
                          onPressed: disableSearch ? null : search,
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ]),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget input(ctrl, width) {
    return Flexible(
      child: TextField(
        controller: ctrl,
        onChanged: (value) {
          disableSearch = (ctrl1.text.isEmpty || ctrl2.text.isEmpty || ctrl3.text.isEmpty || ctrl4.text.isEmpty);
          disableDelete =
              !(ctrl1.text.isNotEmpty || ctrl2.text.isNotEmpty || ctrl3.text.isNotEmpty || ctrl4.text.isNotEmpty);
          setState(() {});
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            fillColor: Color(0xffdeeaf6),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.transparent)),
            filled: true,
            contentPadding: const EdgeInsets.all(18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }

  changeTarget() {
    showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Secret Feature!'),
        content: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: ctrl24,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
                fillColor: Color(0xffdeeaf6),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent)),
                filled: true,
                contentPadding: const EdgeInsets.all(18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (ctrl24.text.isEmpty) {
                  ctrl24.text = '24';
                }
                target = int.parse(ctrl24.text);
              });
              Navigator.pop(ctx, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  search() {
    // Validate
    if (ctrl1.text.isEmpty || ctrl2.text.isEmpty || ctrl3.text.isEmpty || ctrl4.text.isEmpty) {
      // print('empty');
      return;
    }

    var solutions = generateSolutions([
      int.parse(ctrl1.text),
      int.parse(ctrl2.text),
      int.parse(ctrl3.text),
      int.parse(ctrl4.text),
    ], target);

    if (solutions.length > max) {
      solutions = solutions.take(max).toList();
    }

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) {
          if (solutions.isEmpty) {
            return Center(
                child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 10,
                  width: 50,
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¯\\_(ツ)_/¯",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "No Answer Available",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ));
          }

          return Center(
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 10,
                width: 50,
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var item in solutions)
                      Column(
                        children: [
                          Text(
                            item,
                            style: TextStyle(fontSize: 28, fontFamily: 'STIXTwoText'),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                  ],
                ),
              )
            ],
          ));
        });
  }
}
