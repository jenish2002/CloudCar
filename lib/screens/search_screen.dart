import 'package:car_app/model/search_car.dart';
import 'package:car_app/screens/view_car_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


late String str;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      SearchCar().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          queryResultSet.add(docs.docs[i].data());
          setState(() {
            tempSearchStore.add(docs.docs[i].data());
          });
        }
      });
    }
    else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
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
            padding: const EdgeInsets.fromLTRB(5, 10, 15, 10),
            child: searchField,
          ),
          const SizedBox(height: 10),
          GridView.count(
            restorationId: "new",
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            primary: false,
            shrinkWrap: true,
            children: tempSearchStore.map((element) {
              return buildResultCard(element,context);
            }).toList()
          ),
        ],
      ),
    );
  }
}
Widget buildResultCard(data,context) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            str = data['name'];
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewCar(str)
              )
            );
          },
          child: Text(data['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        )
      )
  );
}