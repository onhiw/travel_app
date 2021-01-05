import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:submission_flutter/constant/color_pallete.dart';
import 'package:submission_flutter/model/tourism_place.dart';
import 'package:submission_flutter/screen/detail_image_screen.dart';
import 'package:submission_flutter/utils/dbhelper.dart';
import 'package:submission_flutter/utils/helper.dart';

var informationTextStyle = TextStyle(color: Colors.black);

class DetailScreen extends StatefulWidget {
  final TourismPlace place;

  DetailScreen({@required this.place});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TourismPlace favoriteState;

  @override
  void initState() {
    super.initState();
    DbHelper db = DbHelper();
    favoriteState = widget.place;
    db.getFavorite(favoriteState.id).then((product) {
      print(product);
      if (product == null) {
        setState(() {
          favoriteState.favored = false;
        });
      } else {
        setState(() {
          favoriteState.favored = product.favored;
        });
      }
    });
  }

  void onPressed() {
    DbHelper db = DbHelper();
    setState(() => favoriteState.favored = !favoriteState.favored);

    if (favoriteState.favored == true) {
      db.addFavorite(favoriteState);
      Fluttertoast.showToast(
          msg: "Berhasil ditambahkan ke daftar favorite anda",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[400],
          fontSize: 12,
          textColor: Colors.white);
    } else {
      db.deleteFavorite(favoriteState.id);
      Fluttertoast.showToast(
          msg: "Berhasil dihapus dari daftar favorite anda",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[400],
          fontSize: 12,
          textColor: Colors.white);
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (!isLiked) {
      onPressed();
    } else {
      onPressed();
    }

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                OpenContainer(
                  transitionDuration: Duration(milliseconds: 500),
                  openElevation: 0,
                  closedElevation: 0,
                  closedBuilder: (context, action) {
                    return Image.network(widget.place.imageAsset);
                  },
                  openBuilder: (context, action) {
                    return DetailImageScreen(
                      imageUrl: widget.place.imageAsset,
                    );
                  },
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            margin: EdgeInsets.all(8),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black54),
                            child: Center(
                                child: Platform.isIOS
                                    ? Container(
                                        margin: EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                        ))
                                    : Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ))),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 120),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black54),
                        child: LikeButton(
                          size: 30,
                          circleColor: CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Color(0xff33b5e5),
                            dotSecondaryColor: Color(0xff0099cc),
                          ),
                          isLiked: favoriteState.favored,
                          likeBuilder: (bool isLiked) {
                            return favoriteState.favored
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent[400],
                                  )
                                : Icon(Icons.favorite, color: Colors.white);
                          },
                          onTap: (isLiked) {
                            return onLikeButtonTapped(isLiked);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                widget.place.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                children: [
                  RatingBarIndicator(
                    rating: double.parse(widget.place.ratingAvg),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 15),
                    child: Text(widget.place.ratingAvg,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  widget.place.category == 'hill'
                      ? Icon(Icons.filter_hdr, color: Colors.green[400])
                      : widget.place.category == 'beach'
                          ? Icon(Icons.beach_access, color: Colors.orange[400])
                          : widget.place.category == 'hotel'
                              ? Icon(Icons.hotel, color: Colors.cyan[400])
                              : Container(),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(widget.place.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      SizedBox(height: 8.0),
                      Text(
                        widget.place.openDays,
                        style: informationTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      SizedBox(height: 8.0),
                      Text(
                        widget.place.openTime,
                        style: informationTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(Icons.monetization_on),
                      SizedBox(height: 8.0),
                      Text(
                        FormatHelper.formatCurrency(
                            double.parse(widget.place.ticketPrice.toString())),
                        style: informationTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "About",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                widget.place.description,
                textAlign: TextAlign.left,
                style: informationTextStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Image",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 150,
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ListView(scrollDirection: Axis.horizontal, children: [
                ...widget.place.imageUrls
                    .split(',')
                    .asMap()
                    .map((index, url) => MapEntry(
                        index,
                        GestureDetector(
                          onTap: () {
                            modalBottomimages(context, index,
                                widget.place.imageUrls.split(','));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(url),
                            ),
                          ),
                        )))
                    .values
                    .toList()
              ]),
            ),
          ],
        ),
      ),
    );
  }

  modalBottomimages(BuildContext context, int number, imageUrl) {
    PageController pageController = PageController(initialPage: number);

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        context: context,
        builder: (BuildContext cn) {
          return Container(
            // margin: EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: PhotoViewGallery.builder(
                        pageController: pageController,
                        itemCount: imageUrl.length,
                        loadingBuilder: (context, event) => Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        builder: (context, index) {
                          return PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(imageUrl[index]),
                            initialScale: PhotoViewComputedScale.contained * 1,
                            heroAttributes:
                                PhotoViewHeroAttributes(tag: imageUrl[index]),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 40),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                )),
          );
        });
  }
}
