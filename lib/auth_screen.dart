import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive/hive.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:pyvault/options_screen.dart';
import 'package:local_auth/local_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Box? user;
  String text = '';
  bool login = false;
  @override
  void initState() {
    login = false;
    super.initState();
    user = Hive.box("users");
  }

  TextEditingController enteredpasscode = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
      enteredpasscode.text = text;
      if (_formkey.currentState!.validate()) {
        if (user!.get('passcode') == enteredpasscode.text) {
          login = true;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => OptionsPage(
                    login_info: login,
                  )));
          enteredpasscode.text = '';
          text = '';
        }
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
        print(_authorized);
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      print(message);
      if (_authorized == 'Authorized') {
        print('authorized');
        login = true;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => OptionsPage(login_info: login)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'PyVault',
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
                    "Verify your Identity",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
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
                    validator: (val) =>
                        MatchValidator(errorText: 'Incorrect passcode')
                            .validateMatch(enteredpasscode.text, '5070'),
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
                    setState(() {
                      text = text.substring(0, text.length - 1);
                      enteredpasscode.text = text;
                    });
                  },
                  rightIcon: Icon(
                    Icons.backspace,
                    color: Colors.white,
                  ),
                  leftButtonFn: () {
                    print('left button clicked');
                    _authenticateWithBiometrics();
                  },
                  leftIcon: Icon(
                    Icons.fingerprint_sharp,
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
