import 'package:centicbid/controllers/auth_controller.dart';
import 'package:centicbid/screens/home.dart';
import 'package:centicbid/screens/reset_password.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

import '../util.dart';

class SignIn extends StatefulWidget {
  final bool fromHome;

  const SignIn({Key? key, required this.fromHome}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String _email, _password, _userName;
  final _formKey = GlobalKey<FormState>();
  late AuthController authController;
  bool _loading = false;
  bool _termsAndConditions = false;
  bool _isSignup = false;
  String _appBarTitle = 'sign_in'.tr;

  @override
  void initState() {
    authController = AuthController.to;
    super.initState();
  }

  Widget _buildUserNameTF() {
    return Visibility(
      visible: _isSignup,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            height: 60.0,
            child: TextFormField(
              validator: (val) =>
                  _userName.isEmpty ? "uname_required".tr : null,
              onChanged: (val) {
                setState(() => _userName = val);
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Colors.blue,
                  ),
                ),
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                ),
                hintText: 'name'.tr,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              hintText: 'email'.tr,
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
            validator: (val) => val!.isEmpty ? "enter_pw".tr : null,
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
              hintText: 'password'.tr,
            ),
          ),
        ),
      ],
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
              dynamic result =
                  await authController.signInWithEmail(_email, _password);
              if (result != null) {
                showInfoToast("signed_in_success".tr);
                if (widget.fromHome) {
                  Get.off(() => Home());
                } else {
                  Get.back();
                }
              } else {
                setState(() => _loading = false);
              }
            }
          },
          child: Text(
            'sign_in'.tr,
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
                dynamic result = await authController.registerWithEmail(
                    _email, _password, _userName);
                if (result != null) {
                  showInfoToast("reg_success".tr);
                  setState(() {
                    _loading = false;
                    _isSignup = false;
                    _appBarTitle = 'sign_in'.tr;
                  });
                }
              } else {
                showErrorToast("terms".tr);
                setState(() => _loading = false);
              }
            }
          },
          child: Text(
            'sign_up'.tr,
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
              text: 'have_account'.tr + ' ',
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
                _appBarTitle = 'sign_in'.tr;
              });
            },
            child: Text(
              'sign_in'.tr,
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
            'forgot_pw'.tr,
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
              text: 'dont_have_acc'.tr + ' ',
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
                _appBarTitle = 'sign_up'.tr;
              });
            },
            child: Text(
              'sign_up'.tr,
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
                  text: "agree".tr,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: " " + "terms_con".tr,
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
              validator: (val) =>
                  Validator.isEqualTo(_password, val) ? null : "pw_mismatch".tr,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: Colors.blue)),
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                ),
                hintText: 'confirm_pw'.tr,
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
      body: _loading
          ? getLoadingDualRing()
          : Container(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: SafeArea(
                  child: ListView(
                    children: [
                      _buildUserNameTF(),
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
