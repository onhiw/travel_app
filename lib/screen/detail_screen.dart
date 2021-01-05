import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:submission_flutter/model/tourism_place.dart';
import 'package:submission_flutter/screen/detail_image_screen.dart';
import 'package:submission_flutter/utils/helper.dart';

var informationTextStyle = TextStyle(color: Colors.black);

class DetailScreen extends StatelessWidget {
  final TourismPlace place;

  DetailScreen({@required this.place});

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
                    return Image.network(place.imageAsset);
                  },
                  openBuilder: (context, action) {
                    return DetailImageScreen(
                      imageUrl: place.imageAsset,
                    );
                  },
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      // FavoriteButton(),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                place.name,
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
                    rating: place.ratingAvg,
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
                    child: Text(place.ratingAvg.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  place.category == 'hill'
                      ? Icon(Icons.filter_hdr, color: Colors.green[400])
                      : place.category == 'beach'
                          ? Icon(Icons.beach_access, color: Colors.orange[400])
                          : place.category == 'hotel'
                              ? Icon(Icons.hotel, color: Colors.cyan[400])
                              : Container(),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(place.category.toUpperCase(),
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
                        place.openDays,
                        style: informationTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      SizedBox(height: 8.0),
                      Text(
                        place.openTime,
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
                            double.parse(place.ticketPrice.toString())),
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
                place.description,
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
                ...place.imageUrls
                    .asMap()
                    .map((index, url) => MapEntry(
                        index,
                        GestureDetector(
                          onTap: () {
                            modalBottomimages(context, index, place.imageUrls);
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

  modalBottomimages(BuildContext context, int number, List<String> imageUrl) {
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

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
