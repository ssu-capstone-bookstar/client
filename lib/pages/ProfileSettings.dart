import 'package:flutter/material.dart';

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Center(
        child: Text('Manage your profile settings'),
      ),
    );
  }
}
