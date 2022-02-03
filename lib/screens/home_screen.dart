import 'package:car_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    //search field
    final searchField = TextFormField(
      enabled: false,
      decoration: InputDecoration(
        hintText: "Search Car",
        fillColor: Colors.black12,
        filled: true,
        suffixIcon: const Icon(Icons.search_rounded),
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        )
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Cloud Car",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.black87,
          // Status bar brightness
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 60),
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
                          Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          const SizedBox(height: 5),
                          Text("${loggedInUser.email}",
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
            ),
            InkWell(
              onTap: (){},
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
              onTap: (){},
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
              onTap: (){},
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
              onTap: (){},
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
              onTap: (){},
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
              onTap: (){},
              child: const ListTile(
                title: Text('Settings',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )
                ),
                leading: Icon(Icons.settings),
              )
            ),
            InkWell(
              onTap: (){},
              child: const ListTile(
                title: Text('About',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )
                ),
                leading: Icon(Icons.help),
              )
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 5),
              searchField,
              const SizedBox(height: 20),
              ActionChip(
                  label: const Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  //logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (contex) => const LoginScreen()));
  }
}