import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profilesettings');
      },
      child: CircleAvatar(
        backgroundColor: Colors.grey[300],
        radius: 20,
      ),
    );
  }
}
