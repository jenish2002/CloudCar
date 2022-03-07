import 'dart:async';
import 'dart:ui' as ui;
import 'package:car_app/model/car_model.dart';
import 'package:car_app/model/upcoming_model.dart';
import 'package:car_app/model/user_model.dart';
import 'package:car_app/screens/filter_car_screen.dart';
import 'package:car_app/screens/safest_car_screen.dart';
import 'package:car_app/screens/search_screen.dart';
import 'package:car_app/screens/trending_cars_screen.dart';
import 'package:car_app/screens/upcoming_car_screen.dart';
import 'package:car_app/screens/view_car_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'compare_car_screen.dart';
import 'login_screen.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  final String value;
  const HomeScreen({Key? key, required this.value}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<CarModel> safeCars = [];
  List<CarModel> trendingCars = [];
  List<UpcomingModel> upcomingCars = [];
  bool isVisibleCar = false;
  bool isVisibleUpcomingCar = false;
  CarModel carModel = CarModel();
  UpcomingModel upcomingModel = UpcomingModel();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool isLoading = false;
  late Timer timer;
  late double _width;
  late double _height;
  final ScrollController scrollController = ScrollController();

  fetchUserAndCar() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then((value) {
      loggedInUser = UserModel.fromJson(value.data()!);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.value == "login") {
      setState(() {
        timer = Timer.periodic(const Duration(hours: 2), (_) => logout(context));
      });
    }
    fetchUserAndCar();
    getCars();
    getUpcomingCars();
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                excludeHeaderSemantics: true,
                backgroundColor: Colors.white,
                floating: false,
                pinned: true,
                snap: false,
                forceElevated: innerBoxIsScrolled,
                elevation: 0,
                bottom: const PreferredSize(
                  preferredSize: Size(double.infinity, 0),
                  child: Divider(color: Colors.black26, height: 0, thickness: 2),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      _scaffoldKey.currentState?.openDrawer();
                    });
                  }
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 55),
                        child: const Text(
                          "Cloud Car",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ];
          },
          body: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black26)
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SearchScreen("home"))
                            );
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "Search Car",
                              fillColor: Colors.black12,
                              filled: true,
                              suffixIcon: const Icon(Icons.search_rounded),
                              contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "Browse Cars By",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Divider(
                            height: 20,
                            thickness: 2,
                            indent: 110,
                            endIndent: 110,
                            color: Colors.redAccent
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const FilterCar("Brand"))
                                );
                                FocusScope.of(context).unfocus();
                              },
                              child: selectCarDesign(_height, _width, "Brand", Icons.star_half_rounded),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const FilterCar("Fuel Type"))
                                );
                                FocusScope.of(context).unfocus();
                              },
                              child: selectCarDesign(_height, _width, "Fuel Type", Icons.local_gas_station_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const FilterCar("Budget"))
                                );
                                FocusScope.of(context).unfocus();
                              },
                              child: selectCarDesign(_height, _width, "Budget", Icons.local_atm_rounded),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const FilterCar("Body Type"))
                                );
                                FocusScope.of(context).unfocus();
                              },
                              child: selectCarDesign(_height, _width, "Body Type", Icons.directions_car_filled_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  (isVisibleUpcomingCar) ? Column(
                    children: <Widget>[
                      const SizedBox(height: 25),
                      const Text(
                        "Upcoming Launches",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(
                          height: 20,
                          thickness: 2,
                          indent: 108,
                          endIndent: 108,
                          color: Colors.redAccent
                      ),
                      const SizedBox(height: 5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: displayUpcomingCars(),
                        ),
                      ),
                    ],
                  ) : Container(),
                  (isVisibleCar) ? Column(
                    children: <Widget>[
                      const SizedBox(height: 25),
                      const Text(
                        "Safest Cars",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(
                          height: 20,
                          thickness: 2,
                          indent: 150,
                          endIndent: 150,
                          color: Colors.redAccent
                      ),
                      const SizedBox(height: 5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: displayCars("safe"),
                        ),
                      ),
                    ],
                  ) : Container(),
                  (isVisibleCar) ? Column(
                    children: <Widget>[
                      const SizedBox(height: 25),
                      const Text(
                        "Trending Cars",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(
                          height: 20,
                          thickness: 2,
                          indent: 138,
                          endIndent: 138,
                          color: Colors.redAccent
                      ),
                      const SizedBox(height: 5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: displayCars("trending"),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ) : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                        child: Icon(Icons.person, color: Colors.white, size: 35),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(isLoading ? "Loading..." : "${loggedInUser.firstName} ${loggedInUser.secondName}",
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 5),
                        Text(isLoading ? "Loading..." : "${loggedInUser.email}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            )
                        ),
                      ],
                    ),
                  ],
                )
              )
            ),
            const Divider(thickness: 1, indent: 10, endIndent: 10, color: Colors.black38),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const ListTile(
                title: Text('Search Car',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )
                ),
              leading: Icon(Icons.search_rounded),
              )
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CompareCarScreen()));
              },
              child: const ListTile(
                title: Text('Compare Cars',
                   style: TextStyle(
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                   )
                ),
                leading: Icon(Icons.directions_car_filled_rounded),
              )
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SafestCar()));
              },
              child: const ListTile(
                title: Text('Safest Cars',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )
                ),
                leading: Icon(Icons.accessibility_rounded),
              )
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TrendingCar()));
              },
              child: const ListTile(
                title: Text('Trending Cars',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )
                ),
                leading: Icon(Icons.insert_chart_rounded),
              )
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UpcomingCar()));
              },
              child: const ListTile(
                title: Text('Upcoming Launch',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )
                ),
                leading: Icon(Icons.notifications_active),
              )
            ),
            InkWell(
              onTap: () {
                logout(context);
              },
              child: const ListTile(
                title: Text('Log Out',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )
                ),
                leading: Icon(Icons.logout_rounded),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget displayUpcomingCars() {
    return Row(
      children: <Widget>[
        const SizedBox(width: 5),
        for(int i = 0; i < upcomingCars.length; i++)
        Container(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black12),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  width: _width/1.57,
                  child: Image.network(
                    upcomingCars[i].image!,
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder:(BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const Center(child: CircularProgressIndicator());
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top:13, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        upcomingCars[i].name!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        //price with inr symbol
                        "Estimated Price: \u{20B9} " + upcomingCars[i].price!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Expected Date: " + upcomingCars[i].date!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Fuel: " + upcomingCars[i].fuelType!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget displayCars(String data) {
    var length = (data.compareTo("safe") == 0) ? safeCars.length : trendingCars.length;
    return Row(
      children: <Widget>[
        const SizedBox(width: 5),
        for(int i = 0; i < length; i++)
        GestureDetector(
          onTap: () {
            var id = (data.compareTo("safe") == 0) ? safeCars[i].carId! : trendingCars[i].carId!;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewCar(id)));
          },
          child: Container(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black12),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    width: _width/1.6,
                    child: Image.network(
                      (data.compareTo("safe") == 0) ? safeCars[i].image! : trendingCars[i].image!,
                      loadingBuilder: (context, child, loadingProgress) {
                        if(loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder:(BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top:13, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          (data.compareTo("safe") == 0) ?
                          safeCars[i].brand! + " " + safeCars[i].name! + " " + safeCars[i].variant! :
                          trendingCars[i].brand! + " " + trendingCars[i].name! + " " + trendingCars[i].variant!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          //price with inr symbol
                          (data.compareTo("safe") == 0) ? "Price: \u{20B9} " + safeCars[i].price! :
                          "Price: \u{20B9} " + trendingCars[i].price!,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            const Text(
                              "Safety: ",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            (data.compareTo("safe") == 0) ?
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Icon(
                                  (index < double.tryParse(safeCars[i].ncapRating!)!) ?
                                  ((double.tryParse(safeCars[i].ncapRating!)! - index.toDouble()) == 0.5) ?
                                  Icons.star_half : Icons.star : Icons.star_border,
                                  color: Colors.green,
                                );
                              }),
                            ) :
                            (trendingCars[i].ncapRating!.compareTo("Not Tested") == 0) ?
                            Text(
                              trendingCars[i].ncapRating!,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ) :
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Icon(
                                  (index < double.tryParse(trendingCars[i].ncapRating!)!) ?
                                  ((double.tryParse(trendingCars[i].ncapRating!)! - index.toDouble()) == 0.5) ?
                                  Icons.star_half : Icons.star : Icons.star_border,
                                  color: Colors.green,
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  getUpcomingCars() async {
    setState(() {
      isVisibleUpcomingCar = false;
    });
    await FirebaseFirestore.instance.collection("upcomingcars").get().then((val) {
      for(int i = 0; i < val.docs.length; i++) {
        upcomingModel =  UpcomingModel.fromJson(val.docs[i].data());
        upcomingCars.add(upcomingModel);
      }
    });
    setState(() {
      isVisibleUpcomingCar = true;
    });
  }

  getCars() async {
    setState(() {
      isVisibleCar = false;
    });
    await FirebaseFirestore.instance.collection("cars").get().then((val) async {
      for(int i = 0; i < val.docs.length; i++) {
        carModel = CarModel.fromJson(val.docs[i].data());
        if(carModel.ncapRating!.compareTo("5") == 0) {
          safeCars.add(carModel);
        }
        if(carModel.trending!.compareTo("True") == 0) {
          trendingCars.add(carModel);
        }
      }
    });
    setState(() {
      isVisibleCar = true;
    });
  }

  //logout function
  Future<void> logout(BuildContext context) async {
    if(widget.value == "login") {
      timer.cancel();
    }
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Widget selectCarDesign(_height, _width, title, icon) {
    return Container(
      width: _width / 2.5,
      height: 150,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.redAccent,
              width: 3
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.redAccent,//black54,
            size: 65,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}