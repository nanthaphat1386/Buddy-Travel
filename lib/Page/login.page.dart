import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:projectbdtravel/API/apiUser.dart';
import 'package:projectbdtravel/Component/tapBar.dart';
import 'package:projectbdtravel/Page/register.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Padding paddingAll(int num) {
      double number = num.toDouble();
      return Padding(padding: EdgeInsets.all(number));
    }

    Container myLogo() {
      return Container(
        width: w * 0.55,
        height: h * 0.35,
        padding: const EdgeInsets.all(10),
        child: const CircleAvatar(
            backgroundImage: AssetImage('assets/img/logo_project.png'),
            radius: 50),
      );
    }

    SizedBox myTextEmail() {
      return SizedBox(
        width: w * 0.7,
        height: h * 0.07,
        child: TextField(
          controller: _controllerEmail,
          decoration: InputDecoration(
            prefixIcon: const Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Icon(
                Icons.email,
                color: Color.fromARGB(167, 81, 69, 250),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 81, 69, 250), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 81, 69, 250)),
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'อีเมล',
            labelStyle: TextStyle(color: Color.fromARGB(255, 81, 69, 250)),
          ),
        ),
      );
    }

    SizedBox myTextPassword() {
      return SizedBox(
        width: w * 0.7,
        height: h * 0.07,
        child: TextField(
          controller: _controllerPassword,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Icon(
                Icons.lock,
                color: Color.fromARGB(167, 81, 69, 250),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 81, 69, 250), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 81, 69, 250)),
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'รหัสผ่าน',
            labelStyle: TextStyle(color: Color.fromARGB(255, 81, 69, 250)),
          ),
        ),
      );
    }

    Container myLogin() {
      return Container(
        width: w * 0.5,
        height: h * 0.05,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(167, 81, 69, 250)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ))),
          onPressed: () async {
            var result =
                await login(_controllerEmail.text, _controllerPassword.text);
            if (result.toString().contains("INCORRECT")) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง')));
            } else if (result.toString().contains("FALSE")) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กรุณากรอกอีเมล')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กำลังเข้าสู่ระบบ')));
              Timer(const Duration(seconds: 3), () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const TabBottom()));
              });
            }
          },
          child: const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 12)),
        ),
      );
    }

    Container myLoginFacebook() {
      return Container(
        width: w * 0.5,
        height: h * 0.05,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(167, 81, 69, 250)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ))),
          onPressed: () {},
          child: Wrap(
            children: <Widget>[
              Icon(
                Icons.facebook_outlined,
                color: Colors.white,
                size: w * 0.05,
              ),
              const SizedBox(
                width: 15,
              ),
              const Text("เข้าสู่ระบบด้วย Facebook",
                  style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(130, 81, 69, 250),
              Color.fromARGB(180, 81, 69, 250),
            ],
          )),
          width: w,
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myLogo(),
              Container(
                width: w * 0.85,
                height: h * 0.45,
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      paddingAll(10),
                      myTextEmail(),
                      paddingAll(10),
                      myTextPassword(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Color.fromARGB(255, 81, 69, 250),
                              textStyle: TextStyle(fontSize: w * 0.035),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()),
                              );
                            },
                            child: const Text('สมัครสมาชิก'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Color.fromARGB(255, 81, 69, 250),
                              textStyle: TextStyle(fontSize: w * 0.035),
                            ),
                            onPressed: () {},
                            child: const Text('ลืมรหัสผ่าน?'),
                          ),
                        ],
                      ),
                      myLogin(),
                      paddingAll(5),
                      myLoginFacebook(),
                    ]),
              ),
            ],
          ))),
    );
  }
}
