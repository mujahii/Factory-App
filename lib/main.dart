import 'package:flutter/material.dart';
import 'screens/MainPage.dart';
import 'screens/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              return MainPage();
            } else {
              return Auth(); // Assuming Auth is the login/signup page
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('bearerToken');
  }
}
