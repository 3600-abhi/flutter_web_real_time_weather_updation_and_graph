import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_weather_update/screens/signUp.dart';
import 'package:real_time_weather_update/services/authentication.dart';
import 'package:real_time_weather_update/worker.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                )),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(left: 280, right: 280),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
              ),
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.only(left: 280, right: 280),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 50,
              child: ElevatedButton(
                child: Text('Sign In', style: TextStyle(fontSize: 30)),
                onPressed: () {
                  signInAuthUsingEmailAndPassword
                      .signInAuth(context, emailController.text.trim(),
                          passwordController.text.trim())
                      .then((value) => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => worker())));
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account ?"),
                TextButton(
                  child: Text('SignUp'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => signUp()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
