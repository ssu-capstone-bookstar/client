import 'package:flutter/material.dart';
import 'package:bookstar_app/pages/ProfileSettings.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettings()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('This is your Profile Page'),
      ),
    );
  }
}
