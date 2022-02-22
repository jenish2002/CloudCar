import 'package:car_app/model/car_model.dart';
import 'package:car_app/screens/view_car_screen.dart';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchScreen extends StatefulWidget {
  final String value;

  const SearchScreen(this.value, {Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<String> cars = [];
  List<String> searchCar = [];
  Map<String,String> carIdWithName = {};
  CarModel carModel = CarModel();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    findAllCar();
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      color: Colors.black38,
                    ),
                    onPressed: () {
                      //go back button
                      Navigator.pop(context, [null]);
                    }
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      background: Padding(
                        padding: const EdgeInsets.only(left: 53),
                        child: TextFormField(
                          //when text changed
                          onChanged: (value) {
                            initiateSearch(value);
                          },
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "Search by car name, e.g. Swift",
                            contentPadding: EdgeInsets.symmetric(vertical: 19.0),
                            border: InputBorder.none,
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
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 8),
                for(int i = 0; i < searchCar.length; i++)
                GestureDetector(
                  onTap: () async {
                    var s = await getCarId(searchCar[i].toString());
                    if(widget.value == "compare") {
                      Navigator.pop(context, [searchCar[i].toString()]);
                    }
                    else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => ViewCar(s)));
                    }
                    FocusScope.of(context).unfocus();
                  },
                  child: ListTile(
                    title: makeResult(searchCar[i].toString())
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCarId(String str) {
    if(carIdWithName.containsValue(str)) {
      for(int i = 0; i < carIdWithName.length; i++) {
        if(carIdWithName.values.elementAt(i).compareTo(str) == 0) {
          return carIdWithName.keys.elementAt(i);
        }
      }
    }
  }

  findAllCar() async {
    setState(() {});
    await FirebaseFirestore.instance.collection("cars").get().then((val) async {
      for(int i = 0; i < val.docs.length; i++) {
        carModel =  CarModel.fromJson(val.docs[i].data());
        var s = carModel.brand! + " " + carModel.name! + " " + carModel.variant!;
        carIdWithName[carModel.carId!] = s;
        cars.add(s.toString());
      }
    });
  }

  initiateSearch(value) {
    setState(() {});
    searchCar = [];
    if(value.length > 0) {
      var tmp = cars.where((item) => item.toLowerCase().contains(value.toString().toLowerCase()));
      Iterator itr = tmp.iterator;
      while(itr.moveNext()) {
        searchCar.add(itr.current);
      }
    }
  }
}

Widget makeResult(title) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 19,
          ),
        ),
        const SizedBox(height: 18),
        const Divider(
          height: 0,
          thickness: 2,
        )
      ],
    ),
  );
}