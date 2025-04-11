import 'package:flutter/material.dart';

class FloatingActionMenu3 extends StatefulWidget {
  const FloatingActionMenu3({super.key});

  @override
  State<FloatingActionMenu3> createState() => _FloatingActionMenu3State();
}

class _FloatingActionMenu3State extends State<FloatingActionMenu3> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Container(color: Colors.transparent),
            Center(
              child: Material(
                color: Colors.black.withValues(alpha: 0.6), // 어두운 반투명 배경
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800, // 어두운 회색 배경
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, size: 40, color: Colors.white),
                      SizedBox(height: 16.0),
                      Text(
                        '채팅창 입니다',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showOverlay(context), // 아이콘 크기 조정
      backgroundColor: Colors.grey.shade800, // 어두운 회색 배경
      foregroundColor: Colors.white, // 아이콘 색상
      elevation: 5.0,
      child: const Icon(Icons.chat, size: 30), // 버튼 입체감 추가
    );
  }
}
