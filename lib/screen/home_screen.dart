import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission_flutter/model/tourism_place.dart';
import 'package:submission_flutter/screen/detail_screen.dart';
import 'package:submission_flutter/utils/helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController tabController;
  int _current = 0;
  ScrollController _scrollController;
  bool lastStatus = true;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  String _currentAddressComplete;

  String imageUrl =
      "https://lelogama.go-jek.com/cache/2f/07/2f0794cec0533467b1cfdbf209802f10.jpg,https://www.themulia.com/getmedia/779d0eb5-fd4f-498f-8575-599039237b72/Ladies-Courtyard.jpg/?width=1200&height=630&ext=.jpg&maxsidesize=600,https://www.ajnn.net/files/cache/20160116-gunung-perkison-gedoykocan-images-600x315.jpg";

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (150 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    LocationOptions _locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1000,
    );

    GeolocationPermission _locationPermission =
        GeolocationPermission.locationAlways;

    geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: _locationPermission)
        .then((GeolocationStatus status) {
      if (status == GeolocationStatus.granted) {
        print("permission granted");
        return geolocator.getLastKnownPosition(
            desiredAccuracy: LocationAccuracy.best,
            locationPermissionLevel: GeolocationPermission.location);
      } else {
        return null;
      }
    }).then((locationData) {
      if (locationData == null) {
        throw Exception("No location data");
      }
      print("Posisinya adalah:");
      // print(locationData);
      _currentPosition = locationData;
      return geolocator.placemarkFromPosition(locationData);
    }).then((List<Placemark> addresses) {
      Placemark place = addresses[0];
      _currentAddressComplete =
          "${place.thoroughfare} ${place.subThoroughfare}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
      _currentAddress = "${place.locality}";
    }).catchError((onError) {
      print(onError);
    });

    geolocator
        .getPositionStream(_locationOptions, _locationPermission)
        .listen((position) {
      _currentPosition = position;
      print("masuk stream location");
      print(_currentPosition);
      geolocator
          .placemarkFromPosition(_currentPosition)
          .then((List<Placemark> addresses) {
        Placemark place = addresses[0];
        setState(() {
          _currentAddressComplete =
              "${place.thoroughfare} ${place.subThoroughfare}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
          _currentAddress = "${place.locality}";
        });
      })
            ..catchError((onError) {
              print(onError);
            });
    });
    tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollListener();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabBar = TabBar(
      controller: tabController,
      indicator: MD2Indicator(
        indicatorSize: MD2IndicatorSize.normal,
        indicatorHeight: 4.0,
        indicatorColor: Colors.green,
      ),
      indicatorColor: Colors.black,
      labelColor: Colors.black,
      tabs: [
        Tab(
          iconMargin: EdgeInsets.all(5),
          text: "All",
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.blue[400]),
            child: Center(
              child: Icon(
                Icons.widgets,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Tab(
          text: "Hill",
          iconMargin: EdgeInsets.all(5),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.green[400]),
            child: Center(
              child: Icon(
                Icons.filter_hdr,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Tab(
          text: "Beach",
          iconMargin: EdgeInsets.all(5),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.orange[400]),
            child: Center(
              child: Icon(
                Icons.beach_access,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Tab(
          text: "Hotel",
          iconMargin: EdgeInsets.all(5),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.cyan[400]),
            child: Center(
              child: Icon(
                Icons.hotel,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, isScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 280,
            pinned: true,
            actions: [
              AnimatedOpacity(
                opacity: isShrink ? 1.0 : 0.0,
                duration: Duration(milliseconds: 250),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      Text(
                        _currentAddress == null
                            ? "Sedang mencari lokasi..."
                            : _currentAddress,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.green[600],
                      )
                    ],
                  ),
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedOpacity(
                opacity: isShrink ? 1.0 : 0.0,
                duration: Duration(milliseconds: 250),
                child: Text(
                  "Discover",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              titlePadding: EdgeInsetsDirectional.only(
                  start: 16, bottom: tabBar.preferredSize.height + 16),
              background: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          getImages(imageUrl),
                        ],
                      )),
                ],
              ),
            ),
            bottom: PreferredSize(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                color: Colors.white,
                child: tabBar,
              ),
              preferredSize: Size(double.infinity, tabBar.preferredSize.height),
            ),
          ),
        ],
        body: TabBarView(controller: tabController, children: <Widget>[
          _listData(context, 'all'),
          _listData(context, 'hill'),
          _listData(context, 'beach'),
          _listData(context, 'hotel')
        ]),
      ),
    );
  }

  Widget _listData(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 3 / 4.2,
        ),
        children: category == 'all'
            ? tourismPlaceList.map((place) {
                return _itemsData(context, place);
              }).toList()
            : tourismPlaceList
                .where((element) => element.category == category)
                .map((place) {
                return _itemsData(context, place);
              }).toList(),
      ),
    );
  }

  Widget _itemsData(BuildContext context, TourismPlace place) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
      openElevation: 0,
      closedElevation: 0,
      closedBuilder: (context, action) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 5 / 4.5,
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          place.imageAsset,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      // width: 100,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              topLeft: Radius.circular(8)),
                          color: Colors.red[900]),
                      child: Text(
                        place.location,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    place.name,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: double.parse(place.ratingAvg),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 1,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 15),
                        child: Text(place.ratingAvg,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(FormatHelper.formatCurrency(
                      double.parse(place.ticketPrice.toString()))),
                ],
              ),
            )
          ],
        );
      },
      openBuilder: (context, action) {
        return DetailScreen(place: place);
      },
    );
  }

  Widget getImages(String imageUrl) {
    return Container(
      child: Stack(
        children: [
          CarouselSlider(
            items: imageUrl.split(',').map((fileImage) {
              return GestureDetector(
                onTap: () {
                  _modalBottomimages(context, _current,
                      imageUrl.split(',').map((e) => e).toList());
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                      child: CachedNetworkImage(
                    imageUrl: fileImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                        child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )),
                    errorWidget: (context, url, error) => Center(
                        child: Image.asset(
                      "assets/default_image.png",
                      fit: BoxFit.cover,
                    )),
                  )),
                ),
              );
            }).toList(),
            height: double.infinity,
            enableInfiniteScroll: true,
            aspectRatio: 16 / 9,
            autoPlay: true,
            viewportFraction: 1.0,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 200),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageUrl.split(',').map((url) {
                  int index = imageUrl.split(',').indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Colors.red[600]
                            : Colors.grey[300]),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _modalBottomimages(
      BuildContext context, int number, List<String> imageUrl) {
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
