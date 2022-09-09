import 'package:api_login/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'auth.dart';

class LoginScreen extends StatefulWidget {
  final void Function(bool)? setShowSignupScreen;

  LoginScreen({this.setShowSignupScreen});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameInputController = TextEditingController();
  final _passwordInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future? _login;

  String version = '';
  String copyright = "";
  String appName = '';
  String packageName = '';
  String buildNumber = "";
  bool _isObscure = true;
  bool _isRemember = false;

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  void _loadUser() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("r_username") ?? "";
      var _password = _prefs.getString("r_password") ?? "";

      _usernameInputController.text = _email;
      _passwordInputController.text = _password;
      var _rememberMe = _prefs.getBool("remember_me") ?? false;

      if (_rememberMe) {
        setState(() {
          _isRemember = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void login() async {
    final authData = Provider.of<Auth>(context, listen: false);
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _login = authData
        .login(_usernameInputController.text, _passwordInputController.text)
        .then((value) {
      var data = convert.jsonDecode(value.body);
      print(data);
      if (value.statusCode == 200 && data["successResonse"] == null) {
        final snackBar = SnackBar(
          content: Text(data["failedResponse"]["errorMessage"]),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print(data["successResonse"]["token"]);
        _prefs.setString("Token", data["successResonse"]["token"]);
        _prefs.setString("Rtoken", data["successResonse"]["refreshToken"]);
        final snackBar = SnackBar(
          content: Text(data["successResonse"]["user"]["firstName"] +
              data["successResonse"]["user"]["lastName"]),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void dispose() {
    _usernameInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  children: [
                    TextFormField(
                        key: Key("user"),
                        autofillHints: [AutofillHints.username],
                        controller: _usernameInputController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Username',
                          enabledBorder: UnderlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: Key("pass"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autofillHints: [AutofillHints.password],
                      controller: _passwordInputController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Password is required'
                          : null,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        labelText: 'Password',
                        enabledBorder: UnderlineInputBorder(),
                      ),
                      obscureText: _isObscure,
                      enableSuggestions: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.go,
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<void>(
                        future: _login,
                        builder: (ctx, snapshot) {
                          return ElevatedButton(
                            key: Key("login"),
                            child: Text(
                              'SIGN IN',
                            ),
                            onPressed: () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate() &&
                                  !(snapshot.connectionState ==
                                      ConnectionState.waiting)) {
                                login();
                              }
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Checkbox(
                activeColor: Colors.blue,
                value: _isRemember,
                onChanged: (value) {
                  setState(() {
                    _isRemember = value!;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Remember Me",
                  style: TextStyle(
                    color: Color(0xff646464),
                    fontSize: 12,
                  ))
            ]),
            InkWell(
              onTap: () {},
              child: Text('Forgot password? ',
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 10,
            ),
            Text("© Copyright ${DateTime.now().year} Flutter course"),
          ],
        ),
      ),
    );
  }
}
