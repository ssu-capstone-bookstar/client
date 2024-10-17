import 'package:bookstar_app/components/ActionSheet1.dart';
import 'package:flutter/material.dart';

class AddRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Record'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add a new record here'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ActionSheet1.show(context);
              },
              child: Text('Temp Button'),
            ),
          ],
        ),
      ),
    );
  }
}
