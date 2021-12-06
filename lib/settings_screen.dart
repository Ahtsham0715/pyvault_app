import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:pyvault/passcode_screen.dart';
import 'package:pyvault/security_question_screen.dart';

class SettingsPage extends StatefulWidget {
  final bool? info;
  const SettingsPage({Key? key, @required this.info}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(this.info);
}

class _SettingsPageState extends State<SettingsPage> {
  bool? info;
  _SettingsPageState(this.info);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 25.0,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'change password',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              contentPadding: EdgeInsets.all(8.0),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PasscodePage()));
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 25.0,
              ),
            ),
            ListTile(
              title: Text(
                'change security question',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              contentPadding: EdgeInsets.all(8.0),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SQPage(
                          UserLoginInfo: false,
                        )));
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
