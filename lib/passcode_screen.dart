import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pyvault/auth_screen.dart';
import 'package:pyvault/security_question_screen.dart';
import 'package:hive/hive.dart';

class PasscodePage extends StatefulWidget {
  const PasscodePage({Key? key}) : super(key: key);

  @override
  _PasscodePageState createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  String passcode = '';

  TextEditingController enteredpasscode = new TextEditingController();
  Box? users;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    users = Hive.box("users");
  }

  _onKeyboardTap(String value) {
    setState(() {
      passcode = passcode + value;
      enteredpasscode.text = passcode;
    });
  }

  void customsnackbar(texttodisplay) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          texttodisplay,
          style: TextStyle(
            fontSize: 17.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Set Passcode',
          style: TextStyle(
            fontSize: 25.0,
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
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
                  child: Text(
                    "Set your passcode\nwhich should be 4 digit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: TextFormField(
                    controller: enteredpasscode,
                    readOnly: true,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: LengthRangeValidator(
                        min: 4,
                        max: 4,
                        errorText: 'Passcode must be of 4 digits'),
                    decoration: InputDecoration(
                      labelText: '\tPasscode',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              NumericKeyboard(
                  onKeyboardTap: _onKeyboardTap,
                  textColor: Colors.white,
                  rightButtonFn: () {
                    print('right button clicked');
                    if (_formkey.currentState!.validate()) {
                      print('validate');
                      passcode = enteredpasscode.text;
                      users!.put('passcode', passcode.toString());
                      customsnackbar('Passcode has been set successfully');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SQPage(
                                UserLoginInfo: false,
                              )));
                    }
                    // else {
                    //   customsnackbar('Passcode should be of 4 digits');
                    // }
                  },
                  rightIcon: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  leftButtonFn: () {
                    setState(() {
                      passcode = passcode.substring(0, passcode.length - 1);
                      enteredpasscode.text = passcode;
                    });
                  },
                  leftIcon: Icon(
                    Icons.backspace,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly)
            ],
          ),
        ),
      ),
    );
  }
}
