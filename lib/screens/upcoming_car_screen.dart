import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:car_app/model/upcoming_model.dart';
import 'package:flutter/rendering.dart';

class UpcomingCar extends StatefulWidget {
  const UpcomingCar({Key? key}) : super(key: key);

  @override
  _UpcomingCarState createState() => _UpcomingCarState();
}

class _UpcomingCarState extends State<UpcomingCar> {

  bool isLoading = false;
  List<UpcomingModel> cars = [];
  UpcomingModel upcomingModel = UpcomingModel();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUpcomingCars();
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: const Color(0xff000000).withOpacity(.07),
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  excludeHeaderSemantics: true,
                  collapsedHeight: 60,
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
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        //go back button
                        Navigator.of(context).pop();
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
                            "Upcoming Launch",
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
              child: (isLoading) ? const Center(child: CircularProgressIndicator()) :
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: displayCars(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget displayCars() {
    return Column(
      children: <Widget>[
        for(int i = 0; i < cars.length; i++)
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.transparent),
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Image.network(
                    cars[i].image!,
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
                  padding: const EdgeInsets.only(left: 10, right: 10, top:13, bottom: 13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 5),
                      Text(
                        cars[i].name!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        //price with inr symbol
                        "Estimated Price: \u{20B9} " + cars[i].price!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Expected Date: " + cars[i].date!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Fuel: " + cars[i].fuelType!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
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

  getUpcomingCars() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection("upcomingcars").get().then((val) {
      for(int i = 0; i < val.docs.length; i++) {
        upcomingModel =  UpcomingModel.fromJson(val.docs[i].data());
        cars.add(upcomingModel);
      }
    });
    setState(() {
      isLoading = false;
    });
  }
}
