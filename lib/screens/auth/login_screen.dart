import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bgPath = 'assets/images/login_screen.png';
  bool isLoading = false;

  // To Submit Data
  void submit() async {
    String email = emailController.text;
    String password = passwordController.text;

    // ignore: avoid_init_to_null
    String message = null;
    if (email.isEmpty)
      message = 'Email cannot be blank';
    else if (password.isEmpty) message = 'Password cannot be blank';

    if (message == null) {
      setState(() {
        isLoading = true;
      });

      Response response = await NetworkHelper().post(
          'auth/local', {'identifier': email, 'password': password});

      setState(() {
        isLoading = false;
      });

      if (response.data['statusCode'] != null)
        message = response.data['message'].first['messages'].first['message'];
      else {
        if (AuthService().saveUserData(response.data))
          Modular.to.pushReplacementNamed('/general');
      }
    }

    if (message != null)
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(.7),
          textColor: Colors.white,
          fontSize: 16.0);
  }

  // Navigate to Another Screen
  void bottomNavigate() {
    Modular.to.pushReplacementNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          Positioned.fill(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(bgPath, fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'U',
                        style: GoogleFonts.quicksand(
                          color: Color(0xFFD37348),
                          fontSize: 48,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'N',
                        style: GoogleFonts.quicksand(
                          color: Color(0xFFD37348),
                          fontSize: 48,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              'o',
                              style: GoogleFonts.quicksand(
                                color: Color(0xFFD37348),
                                fontSize: 48,
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 2,
                              color: Color(0xFFD37348).withOpacity(.7),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'r',
                        style: GoogleFonts.quicksand(
                          color: Color(0xFFD37348),
                          fontSize: 48,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'd',
                        style: GoogleFonts.quicksand(
                          color: Color(0xFFD37348),
                          fontSize: 48,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFF17C64).withOpacity(.26),
                        offset: Offset(0, -1),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 23),
                  padding: EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 30,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD37348),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: TextField(
                          controller: emailController,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFFC37653),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 30,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'Email',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFFC37653),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFC37653), width: 1.0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFC37653), width: 1.0),
                            ),
                            border: new UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFFC37653),
                          ),
                          maxLength: 15,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: 'Password',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFFC37653),
                            ),
                            labelStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFFC37653),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFC37653), width: 1.0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFC37653), width: 1.0),
                            ),
                            border: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                color: Color(0xFFC37653),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(81),
                          color: Color(0xFFF17C64),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(81),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(81),
                            onTap: submit,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(81),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 34,
                                vertical: 8,
                              ),
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 45,
                    bottom: 18,
                  ),
                  child: Text(
                    'Don’t have account yet?',
                    style: GoogleFonts.poppins(
                      color: Color(0xFFD37348),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(81),
                    color: Color(0xFFF17C64),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(81),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(81),
                      onTap: bottomNavigate,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(81),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 34,
                          vertical: 8,
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Positioned.fill(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black.withOpacity(.4),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
