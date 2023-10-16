import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Viewer',
      home: ImageViewer(),
    );
  }
}

class ImageViewer extends StatefulWidget {
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int currentIndex = 0;
  double zoomLevel = 1.0;
  double maxZoom = 2.0;

  void changeImage(int newIndex) {
    setState(() {
      currentIndex = newIndex;
      zoomLevel = 1.0;
    });
  }

  void zoomImage(double factor) {
    setState(() {
      zoomLevel *= factor;
      if (zoomLevel > maxZoom) {
        zoomLevel = maxZoom;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Viewer')),
      body: GestureDetector(
        onTap: () => changeImage((currentIndex + 1) % images.length),
        onDoubleTap: () => zoomImage(2.0),
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            changeImage((currentIndex - 1) % images.length);
          } else if (details.primaryVelocity! < 0) {
            changeImage((currentIndex + 1) % images.length);
          }
        },
        child: Center(
          child: InteractiveViewer(
            maxScale: maxZoom,
            scaleEnabled: true,
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(20.0),
            minScale: 0.5,
            child: Image.asset(
              images[currentIndex],
              width: 300 * zoomLevel,
              height: 300 * zoomLevel,
            ),
          ),
        ),
      ),
    );
  }
}

List<String> images = [
  'assets/images/muet1.jpg',
  'assets/images/muet2.jpg',
  'assets/images/muet3.JPG',
];
