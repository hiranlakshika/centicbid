import 'package:centicbid/services/auth.dart';
import 'package:centicbid/util.dart';
import 'package:flutter/material.dart';
import 'package:the_validator/the_validator.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  late String _email;
  bool _loading = false;

  Widget _buildEmailTF() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          height: 60.0,
          child: TextFormField(
            validator: FieldValidator.email(),
            onChanged: (val) {
              setState(() => _email = val);
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.blue,
                ),
              ),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
              ),
              hintText: 'Email',
            ),
          ),
        ),
      ],
    );
  }

  Widget _resetBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => _loading = true);
            await _auth.resetPassword(_email);
            showInfoToast("A password reset link has been sent to $_email");
            setState(() => _loading = false);
          }
        },
        child: Text(
          'Reset',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Reset Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailTF(),
              _resetBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
