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
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      CustomPaint(
                        painter:
                            HighlightPainter(highlights: highlights[index]),
                      ),
                    ],
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

class HighlightPainter extends CustomPainter {
  final List<Offset?> highlights;

  HighlightPainter({required this.highlights});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < highlights.length; i += 2) {
      if (highlights[i] != null && highlights[i + 1] != null) {
        canvas.drawLine(highlights[i]!, highlights[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
