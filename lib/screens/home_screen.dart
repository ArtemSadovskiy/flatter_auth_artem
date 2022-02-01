import 'package:firebase_auth/firebase_auth.dart';
import 'package:flatter_auth_artem/models/user_model.dart';
import 'package:flatter_auth_artem/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final Stream<QuerySnapshot> users =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter login demo'),
        actions: [
          TextButton(
            onPressed: () async {
              await authService.signOut();
            },
            child: Text('Logout'),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontSize: 20,
              ),
              primary: Colors.white,
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading');
                  }

                  final data = snapshot.requireData;

                  return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('email: ${data.docs[index]['email']}'),
                          Text('password: ${data.docs[index]['password']}'),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
