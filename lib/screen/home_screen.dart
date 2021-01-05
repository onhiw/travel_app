import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:submission_flutter/model/tourism_place.dart';
import 'package:submission_flutter/screen/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Discovery',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.black,
            tabs: [
              Tab(
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
            controller: tabController,
          ),
          Expanded(
            flex: 40,
            child: TabBarView(controller: tabController, children: <Widget>[
              _listData(context, 'all'),
              _listData(context, 'hill'),
              _listData(context, 'beach'),
              _listData(context, 'hotel')
            ]),
          ),
        ],
      ),
    );
  }

  Widget _listData(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3 / 4,
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
}

Widget _itemsData(BuildContext context, TourismPlace place) {
  return OpenContainer(
    transitionDuration: Duration(milliseconds: 500),
    openElevation: 0,
    closedElevation: 0,
    closedBuilder: (context, action) {
      return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 150,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.network(
                    place.imageAsset,
                    fit: BoxFit.cover,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                        rating: place.ratingAvg,
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
                        child: Text(place.ratingAvg.toString(),
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
                  Text(place.location),
                ],
              ),
            )
          ],
        ),
      );
    },
    openBuilder: (context, action) {
      return DetailScreen(place: place);
    },
  );
}

var tourismPlaceList = [
  TourismPlace(
    name: 'Gunung Rinjani',
    location: 'Lombok',
    description:
        'Gunung Rinjani merupakan salah satu gunung berapi aktif tertinggi di Indonesia, tepatnya gunung api tertinggi kedua setelah Gunung Kerinci di Jambi, dan gunung tertinggi ketiga di Indonesia setelah Gunung Carstensz dan Gunung Kerinci. Gunung Rinjani memiliki ketinggian 3.726 meter di atas permukaan laut (mdpl), berlokasi di Taman Nasional Gunung Rinjani, Lombok, Nusa Tenggara Barat.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 00:00',
    ticketPrice: '25000',
    imageAsset:
        'https://asset.kompas.com/crop/0x0:780x520/750x500/data/photo/2019/07/17/5d2efaa577722.jpg',
    category: 'hill',
    ratingAvg: 5,
    imageUrls: [
      'https://asset.kompas.com/crops/D0WpDEBPo9zmC9XTDAOMWvx0MpI=/0x0:780x520/750x500/data/photo/2019/07/17/5d2efa143900b.jpg',
      'https://asset.kompas.com/crops/y4S8NYe8ExNdzPjKhDzHCI89zxA=/0x0:780x520/750x500/data/photo/2019/07/17/5d2efa5cdcfc6.jpg',
      'https://asset.kompas.com/crops/EZxUbFlBMu3UoEZpiAbPj5QurF4=/0x0:780x520/750x500/data/photo/2019/07/17/5d2efb39e4ad6.jpg'
    ],
  ),
  TourismPlace(
    name: 'Hotel Borobudur',
    location: 'Jakarta',
    description:
        'Hotel Borobudur terletak di pusat Jakarta dan hanya berjarak 5 menit berkendara dari Istana Merdeka. Hotel ini memiliki kolam renang outdoor ukuran olimpiade, 7 pilihan restoran, spa, dan WiFi gratis di seluruh area hotel. Kamar-kamar didekorasi secara klasik dengan lantai karpet, perabotan kayu, dan AC yang akan membuatmu merasa nyaman. Ada juga fasilitas TV layar datar dengan saluran kabel, fasilitas membuat kopi/teh, dan area tempat duduk. Di kamar mandi terdapat perlengkapan mandi gratis, bathtub, dan shower. Kamu juga bisa memesan santapan di dalam kamar. Ada berbagai pilihan tempat makan lainnya untuk kamu. Di Bogor Cafe, kamu bisa mencicipi sop buntut atau hidangan internasional lainnya, sedangkan di Bruschetta Italian Restaurant kamu bisa menyantap hidangan khas Italia. Bagi kamu yang berselera oriental, bisa coba makanan khas Jepang di Miyama Japanese Restaurant atau masakan Chinese di Teratai Chinese Restaurant. Ada juga Borobudur Gourmet yang menyediakan kue-kue, atau kamu bisa minum wine di Churchill Wine & Cigar Bar serta bersantai di Pendopo Lounge.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 23:30',
    ticketPrice: '200000',
    imageAsset:
        'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/28/0af21b53-5035-49f8-951e-f1d98ad0c230-1603874732552-3894827b82fe54f1d406a59dee0ae421.jpg',
    category: 'hotel',
    ratingAvg: 4.5,
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/28/6976f89f-179b-4c4c-b2e7-009a08c28096-1603875052566-ae48c823d69b23956e4a26e03dc6aeb3.jpg',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/28/b747ddb5-8304-4f1c-9fc3-2adf41442cdf-1603874732367-872d7ea179763cba369e03b885d42839.jpg',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/29/4a287f78-76ea-4bbe-9f44-459c70ede104-1603921732017-c5c216f0aba7c0d6de349f56e8874ef1.jpg',
    ],
  ),
  TourismPlace(
    name: 'Pulau Tidung',
    location: 'Jakarta',
    description:
        'Pulau Tidung terbagi menjadi dua yaitu, Pulau Tidung Besar dan Pulau Tidung Kecil. Penggunaan wilayah pulau ini berkembang ke arah wisata bahari seperti menyelam dan penelitian terhadap terumbu karang. Pulau Tidung Besar dan Tidung Kecil dihubungkan oleh jembatan panjang yang dinamakan Jembatan Cinta oleh penduduk setempat yang terletak di Kepulauan Seribu Selatan bagian barat, dengan jarak tempuh kurang lebih 3 jam perjalanan dari Muara Angke dengan kapal penumpang. Mulai September 2017, wisatawan bisa memilih transportasi alternatif KM Express Bahari, yang disediakan PT. Pelni, yang bisa mempercepat perjalanan menjadi 1 jam saja.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 23:30',
    ticketPrice: '200000',
    imageAsset:
        'https://ik.imagekit.io/tvlk/xpe-asset/AyJ40ZAo1DOyPyKLZ9c3RGQHTP2oT4ZXW+QmPVVkFQiXFSv42UaHGzSmaSzQ8DO5QIbWPZuF+VkYVRk6gh-Vg4ECbfuQRQ4pHjWJ5Rmbtkk=/2001651783316/2D1N%2520Tidung%2520Island%2520at%2520Thousand%2520Islands-49268050-70d9-4af2-b31d-5eba84f29e40.jpeg?_src=imagekit&tr=dpr-2,c-at_max,h-1280,q-60,w-720',
    category: 'beach',
    ratingAvg: 5,
    imageUrls: [
      'https://ik.imagekit.io/tvlk/xpe-asset/AyJ40ZAo1DOyPyKLZ9c3RGQHTP2oT4ZXW+QmPVVkFQiXFSv42UaHGzSmaSzQ8DO5QIbWPZuF+VkYVRk6gh-Vg4ECbfuQRQ4pHjWJ5Rmbtkk=/2001651783316/2D1N%2520Tidung%2520Island%2520at%2520Thousand%2520Islands-7d723671-ac30-4b49-8409-086920fd4029.jpeg?_src=imagekit&tr=dpr-2,c-at_max,h-1280,q-60,w-720',
      'https://ik.imagekit.io/tvlk/xpe-asset/AyJ40ZAo1DOyPyKLZ9c3RGQHTP2oT4ZXW+QmPVVkFQiXFSv42UaHGzSmaSzQ8DO5QIbWPZuF+VkYVRk6gh-Vg4ECbfuQRQ4pHjWJ5Rmbtkk=/2001651783316/2D1N%2520Tidung%2520Island%2520at%2520Thousand%2520Islands-47bc0a10-aaaf-414b-99dd-7e22da4cde08.jpeg?_src=imagekit&tr=dpr-2,c-at_max,h-1280,q-60,w-720',
      'https://ik.imagekit.io/tvlk/xpe-asset/AyJ40ZAo1DOyPyKLZ9c3RGQHTP2oT4ZXW+QmPVVkFQiXFSv42UaHGzSmaSzQ8DO5QIbWPZuF+VkYVRk6gh-Vg4ECbfuQRQ4pHjWJ5Rmbtkk=/2001651783316/2D1N%2520Tidung%2520Island%2520at%2520Thousand%2520Islands-71c31fea-675c-4d14-9393-fa92bf4065a3.jpeg?_src=imagekit&tr=dpr-2,c-at_max,h-1280,q-60,w-720',
    ],
  ),
  TourismPlace(
    name: 'Gunung Salak',
    location: 'Bogor',
    description:
        'Gunung Salak merupakan kompleks gunung berapi yang terletak di selatan Jakarta, di Pulau Jawa. Kawasan rangkaian gunung ini termasuk ke dalam wilayah Kabupaten Sukabumi dan Kabupaten Bogor, Jawa Barat. Pengelolaan kawasan hutannya semula berada di bawah Perum Perhutani Kesatuan Pemangkuan Hutan (KPH) Bogor, tetapi sejak 2003 menjadi wilayah perluasan Taman Nasional Gunung Halimun, dan dikelola sebagai Taman Nasional Gunung Halimun-Salak.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 00:00',
    ticketPrice: '30000',
    imageAsset:
        'https://cdn-2.tstatic.net/wartakota/foto/bank/images/20180502-gunung-salak_20180502_201710.jpg',
    category: 'hill',
    ratingAvg: 5,
    imageUrls: [
      'https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,q_auto:best,w_1024/v1539238001/yhmgfreqzatlkfeo5jqa.jpg',
      'https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,q_auto:best,w_1024/v1539322347/pnmssczsqbu623k9temt.jpg',
      'https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,q_auto:best,w_1024/v1539322318/lxdpzj7tgpl5a53f4wdr.jpg',
    ],
  ),
  TourismPlace(
    name: 'GH Universal',
    location: 'Kota Bandung',
    description:
        'GH Universal Bandung terletak di Bandung Utara dan hanya berjarak 20 menit berkendara dari pusat perbelanjaan populer, Paris Van Java. Hotel yang elegan ini memiliki kolam renang outdoor, spa dan fasilitas rapat/perjamuan. Tamu dapat mengakses WiFi gratis di kamar dan area publik hotel.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 23:30',
    ticketPrice: '1000000',
    imageAsset:
        'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/rsfit1024692gsm/tix-hotel/images-web/2020/10/16/1b399221-e0c6-4da6-ba7b-968edf80933b-1602816899958-9ba85929c9764578d4241b504fdc0e61.jpg',
    category: 'hotel',
    ratingAvg: 5,
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/28/ecaad44f-9b7b-4f46-8d48-f2f6013a7b76-1603872564572-e894a5225c7da709502e1eb6e1f5a026.jpg',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/11/01/d62b90ab-3ed5-4cc4-a497-1f58372e56fe-1604179689790-90b0277e08a81b6b69a3a45e26f6fa2a.jpg',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/11/01/29635209-3cef-4a17-97e6-25f340b7b292-1604179689760-3c943f6631a48551e158f33d949cfe26.jpg',
    ],
  ),
  TourismPlace(
    name: 'Pantai Kuta',
    location: 'Bali',
    description:
        'Pantai Kuta adalah sebuah tempat pariwisata yang terletak kecamatan Kuta, sebelah selatan Kota Denpasar, Bali, Indonesia. Daerah ini merupakan sebuah tujuan wisata turis mancanegara dan telah menjadi objek wisata andalan Pulau Bali sejak awal tahun 1970-an. Pantai Kuta sering pula disebut sebagai pantai matahari terbenam (sunset beach) sebagai lawan dari pantai Sanur. Selain itu, Lapangan Udara I Gusti Ngurah Rai terletak tidak jauh dari Kuta.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 23:30',
    ticketPrice: '30000',
    imageAsset:
        'https://blog.tripcetera.com/id/wp-content/uploads/2020/03/leebudihart_76864081_2484833498431751_3194446755026370817_n-1080x508.jpg',
    category: 'beach',
    ratingAvg: 4.5,
    imageUrls: [
      'https://www.kintamani.id/wp-content/uploads/Keindahan-Pantai-Kuta-Bali-yang-sanggup-menarik-ribuan-wisatawan-setiap-tahunnya.jpg',
      'https://anekatempatwisata.com/wp-content/uploads/2014/10/Pantai-Kuta-3.jpg',
      'https://blogkulo.com/wp-content/uploads/2015/10/Pantai-Kuta-Bali.jpg',
    ],
  ),
  TourismPlace(
    name: 'Gunung Pangrango',
    location: 'Lembang',
    description:
        'Gunung Pangrango merupakan sebuah gunung yang terdapat di pulau Jawa, Indonesia. Gunung Pangrango mempunyai ketinggian setinggi 3.019 meter dari permukaan laut. Puncaknya dinamakan Puncak Mandalawangi. Puncak Mandalawangi juga merupakan titik pertemuan batas tiga kabupaten yaitu Kabupaten Bogor, Kabupaten Cianjur dan Kabupaten Sukabumi.',
    openDays: 'Open Everyday',
    openTime: '09:00 - 00:00',
    ticketPrice: '25000',
    imageAsset:
        'https://asset.kompas.com/crops/ay0NtLh9ubfDEELh1LLG6fwDHIU=/5x0:1000x663/750x500/data/photo/2020/10/20/5f8eb67f00b85.jpg',
    category: 'hill',
    ratingAvg: 4.5,
    imageUrls: [
      'https://ik.imagekit.io/tvlk/blog/2020/01/23667850_260054371187402_4427833509461098496_n-1024x683-1.jpg?tr=-undefined,dpr-2,w-675',
      'https://static.republika.co.id/uploads/images/inpicture_slide/taman-nasional-gunung-pangrango-_120611114834-755.jpg',
      'https://phinemo.com/wp-content/uploads/2017/08/gede-1.jpg',
    ],
  ),
  TourismPlace(
    name: 'The Ritz Carlton',
    location: 'Bali',
    description:
        'Terletak di garis pantai Bali yang masih alami di Nusa Dua, The Ritz-Carlton Bali menawarkan tempat liburan tropis mewah yang memiliki spa hotel, kolam renang outdoor besar dan fasilitas rapat/perjamuan. WiFi gratis bisa diakses di seluruh area hotel. The Ritz-Carlton Bali hadir dengan suite luas dan vila yang menonjolkan desain tropis kontemporer. Suite dilengkapi dengan TV layar datar dengan saluran TV kabel, AC, area tempat duduk terbuka dengan sofa serta balkon yang menghadap ke pelataran resor atau Samudera Hindia yang cerah. Vila menyediakan kolam renang outdoor pribadi, area makan khusus dan ruang keluarga dan kamar tidur terpisah. Kamar mandi dalam memiliki bathtub, shower, serta peralatan mandi gratis.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 23:30',
    ticketPrice: '2500000',
    imageAsset:
        'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/29/05452d5f-aae5-4c8e-92d9-a3a7bdb40e61-1603915036936-1426f7420a385f1fe78817d0dbb5cb09.jpg',
    category: 'hotel',
    ratingAvg: 5,
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/rsfit1024692gsm/tix-hotel/images-web/2020/09/20/139efc89-6e2d-4491-9f43-fe1b87e6732d-1600550361248-f2bf0d4e7214222a76053d8259820e43.jpg',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/29/ce843220-6157-4226-8051-6b0f16e3b2c3-1603915038153-b200b22a4ef9fdea4ad318dd385c865a.jpg',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/29/5630873b-32d5-4014-a8be-bc88e62c1d55-1603915037258-f2b7d2d2cca0d5e0f10319be340bce2a.jpg',
    ],
  ),
  TourismPlace(
    name: 'Gili Trawangan',
    location: 'Lombok',
    description:
        'Gili Trawangan adalah yang terbesar dari ketiga pulau kecil atau gili yang terdapat di sebelah barat laut Lombok. Trawangan juga satu-satunya gili yang ketinggiannya di atas permukaan laut cukup signifikan. Dengan panjang 3 km dan lebar 2 km, Trawangan berpopulasi sekitar 800 jiwa. Di antara ketiga gili tersebut, Trawangan memiliki fasilitas untuk wisatawan yang paling beragam; kedai "Tîr na Nôg" mengklaim bahwa Trawangan adalah pulau terkecil di dunia yang ada bar Irlandia-nya. Bagian paling padat penduduk adalah sebelah timur pulau ini.',
    openDays: 'Open Everyday',
    openTime: '06:00 - 23:30',
    ticketPrice: '20000',
    ratingAvg: 4.5,
    imageAsset:
        'https://www.balitoursclub.net/wp-content/uploads/2018/03/Pulau-Gili-Trawangan-Lombok.jpg',
    category: 'beach',
    imageUrls: [
      'https://cdn-2.tstatic.net/tribunnews/foto/bank/images/pantai-gili-trawangan-lagiiiii_20170221_203037.jpg',
      'https://static.republika.co.id/uploads/images/inpicture_slide/keindahan-pantai-gili-trawangan-_160121105132-332.png',
      'https://images.squarespace-cdn.com/content/v1/5372cd85e4b0bbcc0ca2de9d/1408088792660-4V248OYCS8BDU85Z5UH9/ke17ZwdGBToddI8pDm48kAYm5udLXiBF8MTrANLCX2EUqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKc3otCeZ9Eg0GVJKlgdSCwUaOCTef6zyaicwvvfSTdg0cTR9_IT0E3VjIr-4HP0hDM/Gili-Trawangan-Lombok-Hotel-Rooms-Facilities-Beach-Beachfront-Ocean-Sun-Chair-White-Sand-03.jpg?format=1500w',
    ],
  ),
];
