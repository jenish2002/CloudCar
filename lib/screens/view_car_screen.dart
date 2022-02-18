import 'package:car_app/model/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Flag {
  visible,
  invisible,
}

class ViewCar extends StatefulWidget {
  final String value;

  const ViewCar(this.value, {Key? key}) : super(key: key);

  @override
  _ViewCarState createState() => _ViewCarState();
}

class _ViewCarState extends State<ViewCar> {

  late AnimationController controller;
  String image="";
  String carName="";
  String price="";

  ScrollController scrollController = ScrollController();
  var isLoading = true;
  late double _height;
  Flag safety = Flag.invisible;
  Flag capacity = Flag.invisible;
  Flag other = Flag.invisible;
  Flag engineTerminologies = Flag.invisible;
  Flag attributes = Flag.invisible;
  Flag brakesTyres = Flag.invisible;

  CarModel carModel = new CarModel() ;

  void initialState() {
    setState(() {
      isLoading = true;
    });


    FirebaseFirestore.instance.collection("cars").where("carId", isEqualTo: widget.value).get().then((val) {
      // image = docs.docs[0].get("image").toString();
      // carName = docs.docs[0].get("brand").toString() + " " +
      //           docs.docs[0].get("name").toString();
      // price = docs.docs[0].get("price").toString();
      //
      // carModel = CarModel.fromJson(docs.docs[0].data()!)

      carModel = CarModel.fromJson(val.docs[0].data());


      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initialState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;


    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                excludeHeaderSemantics: true,
                expandedHeight: _height / 2.7,
                backgroundColor: Colors.white,
                floating: false,
                pinned: false,
                snap: false,
                forceElevated: innerBoxIsScrolled,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    //go back button
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      background: SizedBox(
                        height: 200,
                        child: //!isLoading ? const CircularProgressIndicator() :
                        Image.network(
                          carModel.image!,
                          errorBuilder:(BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const CircularProgressIndicator();
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ];
          },
          body: isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        carModel.brand! + " " + carModel.name! + " " + carModel.variant!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        //price with inr symbol
                        '\u{20B9} $price',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const ReturnText(title: "Overview", textType: "big",
                        iconChange: Flag.invisible),
                      const ReturnText(title: "Body Type", textType: "",
                        iconChange: Flag.invisible),
                      const ReturnText(title: "Fuel Type", textType: "",
                        iconChange: Flag.invisible),
                      const ReturnText(title: "Mileage", textType: "",
                          iconChange: Flag.invisible),
                      const ReturnText(title: "Seats", textType: "",
                          iconChange: Flag.invisible),
                      const ReturnText(title: "Airbags", textType: "",
                          iconChange: Flag.invisible),
                      const ReturnText(title: "Audio System", textType: "",
                          iconChange: Flag.invisible),
                      const ReturnText(title: "Drivetrain", textType: "",
                          iconChange: Flag.invisible),
                      const SizedBox(height: 20),
                      const ReturnText(title: "Features", textType: "big",
                          iconChange: Flag.invisible),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            (safety == Flag.invisible) ?
                            safety = Flag.visible : safety = Flag.invisible;
                          });
                        },
                        child: ReturnText(title: "Safety", textType: "small",
                          iconChange: safety),
                      ),
                      (safety == Flag.visible) ?
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            ReturnText(title: "Airbags", textType: "",
                                iconChange: safety),
                            ReturnText(title: "NCAP Rating", textType: "",
                                iconChange: safety),
                          ],
                        ),
                      ) :
                      Container(),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            (capacity == Flag.invisible) ?
                            capacity = Flag.visible : capacity = Flag.invisible;
                          });
                        },
                        child: ReturnText(title: "Capacity", textType: "small",
                            iconChange: capacity),
                      ),
                      (capacity == Flag.visible) ?
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            ReturnText(title: "Seats", textType: "",
                                iconChange: capacity),
                            ReturnText(title: "Fuel Tank", textType: "",
                                iconChange: capacity),
                          ],
                        ),
                      ) :
                      Container(),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            (other == Flag.invisible) ?
                            other = Flag.visible : other = Flag.invisible;
                          });
                        },
                        child: ReturnText(title: "Other", textType: "small",
                            iconChange: other),
                      ),
                      (other == Flag.visible) ?
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            ReturnText(title: "Audio System", textType: "",
                                iconChange: other),
                            ReturnText(title: "Power Windows", textType: "",
                                iconChange: other),
                            ReturnText(title: "Body Type", textType: "",
                                iconChange: other),
                            ReturnText(title: "Fuel Type", textType: "",
                                iconChange: other),
                          ],
                        ),
                      ) :
                      Container(),
                      const SizedBox(height: 20),
                      const ReturnText(title: "Specification", textType: "big",
                          iconChange: Flag.invisible),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            (engineTerminologies == Flag.invisible) ?
                            engineTerminologies = Flag.visible :
                            engineTerminologies = Flag.invisible;
                          });
                        },
                        child: ReturnText(title: "Engine Terminologies",
                            textType: "small",iconChange: engineTerminologies),
                      ),
                      (engineTerminologies == Flag.visible) ?
                      Visibility(
                        child: Column(
                          children: <Widget>[
                             ReturnText(title: "Engine", textType: "",

                                 iconChange: engineTerminologies),
                            ReturnText(title: "Emission Standard", textType: "",
                                 iconChange: engineTerminologies),
                            ReturnText(title: "Mileage", textType: "",
                                 iconChange: engineTerminologies),
                             ReturnText(title: "Max Torque", textType: "",
                                 iconChange: engineTerminologies),
                            ReturnText(title: "Max Power", textType: "",
                                 iconChange: engineTerminologies),
                             ReturnText(title: "Transmission", textType: "",
                                 iconChange: engineTerminologies),
                             ReturnText(title: "Gears", textType: "",
                                 iconChange: engineTerminologies),
                             ReturnText(title: "Drivetrain", textType: "",
                                iconChange: engineTerminologies),
                             ReturnText(title: "Cylinders", textType: "",
                                 iconChange: engineTerminologies),

                          ],
                        ),
                      ) :
                      Container(),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            (attributes == Flag.invisible) ?
                            attributes = Flag.visible :
                            attributes = Flag.invisible;
                          });
                        },
                        child: ReturnText(title: "Attributes", textType: "small",
                            iconChange: attributes),
                      ),
                      (attributes == Flag.visible) ?
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            ReturnText(title: "Length", textType: "",
                                iconChange: attributes),
                            ReturnText(title: "Width", textType: "",
                                iconChange: attributes),
                            ReturnText(title: "Weight", textType: "",
                                iconChange: attributes),
                            ReturnText(title: "Height", textType: "",
                                iconChange: attributes),
                            ReturnText(title: "Ground Clearance", textType: "",
                                iconChange: attributes),
                          ],
                        ),
                      ) :
                      Container(),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            (brakesTyres == Flag.invisible) ?
                            brakesTyres = Flag.visible :
                            brakesTyres = Flag.invisible;
                          });
                        },
                        child: ReturnText(title: "Brakes & Tyres", textType: "small",
                            iconChange: brakesTyres),
                      ),
                      (brakesTyres == Flag.visible) ?
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            ReturnText(title: "Front Brakes", textType: "",
                                iconChange: brakesTyres),
                            ReturnText(title: "Rear Brakes", textType: "",
                                iconChange: brakesTyres),
                            ReturnText(title: "Wheels", textType: "",
                                iconChange: brakesTyres),
                          ],
                        ),
                      ) :
                      Container(),
                      const SizedBox(height: 20),
                      const ReturnText(title: "Colors", textType: "big",
                          iconChange: Flag.invisible),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class ReturnText extends StatelessWidget {

  final String title;
  final String textType;
  final Flag iconChange;

  const ReturnText({
    Key? key,
    required this.title,
    required this.textType,
    required this.iconChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: (textType == "big" || textType == "small") ?
                TextStyle(
                  color: (textType == "big") ? Colors.black : Colors.black54,
                  fontWeight: (textType == "big") ? FontWeight.w500 :
                      FontWeight.w800,
                  fontSize: (textType == "big") ? 22 : 19,
                ) :
                const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                )
              ),
            ),
            if(textType == "small")
              Icon(
                (iconChange == Flag.invisible) ?
                Icons.keyboard_arrow_down_rounded :
                Icons.keyboard_arrow_up_rounded,
                color: Colors.redAccent,
              ),
          ],
        ),
        (textType == "big" || textType == "small") ?
        Divider(
          height: (textType == "big") ? 35 : 30,
          color: Colors.black54,
        ) :
        const Divider(
          height: 25,
          color: Colors.black54,
        )
      ],
    );
  }
}

