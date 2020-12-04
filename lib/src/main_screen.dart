import 'package:etar_products_upload/constants.dart';
import 'package:etar_products_upload/models/user_model.dart';
import 'package:etar_products_upload/src/auth/web_auth_provider.dart';
import 'package:etar_products_upload/src/widgets/list_page.dart';
import 'package:etar_products_upload/src/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_products_upload/src/login_page.dart';

import '../models/user_model.dart';

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
    super.initState();
  }

  bool _signedIn = false;
  bool _showSignIn = false;
  String uid = '';
  UserModel user = UserModel(name: '', company: '');
  String name = '';
  String company = '';

  void _signIn() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _signedIn = false;

    });
  }

  Future<String> currentUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }
  Future<UserModel> retrieveUser(String uid) async {
    final ref = FirebaseFirestore.instance.collection('users');
    return await ref.doc(uid).get().then((value) =>
        UserModel.fromMap(value.data())
    );
  }

 getUser(uid) async {
    user = await retrieveUser(uid);
  }

  void signInWithEmail(String email, String password) async {
    try {
      final creds = await AuthProvider().signInWithEmailAndPassword(email, password);
      print(creds.user.uid);
      setState(() {
        _signedIn = true;
        _showSignIn = false;
        name = user.name;
        company = user.company;
      });
    } catch (e) {
      print('Login failed: $e');
    }
  }

  void _signInWithFacebook() async {
    try {
      final creds = await AuthProvider().signInWithFacebook();
      uid = creds.user.uid;
      await getUser(uid);
      setState(() {
        _signedIn = true;
        _showSignIn = false;
        name = user.name;
        company = user.company;
      });
    } catch (e) {
      print('Login failed: $e');
    }
  }

  void _signInWithGoogle() async {
    try {
      final creds = await AuthProvider().signInWithGoogle();
      print(creds.user.uid);
      uid = creds.user.uid;
      await getUser(uid);
      setState(() {
        _signedIn = true;
        _showSignIn = false;
        name = user.name;
        company = user.company;
      });
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Image.asset("assets/Etar.png",
          height: 50,
          ),
        ),
        backgroundColor: lightBlue,
        centerTitle: true,
        title: Row(
          children: [
            Spacer(),
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: kPrimaryColor),
            ),
            Spacer(),
            if(_signedIn)
              Text(
              company,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: kPrimaryColor),
            ),
            SizedBox(width: 20,),
            if(_signedIn)
              Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: kPrimaryColor),
            ),
          ],
        ),
        actions: [
          _signedIn == true ?
            InkWell(
              onTap: _signOut,
              child: Icon(Icons.logout,
                color: kPrimaryColor,),
            )
            :  IconButton(
                icon: Icon(
                  Icons.account_box,
                  size: 25,
                  color: kPrimaryColor,
                ),
                onPressed: _signIn,
              ),
          SizedBox(width: 24,)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(_signedIn)
              ProductForm()
            else
            Container(
              padding: const EdgeInsets.all(15),
              child: _showSignIn == true && _signedIn == false ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SignInButtonBuilder(
                    text: 'Email címmel, jelszóval',
                    padding: const EdgeInsets.all(15),
                    icon: Icons.email,
                    onPressed: () => LoginPage,
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
              )
              : Container(height: 0,),
            ),
            Expanded(
              child: Container(
                child: _signedIn != true
                    ? Image.asset("assets/indít.jpg")
                    : ListPage(
                        company: company,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
