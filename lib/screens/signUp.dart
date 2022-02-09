import 'package:flutter/material.dart';
import 'package:real_time_weather_update/screens/homePage.dart';
import 'package:real_time_weather_update/screens/signIn.dart';
import 'package:real_time_weather_update/services/authentication.dart';

class signUp extends StatelessWidget {
  signUp({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignUp')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sign Up',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
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
                child: Text('Sign Up', style: TextStyle(fontSize: 30)),
                onPressed: () {
                  signInAuthUsingEmailAndPassword
                      .signUpAuth(context, emailController.text.trim(),
                          passwordController.text.trim())
                      .then((value) => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => homePage())));
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account ?"),
                TextButton(
                  child: Text('SignIn'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
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
