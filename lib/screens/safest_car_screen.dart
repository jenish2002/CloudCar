import 'dart:ui' as ui;
import 'package:car_app/model/car_model.dart';
import 'package:car_app/screens/view_car_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SafestCar extends StatefulWidget {
  const SafestCar({Key? key}) : super(key: key);

  @override
  _SafestCarState createState() => _SafestCarState();
}

class _SafestCarState extends State<SafestCar> {

  List<CarModel> cars = [];
  bool isLoading = true;
  CarModel carModel = CarModel();
  late double _width;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getSafestCars();
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
    _width = MediaQuery.of(context).size.width;

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
                            "Safest Cars",
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
                  padding: const EdgeInsets.all(7),
                  width: _width,
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
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewCar(cars[i].carId!)));
          },
          child: Container(
            padding: const EdgeInsets.only(bottom: 7),
            child: Container(
              padding: const EdgeInsets.only(left: 2, right: 5, top:5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.transparent),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 50,
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
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Text(
                          cars[i].brand! + " " + cars[i].name! + " " + cars[i].variant!,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 21,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          //price with inr symbol
                          "Price: \u{20B9} " + cars[i].price!,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
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
                                fontSize: 17,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(int.parse(cars[i].ncapRating!), (index) {
                                return const Icon(
                                  Icons.star,
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

  getSafestCars() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection("cars").get().then((val) async {
      for(int i = 0; i < val.docs.length; i++) {
        carModel = CarModel.fromJson(val.docs[i].data());
        if (carModel.ncapRating!.compareTo("5") == 0) {
          cars.add(carModel);
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }
}
