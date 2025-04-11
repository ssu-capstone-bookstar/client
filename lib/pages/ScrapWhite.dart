import 'package:flutter/material.dart';

class ScrapWhite extends StatelessWidget {
  const ScrapWhite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrap White'),
      ),
      body: const Center(
        child: Text('write scrap'),
      ),
    );
  }
}
