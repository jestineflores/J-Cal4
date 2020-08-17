import 'package:flutter/material.dart';
import 'package:j_cal4/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

final _formKey = GlobalKey<FormState>();

final AuthService _auth = AuthService();
String email = '';
String password = '';
String error = '';

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[300],
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Creat Account', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Sign In', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  widget.toggleView();
                }),
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 47, vertical: 21),
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  SizedBox(height: 18),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'email',
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Enter Email' : null,
                      onChanged: (value) {
                        setState(() => email = value);
                      }),
                  SizedBox(height: 18),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'password',
                      ),
                      obscureText: true,
                      validator: (value) => value.length < 6
                          ? 'Enter Password 6 Characters Long or More'
                          : null,
                      onChanged: (value) {
                        setState(() => password = value);
                      }),
                  SizedBox(height: 18),
                  RaisedButton(
                      color: Colors.amber,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => error = 'Provide a Valid Email');
                          }
                        }
                      }),
                  SizedBox(height: 11),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ]))));
  }
}
