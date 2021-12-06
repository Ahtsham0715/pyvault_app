import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pyvault/auth_screen.dart';
import 'package:pyvault/options_screen.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:hive/hive.dart';

class SQPage extends StatefulWidget {
  final bool? UserLoginInfo;
  const SQPage({Key? key, @required this.UserLoginInfo}) : super(key: key);

  @override
  _SQPageState createState() => _SQPageState(this.UserLoginInfo);
}

class _SQPageState extends State<SQPage> {
  bool? UserLoginInfo;
  _SQPageState(this.UserLoginInfo);
  Box? users;
  TextEditingController question = new TextEditingController();
  TextEditingController value = new TextEditingController();

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'middle name',
      'label': 'What is your middle name?',
    },
    {
      'value': 'best friend',
      'label': 'What is your best friend name',
    },
    {
      'value': 'pet name',
      'label': 'Your favorite pet name',
    },
  ];

  @override
  void initState() {
    super.initState();
    users = Hive.box("users");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Set Security Question',
          style: TextStyle(
            fontSize: 23.0,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: FlutterGradients.aquaSplash(
              tileMode: TileMode.clamp,
              center: Alignment.topLeft,
            ),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print(question.text);
              users!.put('sq', value.text + ':' + question.text);
              if (UserLoginInfo!) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OptionsPage(login_info: true)));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AuthPage()));
              }
            },
            icon: Icon(
              Icons.check,
              color: Colors.white,
              size: 25.0,
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          gradient: FlutterGradients.aquaSplash(
            tileMode: TileMode.mirror,
            type: GradientType.sweep,
            center: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: SelectFormField(
                  controller: value,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    labelText: 'Choose Question',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  cursorColor: Colors.white,

                  items: _items,
                  // onChanged: (val) {
                  //   value = val;
                  //   print(value);
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: TextFormField(
                    controller: question,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Your answer',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                            style: BorderStyle.solid),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
