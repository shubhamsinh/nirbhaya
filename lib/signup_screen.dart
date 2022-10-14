
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nirbhaya/signin_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();

  Future register() async {
    // var url = Uri.parse("https://urbangreens.000webhostapp.com/register.php");
    var url = Uri.parse("http://demonirbhaya.000webhostapp.com/register.php");

    var data = {
      "fname": fname.text,
      "lname": lname.text,
      "email": email.text,
      "contact": contact.text,
      "password": password.text,
    };
    var response = await http.post(url, body: data);
    print(response);
    print(response.statusCode);
    print(response.body);
    var data1 = json.decode(response.body);
    print("data: $data1");
    if (data1 == "Error") {
      final text = "User already exist!";
      final snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (data1 == "connected") {
      final text = "Null Value not allowed";
      final snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final text = "Registration successfull";
      final snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SigninPage();
          },
        ),
      );
    }
  }

  bool hidePassword = true;
  bool hideCPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //start app bar
          Container(
            color: Colors.white,
            height: 55,
            margin: EdgeInsets.only(top: 32),
            // padding: EdgeInsets.only(left: 15, right: 15, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.arrow_back,
                          size: 28,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Register",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/nirbhaya_app_logo1.png",
            height: 200,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: fname,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        // hintText: "FIRST NAME",
                        labelText: "First Name",
                        // labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: Colors.green, width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: lname,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Last Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: Colors.green, width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: "Email Id",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: Colors.green, width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: contact,
                      decoration: InputDecoration(
                        // hintText: "MOBILE NUMBER",
                        labelText: "Mobile Number",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: Colors.green, width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: password,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        // hintText: "PASSWORD",
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          color: Colors.black26,
                          icon: Icon(hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: Colors.green, width: 2)),
                        // labelText: "password",
                        // alignLabelWithHint: true,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: cpassword,
                      obscureText: hideCPassword,
                      decoration: InputDecoration(
                        // hintText: "CONFIRM PASSWORD",
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hideCPassword = !hideCPassword;
                            });
                          },
                          color: Colors.black26,
                          icon: Icon(hideCPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: Colors.green, width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      child: Text("Register"),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        // minimumSize: Size(100, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
