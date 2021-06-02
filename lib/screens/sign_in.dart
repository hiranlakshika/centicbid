import 'package:centicbid/screens/reset_password.dart';
import 'package:centicbid/screens/sign_up.dart';
import 'package:centicbid/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

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
    return Container(
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
    );
  }

  Widget _buildLoginBtn() {
    return Container(
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
          'Log In',
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

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => Get.to(() => ResetPassword()),
        child: Text(
          'Forgot Password?',
        ),
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
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
          onPressed: () => Get.to(() => SignUp()),
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
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
                _buildRememberMeCheckbox(),
                _buildForgotPasswordBtn(),
                _buildLoginBtn(),
                _buildSignUpBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
