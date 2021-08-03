import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  final Function getEmail;

  const LoginPage({Key key, this.getEmail}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  void _submit() {
    if (_validateAndSaveForm()) {
      print(_email);
      print(_password);
      widget.getEmail(_email, _password);
    } else {
      print('Hiba: ');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              'Bejelentkezés',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20.0),
            TextFormField(
                onSaved: (value) => _email = value,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email cím")),
            TextFormField(
                onSaved: (value) => _password = value,
                obscureText: true,
                decoration: InputDecoration(labelText: "Jelszó")),
            SizedBox(height: 20.0),
            ElevatedButton(child: Text("LOGIN"), onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
