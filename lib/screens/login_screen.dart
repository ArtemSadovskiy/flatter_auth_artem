import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flatter_auth_artem/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter login demo'),
        ),
        body: Form(
          key: _key,
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  validator: authService.validateEmail,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  validator: authService.validatePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(
                    child:
                        Text(errorMessage, style: TextStyle(color: Colors.red)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Register'),
                        onPressed: user != null
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = '';
                                });
                                if (_key.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    users.add({
                                      'email': emailController.text,
                                      'password': passwordController.text
                                    });
                                  } on FirebaseAuthException catch (error) {
                                    errorMessage = error.message!;
                                  }
                                  setState(() => isLoading = false);
                                }
                              }),
                    ElevatedButton(
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Login'),
                        onPressed: user != null
                            ? null
                            : () async {
                                if (_key.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  } on FirebaseAuthException catch (error) {
                                    errorMessage = error.message!;
                                  }
                                }
                              }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
