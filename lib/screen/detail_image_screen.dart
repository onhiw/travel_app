import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailImageScreen extends StatefulWidget {
  final String imageUrl;
  DetailImageScreen({this.imageUrl});

  @override
  _DetailImageScreenState createState() => _DetailImageScreenState();
}

class _DetailImageScreenState extends State<DetailImageScreen> {
  String _imageUrl;
  @override
  Widget build(BuildContext context) {
    _imageUrl = widget.imageUrl;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: PhotoView(
              loadingBuilder: (context, event) => Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              ),
              loadFailedChild: Image.asset(
                "assets/default_image.png",
                fit: BoxFit.cover,
              ),
              imageProvider: NetworkImage(_imageUrl),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
