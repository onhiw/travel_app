class TourismPlace {
  String id;
  String name;
  String location;
  String description;
  String openDays;
  String openTime;
  String ticketPrice;
  String imageAsset;
  String category;
  String ratingAvg;
  bool favored;
  String imageUrls;

  TourismPlace({
    this.id,
    this.name,
    this.location,
    this.description,
    this.openDays,
    this.openTime,
    this.ticketPrice,
    this.imageAsset,
    this.category,
    this.ratingAvg,
    this.favored,
    this.imageUrls,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["location"] = location;
    map["description"] = description;
    map["openDays"] = openDays;
    map["openTime"] = openTime;
    map["ticketPrice"] = ticketPrice;
    map["imageAsset"] = imageAsset;
    map["category"] = category;
    map["ratingAvg"] = ratingAvg;
    map["favored"] = favored;
    map["imageUrls"] = imageUrls;

    return map;
  }

  TourismPlace.fromDB(Map map)
      : id = map['id'],
        name = map['name'],
        location = map['location'],
        description = map['description'],
        openDays = map['openDays'],
        openTime = map['openTime'],
        ticketPrice = map['ticketPrice'],
        imageAsset = map['imageAsset'],
        category = map['category'],
        ratingAvg = map['ratingAvg'],
        favored = map['favored'] == 1 ? true : false,
        imageUrls = map['imageUrls'];
}
