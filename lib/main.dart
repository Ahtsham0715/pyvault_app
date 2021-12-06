import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pyvault/auth_screen.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:pyvault/passcode_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pyvault/security_question_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox("users");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        hintColor: Colors.white,
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Box? usersbox;
  @override
  void initState() {
    super.initState();
    usersbox = Hive.box("users");
    Timer(Duration(seconds: 3), () {
      if (usersbox!.get('passcode') != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => AuthPage()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => PasscodePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          gradient: FlutterGradients.aquaSplash(
            tileMode: TileMode.clamp,
            type: GradientType.sweep,
            center: Alignment.topLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.security,
              //   size: 250.0,
              //   color: Colors.white,
              // ),
              Image(
                image: AssetImage('assets/appicon/icon.png'),
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "PyVault",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
