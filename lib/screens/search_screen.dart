import 'package:car_app/model/car_model.dart';
import 'package:car_app/screens/view_car_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<String> cars = [];
  List<String> searchCar = [];
  Map<String,String> carIdWithName = {};
  var isVisible = false;
  var isDone = false;
  CarModel carModel = CarModel();
  CarModel carSearch = CarModel();

  @override
  void initState() {
    super.initState();
    findAllCar();
  }

  getCarId(String str) {
    if(carIdWithName.containsValue(str)) {
      for(int i = 0; i < carIdWithName.length; i++) {
        if(carIdWithName.values.elementAt(i).compareTo(str) == 0) {
          return carIdWithName.keys.elementAt(i);
        }
      }
    }
    /*await FirebaseFirestore.instance.collection("cars").doc(str)
        .get().then((val) {
      carSearch = CarModel.fromJson(val.data()!);
      setState(() {

      });
    });*/
  }

  findAllCar() async {
    await FirebaseFirestore.instance.collection("cars").get().then((val) async {
      for(int i = 0; i < val.docs.length; i++) {
        carModel =  await CarModel.fromJson(val.docs[i].data());
        var s = carModel.brand! + " " + carModel.name! + " " + carModel.variant!;
        carIdWithName[carModel.carId!] = s;
        cars.add(s.toString());
      }
    });
  }

  initiateSearch(value) {
    setState(() {
      isVisible = false;
    });
    searchCar = [];
    if(value.length > 0) {
      var tmp = cars.where((item) => item.toLowerCase().contains(value.toString().toLowerCase()));
      Iterator itr = tmp.iterator;
      while(itr.moveNext()) {
        searchCar.add(itr.current);
      }
    }
    setState(() {
      isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //search field
    final searchField = TextFormField(
      //when text changed
      onChanged: (value) {
          initiateSearch(value);
      },
      decoration: InputDecoration(
        prefixIcon: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black38,
          iconSize: 19.0,
          onPressed: () {
            //go back button
            Navigator.of(context).pop();
          },
        ),
        hintText: "Search by car name, e.g.Swift",
        border: InputBorder.none,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 7, 15, 2),
            child: searchField,
          ),
          const Divider(height: 10, thickness: 2, color: Colors.black26,),
          const SizedBox(height: 10),
          for(int i = 0; i < searchCar.length; i++)
          GestureDetector(
            onTap: () async {
              var s = await getCarId(searchCar[i].toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewCar(s),
                )
              );
              FocusScope.of(context).unfocus();
            },
            child: ListTile(
              title: makeResult(searchCar[i].toString())
            ),
          ),
        ],
      ),
    );
  }
}

/*Widget makeResult(context, title) {
  return GestureDetector(
    onTap: () async {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewCar(title),
          )
      );
      FocusScope.of(context).unfocus();
    },
    child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 19,
              ),
            ),
            const Divider(
              height: 27,
              thickness: 2,
            )
          ],
        ),
    ),
  );
}*/

Widget makeResult(title) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 19,
          ),
        ),
        const Divider(
          height: 27,
          thickness: 2,
        )
      ],
  );
}