import 'package:api_login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
                _prefs.remove("Token");
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Text("Hello Flutter Course polapain's"),
      ),
    );
  }
}
