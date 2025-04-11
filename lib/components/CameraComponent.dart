import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ImageHighlightComponent.dart';

class CameraComponent extends StatefulWidget {
  const CameraComponent({super.key});

  @override
  State<CameraComponent> createState() => _CameraComponentState();
}

class _CameraComponentState extends State<CameraComponent> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _navigateToPreview(File(pickedFile.path));
      }
    } catch (e) {
      _showErrorDialog('Camera access denied or unavailable');
    }
  }

  Future<void> _getImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
        _navigateToPreview(File(pickedFile.path));
      }
    } catch (e) {
      _showErrorDialog('Gallery access denied');
    }
  }

  void _navigateToPreview(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          image: image,
          onRetake: () => _resetImage(image),
          onAddImage: () => _saveAndRetake(image),
          images: _images,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetImage(File image) {
    setState(() {
      _images.remove(image);
    });
    Navigator.pop(context);
  }

  void _saveAndRetake(File image) {
    setState(() {
      if (!_images.contains(image)) {
        _images.add(image);
      }
    });
    Navigator.pop(context);
  }

  void _showAllImages() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.file(
                  _images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.black,
        actions: [
          _images.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('사진 없음', style: TextStyle(color: Colors.grey)),
                )
              : const SizedBox.shrink(),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: Colors.grey,
                width: double.infinity,
                child: _images.isEmpty
                    ? const Center(
                        child: Text('No image selected',
                            style: TextStyle(color: Colors.white)))
                    : const Center(
                        child: Text('Camera Ready',
                            style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          if (_images.isNotEmpty)
            Positioned(
              bottom: 120.0,
              left: 16.0,
              child: GestureDetector(
                onTap: _showAllImages,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: Image.file(
                    _images.last,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 40.0,
            left: MediaQuery.of(context).size.width / 2 - 32.0,
            child: IconButton(
              iconSize: 64.0,
              icon: const Icon(Icons.camera, color: Colors.white),
              onPressed: _getImageFromCamera,
            ),
          ),
          Positioned(
            bottom: 40.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: _getImageFromGallery,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
              ),
              child: const Text('갤러리'),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewScreen extends StatefulWidget {
  final File image;
  final VoidCallback onRetake;
  final VoidCallback onAddImage;
  final List<File> images;

  const ImagePreviewScreen({
    super.key,
    required this.image,
    required this.onRetake,
    required this.onAddImage,
    required this.images,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('다시 찍기'),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () {
              if (!widget.images.contains(widget.image)) {
                widget.images.add(widget.image);
              }
              widget.onAddImage();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ImageHighlightComponent(images: widget.images),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey,
            ),
            child: const Text('다음'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: Colors.grey,
                width: double.infinity,
                child: Image.file(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 40.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: widget.onRetake,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
              ),
              child: const Text('다시 찍기'),
            ),
          ),
          Positioned(
            bottom: 40.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                if (!widget.images.contains(widget.image)) {
                  widget.images.add(widget.image);
                }
                widget.onAddImage();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
              ),
              child: const Text('추가 찍기'),
            ),
          ),
        ],
      ),
    );
  }
}
