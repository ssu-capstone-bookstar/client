import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          //'assets/images/App_LOGO.png',
          //height: 40,
          'assets/images/App_Text_LOGO.png',
          height: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
              right: 16.0, top: 8.0, bottom: 8.0, left: 8.0),
          child: IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/newsfeed');
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
