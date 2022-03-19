import 'dart:ui' as ui;
import 'package:car_app/model/car_model.dart';
import 'package:car_app/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Flag {
  visible,
  invisible,
}

class CompareCarScreen extends StatefulWidget {
  const CompareCarScreen({Key? key}) : super(key: key);

  @override
  _CompareCarScreenState createState() => _CompareCarScreenState();
}

class _CompareCarScreenState extends State<CompareCarScreen>{

  final ScrollController scrollController = ScrollController();
  late double _width;
  late double _height;
  bool isVisible = true;
  bool isLoading = true;
  String? carname1;
  String? carname2;
  int clicked = 0;
  CarModel carModel = CarModel();
  CarModel carModel1 = CarModel();
  CarModel carModel2 = CarModel();
  
  _navigateNextPageAndRetriveValue(BuildContext context) async {
    List nextPageValues;
    if(carname1 != null && carname2 == null) {
      nextPageValues = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchScreen(carname1!))
      );
    }
    else if(carname2 != null && carname1 == null) {
      nextPageValues = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchScreen(carname2!)),
      );
    }
    else if(clicked == 1 && carname2 != null) {
      nextPageValues = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchScreen(carname2!)),
      );
    }
    else if(clicked == 2 && carname1 != null) {
      nextPageValues = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchScreen(carname1!)),
      );
    }
    else {
      nextPageValues = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SearchScreen("")),
      );
    }
    setState(() {
      if(clicked == 1 && nextPageValues[0] != null) {
        carname1 = nextPageValues[0];
      }
      else if(clicked == 2 && nextPageValues[0] != null) {
        carname2 = nextPageValues[0];
      }
    });
  }

  getCarDetails(name) async {
    setState(() {
      isLoading = true;
    });
    print(name);
    print(FirebaseFirestore.instance.collection("cars").doc(name));
    await FirebaseFirestore.instance.collection("cars").doc(name).get().then((val) async {
      carModel = CarModel.fromJson(val.data() as Map<String, dynamic>);
      print(carModel.name);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black45,
                  ),
                  onPressed: () {
                    if(isVisible) {
                      Navigator.of(context).pop();
                    }
                    else {
                      setState(() {
                        isVisible = true;
                      });
                    }
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
                          "Compare Cars",
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
                    padding: (isVisible) ? const EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10) :
                      EdgeInsets.zero,
                    child: (isVisible) ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  clicked = 1;
                                  _navigateNextPageAndRetriveValue(context);
                                  FocusScope.of(context).unfocus();
                                },
                                child: selectCarDesign(_height, _width, carname1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "VS",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  clicked = 2;
                                  _navigateNextPageAndRetriveValue(context);
                                  FocusScope.of(context).unfocus();
                                },
                                child: selectCarDesign(_height, _width, carname2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.redAccent,
                                child: MaterialButton(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  onPressed: () async {
                                    if(carname1 != null && carname2 != null) {
                                      await getCarDetails(carname1);
                                      carModel1 = carModel;
                                      await getCarDetails(carname2);
                                      carModel2 = carModel;
                                      setState(() {
                                        isVisible = false;
                                      });
                                    }
                                    else {
                                      Fluttertoast.showToast(msg: "Select cars to compare");
                                    }
                                  },
                                  child: const Text("Compare Cars", textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ) :
                    isLoading ? const Center(child: CircularProgressIndicator()) :
                    DisplayCar(height: _height, width: _width, carModel1: carModel1,
                        carModel2: carModel2, isLoading: isLoading),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectCarDesign(_height, _width, car_name) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.redAccent,
          width: 3
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 15),
          Image.asset('assets/body_type.png', width: 40.0, height: 40.0),
          const SizedBox(width: 20),
          (car_name == null) ?
          const Text(
            "Select Car",
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ) :
          Expanded(
            child: Text(
              car_name,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.black,
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}

class DisplayCar extends StatefulWidget {
  final double height;
  final double width;
  final CarModel carModel1;
  final CarModel carModel2;
  final bool isLoading;

  const DisplayCar({Key? key, required this.height, required this.width,
    required this.carModel1, required this.carModel2, required this.isLoading}) : super(key: key);

  @override
  _DisplayCarState createState() => _DisplayCarState();
}

class _DisplayCarState extends State<DisplayCar> {

  Flag safety = Flag.visible;
  Flag capacity = Flag.invisible;
  Flag other = Flag.invisible;
  Flag engineTerminologies = Flag.invisible;
  Flag attributes = Flag.invisible;
  Flag brakesTyres = Flag.invisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 150,
                      child: Image.network(
                        widget.carModel1.image!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if(loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder:(BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Center(child: CircularProgressIndicator());
                        },
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.carModel1.brand! + " " + widget.carModel1.name!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.carModel1.variant!,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\u{20B9} ' + widget.carModel1.price!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              const VerticalDivider(width : 20, thickness: 1, color: Colors.black26),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 150,
                      child: Image.network(
                        widget.carModel2.image!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if(loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder:(BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Center(child: CircularProgressIndicator());
                        },
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.carModel2.brand! + " " + widget.carModel2.name!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.carModel2.variant!,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\u{20B9} ' + widget.carModel2.price!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        const Divider(color: Colors.black26, height: 0, thickness: 2),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Features",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
              const Divider(
                height: 20,
                color: Colors.black54,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    (safety == Flag.invisible) ?
                    safety = Flag.visible : safety = Flag.invisible;
                  });
                },
                child: displayText(widget.width, "Safety", "", "", "big", safety, ""),
              ),
            ],
          ),
        ),
        (safety == Flag.visible) ?
        Visibility(
          child: Column(
            children: <Widget>[
              displayText(widget.width, "Airbags", "", "", "small", safety, ""),
              displayText(widget.width, "", widget.carModel1.airbags, widget.carModel2.airbags, "", safety, "num"),
              displayText(widget.width, "NCAP Rating", "", "", "small", safety, ""),
              displayText(widget.width, "", widget.carModel1.ncapRating, widget.carModel2.ncapRating, "", safety, "num"),
              const Divider(height : 0, thickness: 1, color: Colors.black26),
              const SizedBox(height: 5),
            ],
          ),
        ) : Container(),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    (capacity == Flag.invisible) ?
                    capacity = Flag.visible : capacity = Flag.invisible;
                  });
                },
                child: displayText(widget.width, "Capacity", "", "", "big", capacity, ""),
              ),
            ],
          ),
        ),
        (capacity == Flag.visible) ?
        Visibility(
          child: Column(
            children: <Widget>[
              displayText(widget.width, "Seats", "", "", "small", capacity, ""),
              displayText(widget.width, "", widget.carModel1.seats, widget.carModel2.seats, "", capacity, "num"),
              displayText(widget.width, "Fuel Tank", "", "", "small", capacity, ""),
              displayText(widget.width, "", widget.carModel1.fuelTank, widget.carModel2.fuelTank, "", capacity, "value"),
              const Divider(height : 0, thickness: 1, color: Colors.black26),
              const SizedBox(height: 5),
            ],
          ),
        ) : Container(),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    (other == Flag.invisible) ?
                    other = Flag.visible : other = Flag.invisible;
                  });
                },
                child: displayText(widget.width, "Other", "", "", "big", other, ""),
              ),
            ],
          ),
        ),
        (other == Flag.visible) ?
        Visibility(
          child: Column(
            children: <Widget>[
              displayText(widget.width, "Audio System", "", "", "small", other, ""),
              displayText(widget.width, "", widget.carModel1.audioSystem, widget.carModel2.audioSystem, "", other, ""),
              displayText(widget.width, "Power Windows", "", "", "small", other, ""),
              displayText(widget.width, "", widget.carModel1.powerWindows, widget.carModel2.powerWindows, "", other, ""),
              displayText(widget.width, "Body Type", "", "", "small", other, ""),
              displayText(widget.width, "", widget.carModel1.bodyType, widget.carModel2.bodyType, "", other, ""),
              displayText(widget.width, "Fuel Type", "", "", "small", other, ""),
              displayText(widget.width, "", widget.carModel1.fuelType, widget.carModel2.fuelType, "", other, ""),
              const Divider(height : 0, thickness: 1, color: Colors.black26),
              const SizedBox(height: 5),
            ],
          ),
        ) : Container(),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Specification",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
              const Divider(
                height: 20,
                color: Colors.black54,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    (engineTerminologies == Flag.invisible) ?
                    engineTerminologies = Flag.visible : engineTerminologies = Flag.invisible;
                  });
                },
                child: displayText(widget.width, "Engine Terminologies", "", "", "big", engineTerminologies, ""),
              ),
            ],
          ),
        ),
        (engineTerminologies == Flag.visible) ?
        Visibility(
          child: Column(
            children: <Widget>[
              displayText(widget.width, "Engine", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.engine, widget.carModel2.engine, "", engineTerminologies, "value"),
              displayText(widget.width, "Emission Standard", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.emissionNorm, widget.carModel2.emissionNorm, "", engineTerminologies, ""),
              displayText(widget.width, "Mileage", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.mileage, widget.carModel2.mileage, "", engineTerminologies, "value"),
              displayText(widget.width, "Max Torque", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.torque, widget.carModel2.torque, "", engineTerminologies, "value"),
              displayText(widget.width, "Max Power", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.power, widget.carModel2.power, "", engineTerminologies, "value"),
              displayText(widget.width, "Transmission", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.transmission, widget.carModel2.transmission, "", engineTerminologies, ""),
              displayText(widget.width, "Gears", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.gears, widget.carModel2.gears, "", engineTerminologies, "num"),
              displayText(widget.width, "Drivetrain", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.drivetrain, widget.carModel2.drivetrain, "", engineTerminologies, ""),
              displayText(widget.width, "Cylinders", "", "", "small", engineTerminologies, ""),
              displayText(widget.width, "", widget.carModel1.cylinders, widget.carModel2.cylinders, "", engineTerminologies, "num"),
              const Divider(height : 0, thickness: 1, color: Colors.black26),
              const SizedBox(height: 5),
            ],
          ),
        ) : Container(),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    (attributes == Flag.invisible) ?
                    attributes = Flag.visible : attributes = Flag.invisible;
                  });
                },
                child: displayText(widget.width, "Attributes", "", "", "big", attributes, ""),
              ),
            ],
          ),
        ),
        (attributes == Flag.visible) ?
        Visibility(
          child: Column(
            children: <Widget>[
              displayText(widget.width, "Length", "", "", "small", attributes, ""),
              displayText(widget.width, "", widget.carModel1.length, widget.carModel2.length, "", attributes, "value"),
              displayText(widget.width, "Width", "", "", "small", attributes, ""),
              displayText(widget.width, "", widget.carModel1.width, widget.carModel2.width, "", attributes, "value"),
              displayText(widget.width, "Weight", "", "", "small", attributes, ""),
              displayText(widget.width, "", widget.carModel1.weight, widget.carModel2.weight, "", attributes, "value"),
              displayText(widget.width, "Height", "", "", "small", attributes, ""),
              displayText(widget.width, "", widget.carModel1.height, widget.carModel2.height, "", attributes, "value"),
              displayText(widget.width, "Ground Clearance", "", "", "small", attributes, ""),
              displayText(widget.width, "", widget.carModel1.groundClearance, widget.carModel2.groundClearance, "", attributes, "value"),
              const Divider(height : 0, thickness: 1, color: Colors.black26),
              const SizedBox(height: 5),
            ],
          ),
        ) : Container(),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    (brakesTyres == Flag.invisible) ?
                    brakesTyres = Flag.visible : brakesTyres = Flag.invisible;
                  });
                },
                child: displayText(widget.width, "Brakes & Tyres", "", "", "big", brakesTyres, ""),
              ),
            ],
          ),
        ),
        (brakesTyres == Flag.visible) ?
        Visibility(
          child: Column(
            children: <Widget>[
              displayText(widget.width, "Front Brakes", "", "", "small", brakesTyres, ""),
              displayText(widget.width, "", widget.carModel1.frontBrakes, widget.carModel2.frontBrakes, "", brakesTyres, ""),
              displayText(widget.width, "Rear Brakes", "", "", "small", brakesTyres, ""),
              displayText(widget.width, "", widget.carModel1.rearBrakes, widget.carModel2.rearBrakes, "", brakesTyres, ""),
              displayText(widget.width, "Wheels", "", "", "small", brakesTyres, ""),
              displayText(widget.width, "", widget.carModel1.wheels, widget.carModel2.wheels, "", brakesTyres, ""),
              const Divider(height : 0, thickness: 1, color: Colors.black26),
              const SizedBox(height: 5),
            ],
          ),
        ) : Container(),
      ],
    );
  }

  Widget displayText(width, title, data1, data2, textType, iconChange, compareType) {
    String tmp1 = "", tmp2 = "";
    if(compareType == "num") {
      tmp1 = data1;
      tmp2 = data2;
      if(tmp1.compareTo("Not Tested") == 0) {
        tmp1 = "0";
      }
      if(tmp2.compareTo("Not Tested") == 0) {
        tmp2 = "0";
      }
    }
    else if(compareType == "value") {
      tmp1 = data1.substring(0,data1.indexOf(" ")).trim();
      tmp2 = data2.substring(0,data2.indexOf(" ")).trim();
    }
    return Container(
      color: (textType == "small") ? Colors.black12 : Colors.white,
      padding: (textType == "small") ? const EdgeInsets.all(10) : EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          (data1 == "") ? Row(
            children: <Widget>[
              Expanded(
                child: (textType == "big") ?
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                ) :
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
              ),
              (textType == "big") ?
              Icon(
                (iconChange == Flag.invisible) ?
                Icons.keyboard_arrow_down_rounded :
                Icons.keyboard_arrow_up_rounded,
                color: Colors.redAccent,
              ) : Container(),
            ],
          ) :
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: width / 2,
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 11, bottom: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            data1,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        (compareType == "num" || compareType == "value") ?
                        (double.parse(tmp1) > double.parse(tmp2)) ?
                        Container(
                          width: 13,
                          decoration: const BoxDecoration(
                              color: Colors.lightGreenAccent,
                              shape: BoxShape.circle
                          ),
                        ) : (double.parse(tmp1) != double.parse(tmp2)) ?
                        Container(
                          width: 13,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle
                          ),
                        ) : Container() : Container(),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width : 0, thickness: 1, color: Colors.black26),
                Expanded(
                  child: Container(
                    width: width / 2,
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 11, bottom: 11),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            data2,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        (compareType == "num" || compareType == "value") ?
                        (double.parse(tmp1) < double.parse(tmp2)) ?
                        Container(
                          width: 15,
                          decoration: const BoxDecoration(
                              color: Colors.lightGreenAccent,
                              shape: BoxShape.circle
                          ),
                        ) : (double.parse(tmp1) != double.parse(tmp2)) ?
                        Container(
                          width: 15,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle
                          ),
                        ) : Container() : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          (textType == "big") ?
          const SizedBox(
            height: 10,
          ) : Container(),
          (iconChange == Flag.invisible) ?
          const Divider(
            height: 10,
            color: Colors.black54,
          ) : Container(),
        ],
      ),
    );
  }
}