import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:hive/hive.dart';
import 'package:pyvault/auth_screen.dart';
import 'package:pyvault/settings_screen.dart';

class OptionsPage extends StatefulWidget {
  final bool? login_info;

  OptionsPage({Key? key, @required this.login_info}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState(login_info);
}

class _OptionsPageState extends State<OptionsPage> {
  Box? userbox;

  bool? login_info;
  _OptionsPageState(this.login_info);

  @override
  void initState() {
    super.initState();
    userbox = Hive.box("users");
  }

  Widget CustomListTile(txt, icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: FlutterGradients.aquaSplash(
          tileMode: TileMode.clamp,
          type: GradientType.linear,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15.0),
        tileColor: Colors.blueGrey,
        onTap: () {},
        title: Text(
          txt,
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
          size: 25.0,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 25.0,
        ),
      ),
    );
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage(
                          info: login_info,
                        )));
              },
              icon: Icon(
                Icons.settings_sharp,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AuthPage()));
              },
              icon: Icon(
                Icons.logout,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.51,
            decoration: BoxDecoration(
              gradient: FlutterGradients.aquaSplash(
                tileMode: TileMode.clamp,
                type: GradientType.linear,
              ),
            ),
            child: Icon(
              Icons.verified_user,
              color: Colors.white.withOpacity(0.5),
              size: 300.0,
            ),
          ),
          Column(
            children: [
              CustomListTile('Pictures', Icons.image),
              CustomListTile('Videos', Icons.video_collection),
              CustomListTile('Documents', Icons.file_present),
            ],
          ),
        ],
      ),
    );
  }
}
