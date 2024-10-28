import 'package:bookstar_app/components/ScrapTextComponent.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class ImageHighlightComponent extends StatefulWidget {
  final List<File> images;

  ImageHighlightComponent({required this.images});

  @override
  _ImageHighlightComponentState createState() =>
      _ImageHighlightComponentState();
}

class _ImageHighlightComponentState extends State<ImageHighlightComponent> {
  List<List<Offset?>> _allHighlights = [];
  PageController _pageController = PageController();
  int _currentIndex = 0;
  List<Uint8List?> _highlightedImages = [];

  @override
  void initState() {
    super.initState();
    _allHighlights = List.generate(widget.images.length, (index) => []);
    _highlightedImages = List.filled(widget.images.length, null);
    _loadImages();
  }

  Future<void> _loadImages() async {
    for (int i = 0; i < widget.images.length; i++) {
      _highlightedImages[i] =
          await _getHighlightedImage(widget.images[i], _allHighlights[i]);
    }
    setState(() {});
  }

  Future<void> _saveHighlightedImage() async {
    final image = widget.images[_currentIndex];
    final ui.Image highlightedImage =
        await _createHighlightedImage(image, _allHighlights[_currentIndex]);
    final directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${directory.path}/highlighted_${_currentIndex}.png';
    final ByteData? byteData =
        await highlightedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final buffer = byteData.buffer.asUint8List();
      final File file = File(filePath);
      await file.writeAsBytes(buffer);

      setState(() {
        widget.images[_currentIndex] = file;
      });
    }
  }

  Future<Uint8List> _getHighlightedImage(
      File imageFile, List<Offset?> highlights) async {
    final data = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(Offset(0, 0),
            Offset(image.width.toDouble(), image.height.toDouble())));
    canvas.drawImage(image, Offset.zero, Paint());

    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < highlights.length; i += 2) {
      if (highlights[i] != null && highlights[i + 1] != null) {
        canvas.drawLine(highlights[i]!, highlights[i + 1]!, paint);
      }
    }

    final picture = recorder.endRecording();
    final highlightedImage = await picture.toImage(image.width, image.height);
    final byteData =
        await highlightedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<ui.Image> _createHighlightedImage(
      File imageFile, List<Offset?> highlights) async {
    final Completer<ui.Image> completer = Completer();
    final data = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(Offset(0, 0),
            Offset(image.width.toDouble(), image.height.toDouble())));
    canvas.drawImage(image, Offset.zero, Paint());

    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < highlights.length; i += 2) {
      if (highlights[i] != null && highlights[i + 1] != null) {
        canvas.drawLine(highlights[i]!, highlights[i + 1]!, paint);
      }
    }

    final picture = recorder.endRecording();
    final highlightedImage = await picture.toImage(image.width, image.height);
    completer.complete(highlightedImage);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('(${_currentIndex + 1}) / ${widget.images.length}'),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _saveHighlightedImage();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScrapTextComponent(
                      images: widget.images, highlights: _allHighlights),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey,
            ),
            child: Text('편집 완료'),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _highlightedImages[index] == null
                  ? Center(child: CircularProgressIndicator())
                  : Image.memory(
                      _highlightedImages[index]!,
                      fit: BoxFit.cover,
                    );
            },
          ),
          Positioned(
            bottom: 40.0,
            left: MediaQuery.of(context).size.width / 2 - 32.0,
            child: IconButton(
              iconSize: 64.0,
              icon: Icon(Icons.brush, color: Colors.white),
              onPressed: () {
                setState(() {
                  // 하이라이트를 활성화 시킬 수 있는 상태로 변환
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
