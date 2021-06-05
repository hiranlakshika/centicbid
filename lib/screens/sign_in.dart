import 'package:centicbid/screens/reset_password.dart';
import 'package:centicbid/services/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

import '../util.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String _email, _password;
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _rememberMe = false;
  bool _loading = false;
  bool _termsAndConditions = false;
  bool _isSignup = false;
  String _appBarTitle = 'Sign in';

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

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          height: 60.0,
          child: TextFormField(
            validator: (val) => val!.isEmpty ? "PLease enter a password" : null,
            onChanged: (val) {
              setState(() => _password = val);
            },
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: Colors.blue)),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
              ),
              hintText: 'Password',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Visibility(
      visible: !_isSignup,
      child: Container(
        height: 20.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.blue),
              child: Checkbox(
                value: _rememberMe,
                checkColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
              ),
            ),
            Text(
              'Remember me',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Visibility(
      visible: !_isSignup,
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() => _loading = true);
              dynamic result = await _auth.signInWithEmail(_email, _password);
              if (result != null) {
                print("Signed in successfully");
              } else {
                setState(() => _loading = false);
              }
            }
          },
          child: Text(
            'Sign in',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerBtn() {
    return Visibility(
      visible: _isSignup,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (_termsAndConditions) {
                setState(() => _loading = true);
                dynamic result =
                    await _auth.registerWithEmail(_email, _password);
                if (result != null) {
                  showErrorToast("Successfully Registered");
                  setState(() => _loading = false);
                  Navigator.pop(context);
                }
              } else {
                showErrorToast("You must agree to the terms and conditions");
              }
            }
          },
          child: Text(
            'Sign up',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInBtn() {
    return Visibility(
      visible: _isSignup,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isSignup = false;
                _appBarTitle = 'Sign in';
              });
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Visibility(
      visible: !_isSignup,
      child: Container(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () => Get.to(() => ResetPassword()),
          child: Text(
            'Forgot Password?',
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Visibility(
      visible: !_isSignup,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isSignup = true;
                _appBarTitle = 'Sign up';
              });
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Visibility(
      visible: _isSignup,
      child: Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.blue),
              child: Checkbox(
                value: _termsAndConditions,
                checkColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _termsAndConditions = value!;
                  });
                },
              ),
            ),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "I agree to",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: " terms and conditions",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () {})
            ])),
            /*Text(
              'I agree to',
              style: kLabelStyle,
            )*/
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordTF() {
    return Visibility(
      visible: _isSignup,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextFormField(
              validator: (val) => Validator.isEqualTo(_password, val)
                  ? null
                  : "Password mis match",
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: Colors.blue)),
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                ),
                hintText: 'Confirm Password',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              children: [
                _buildEmailTF(),
                SizedBox(
                  height: 8.0,
                ),
                _buildPasswordTF(),
                SizedBox(
                  height: 8.0,
                ),
                _buildConfirmPasswordTF(),
                Visibility(
                  visible: _isSignup,
                  child: SizedBox(
                    height: 8.0,
                  ),
                ),
                _buildRememberMeCheckbox(),
                _buildForgotPasswordBtn(),
                _buildLoginBtn(),
                _buildTermsCheckbox(),
                _registerBtn(),
                _buildSignInBtn(),
                _buildSignUpBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
