import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insta_image_viewer/insta_image_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insta Image Viewer',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> _users;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _users = [];
  }

  Future<void> _fetchUser() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users'));

    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        _users = data['users'];
      });
    }

    print(_users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile Viewer"),
      ),
      body: _users.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: InstaImageViewer(
                      child: Image.network(_users[index]['image'])),
                  title: Text(
                      '${_users[index]['firstName']} ${_users[index]['maidenName']} ${_users[index]['lastName']}'),
                  subtitle: Text('${_users[index]['email']}'),
                );
              },
            ),
    );
  }
}
