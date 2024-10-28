import 'package:flutter/material.dart';
import 'dart:io';

class ScrapTextComponent extends StatelessWidget {
  final List<File> images;
  final List<List<Offset?>> highlights;

  ScrapTextComponent({required this.images, required this.highlights});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('닫기'),
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
            onPressed: () {
              // 완료 버튼 눌렀을 때 동작 추가
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey,
            ),
            child: Text('완료'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey,
            child: TextField(
              decoration: InputDecoration(
                hintText: '자유 메모',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
