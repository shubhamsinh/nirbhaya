import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nirbhaya/home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late SharedPreferences prefs;

  Future login() async {
    prefs = await SharedPreferences.getInstance();
    var url = Uri.parse("http://demonirbhaya.000webhostapp.com/login.php");
    var data = {
      "email": email.text,
      "password": password.text,
    };
    var response = await http.post(url, body: data);
    print(response);
    print("Vishal login response aavi gyo :)");
    print(response.statusCode);
    print(response.body);
    // var str = {"Id":"4","Email":"n@email.com","Result":"1"}
    var str = response.body;
    var data1 = jsonDecode(response.body);
    print("Result key:");
    print(data1["Result"]);
    if (data1["Result"] == "1") {
      var id=data1["Id"];

      prefs.setString('Email', data1["Email"]);
      prefs.setString("Id", data1["Id"]);
      prefs.setString("Name", data1["Name"]);
      // prefId.setString('id', id.text);


      final text = "Login successfull!";
      final snackBar = SnackBar(content: Text(text));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final text = "Invalid username or password";
      final snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool hidePassword = true;

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
                      "Login",
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
                    ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return MainPage();
                          //     },
                          //   ),
                          // );
                          login();
                        },
                        child: Text("Login")),
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
