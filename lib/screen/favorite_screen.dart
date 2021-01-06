import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission_flutter/model/tourism_place.dart';
import 'package:submission_flutter/screen/detail_screen.dart';
import 'package:submission_flutter/utils/dbhelper.dart';
import 'package:submission_flutter/utils/helper.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<TourismPlace> filteredProduct = List();
  List<TourismPlace> productCache = List();

  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    filteredProduct = [];
    productCache = [];
    subject.stream.listen(searchDataList);
    setUpList();
  }

  void setUpList() async {
    DbHelper db = DbHelper();
    filteredProduct = await db.getFavorites();
    setState(() {
      productCache = filteredProduct;
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void searchDataList(query) {
    if (query.isEmpty) {
      setState(() {
        filteredProduct = productCache;
      });
    } else {
      setState(() {});
      filteredProduct = filteredProduct
          .where((m) => m.name
              .toLowerCase()
              .trim()
              .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
          .toList();
      setState(() {});
    }
  }

  void onPressed(int index) {
    setState(() {
      DbHelper db = DbHelper();
      db.deleteFavorite(filteredProduct[index].id);
      filteredProduct.remove(filteredProduct[index]);
      Fluttertoast.showToast(
          msg: "Produk berhasil dihapus dari daftar favorite anda",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent[400],
          fontSize: 12,
          textColor: Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Container(
          color: Colors.white,
          child: TextField(
            onChanged: (String string) => (subject.add(string)),
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: "Cari favorite",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              fillColor: Colors.grey[100],
              filled: true,
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            filteredProduct.length != 0
                ? Expanded(
                    child: ListView.separated(
                      itemCount: filteredProduct.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // margin: EdgeInsets.only(left: 16, right: 16),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(
                                left: 10, right: 10, top: 8, bottom: 8),
                            title: Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: filteredProduct[index]
                                                .imageAsset,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Shimmer.fromColors(
                                              baseColor: Colors.grey[300],
                                              highlightColor: Colors.grey[100],
                                              child: Container(
                                                color: Colors.white,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            )),
                                            errorWidget:
                                                (context, url, error) => Center(
                                                    child: Image.asset(
                                              "assets/default_image.png",
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height: 35,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(8),
                                                    topLeft:
                                                        Radius.circular(8)),
                                                color: Colors.red[900]),
                                            child: Text(
                                              filteredProduct[index].location,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filteredProduct[index].name,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              RatingBarIndicator(
                                                rating: double.parse(
                                                    filteredProduct[index]
                                                        .ratingAvg),
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 1,
                                                itemSize: 20.0,
                                                direction: Axis.horizontal,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 8, right: 15),
                                                child: Text(
                                                    filteredProduct[index]
                                                        .ratingAvg,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              filteredProduct[index].category ==
                                                      'hill'
                                                  ? Icon(Icons.filter_hdr,
                                                      color: Colors.green[400])
                                                  : filteredProduct[index]
                                                              .category ==
                                                          'beach'
                                                      ? Icon(Icons.beach_access,
                                                          color: Colors
                                                              .orange[400])
                                                      : filteredProduct[index]
                                                                  .category ==
                                                              'hotel'
                                                          ? Icon(Icons.hotel,
                                                              color: Colors
                                                                  .cyan[400])
                                                          : Container(),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                    filteredProduct[index]
                                                        .category
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            FormatHelper.formatCurrency(
                                                double.parse(
                                                    filteredProduct[index]
                                                        .ticketPrice
                                                        .toString())),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.redAccent[400],
                                        ),
                                        iconSize: 30,
                                        onPressed: () {
                                          print(index);
                                          onPressed(index);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailScreen(
                                    place: filteredProduct[index]);
                              }));
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text("Belum Ada Favorite"),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
