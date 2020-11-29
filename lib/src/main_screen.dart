import 'package:etar_products_upload/constants.dart';
import 'package:etar_products_upload/src/auth/web_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ETAR Adatfelvitel',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ETAR Adatfelvitel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _signInWithEmail() async {
    try {
      final creds = await AuthProvider().signInWithEmailAndPassword();
      print(creds);
    } catch (e) {
      print('Login failed: $e');
    }
  }

  void _signInWithFacebook() async {
    try {
      final creds = await AuthProvider().signInWithFacebook();
      print(creds);
    } catch (e) {
      print('Login failed: $e');
    }
  }

  void _signInWithGoogle() async {
    try {
      final creds = await AuthProvider().signInWithGoogle();
      print(creds);
    } catch (e) {
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdee2d6),
      appBar: AppBar(
        elevation: 6,
        leading: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Container(
              child: Image.asset("assets/Etar.png"),
              height: 25,
            ),
          ],
        ),
        backgroundColor: lightBlue,
        title: Text(
          widget.title,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: kPrimaryColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_box,
              size: 25,
              color: kPrimaryColor,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SignInButtonBuilder(
                    text: 'Email címmel, jelszóval',
                    padding: const EdgeInsets.all(15),
                    icon: Icons.email,
                    onPressed: _signInWithEmail,
                    backgroundColor: Colors.blueGrey[700],
                  ),
                  SignInButton(
                    Buttons.Facebook,
                    padding: const EdgeInsets.all(15),
                    text: "Facebook fiókkal",
                    onPressed: _signInWithFacebook,
                  ),
                  SignInButton(
                    Buttons.Google,
                    padding: const EdgeInsets.all(5),
                    text: "Google fiókkal",
                    onPressed: _signInWithGoogle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
