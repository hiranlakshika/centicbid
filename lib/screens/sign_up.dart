import 'package:centicbid/services/auth.dart';
import 'package:centicbid/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String _email, _password;
  final _formKey = GlobalKey<FormState>();
  bool _termsAndConditions = false;
  bool _loading = false;
  final AuthService _auth = AuthService();

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
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextFormField(
            validator: FieldValidator.password(
                minLength: 6,
                shouldContainNumber: true,
                shouldContainCapitalLetter: true,
                shouldContainSpecialChars: true,
                errorMessage: "Password must match the required format",
                onNumberNotPresent: () {
                  return "Password must contain number";
                },
                onSpecialCharsNotPresent: () {
                  return "Password must contain special characters";
                },
                onCapitalLetterNotPresent: () {
                  return "Password must contain capital letters";
                }),
            onChanged: (val) {
              setState(() => _password = val);
            },
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
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

  Widget _buildConfirmPasswordTF() {
    return Column(
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
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
              ),
              hintText: 'Confirm Password',
            ),
          ),
        ),
      ],
    );
  }

  Widget _registerBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_termsAndConditions) {
              setState(() => _loading = true);
              dynamic result = await _auth.registerWithEmail(_email, _password);
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
          'Sign Up',
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

  Widget _buildTermsCheckbox() {
    return Container(
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()..onTap = () {})
          ])),
          /*Text(
            'I agree to',
            style: kLabelStyle,
          )*/
        ],
      ),
    );
  }

  Widget _buildSignInBtn() {
    return Row(
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
          onPressed: () => Get.to(() => SignUp()),
          child: Text(
            'Sign In',
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
        centerTitle: true,
        title: Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildEmailTF(),
            _buildPasswordTF(),
            _buildConfirmPasswordTF(),
            _buildTermsCheckbox(),
            _registerBtn(),
            _buildSignInBtn(),
          ],
        ),
      ),
    );
  }
}
