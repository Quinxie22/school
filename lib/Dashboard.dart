import 'package:flutter/material.dart';
import 'Login.dart';

class Dashboard extends StatelessWidget {
  final String accessToken;
  final String refreshToken;

  const Dashboard({
    Key? key,
    required this.accessToken,
    required this.refreshToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Dashboard")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to TravelBuddy!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your Access Token:',
              style: TextStyle(fontSize: 18),
            ),
            SelectableText(
              accessToken,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Your Refresh Token:',
              style: TextStyle(fontSize: 18),
            ),
            SelectableText(
              refreshToken,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 20),
            Text(
              'Dashboard Features',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.place),
              title: Text('Explore Places'),
              onTap: () {
                // Navigate to the places screen
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Your Notes'),
              onTap: () {
                // Navigate to the notes screen
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                // Navigate to the favorites screen
              },
            ),
          ],
        ),
      ),
    );
  }
}