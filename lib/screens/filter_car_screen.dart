import 'dart:ui' as ui;
import 'package:car_app/model/car_model.dart';
import 'package:car_app/screens/view_car_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum Flag {
  visible,
  invisible,
}

class FilterCar extends StatefulWidget {
  final String value;

  const FilterCar(this.value, {Key? key}) : super(key: key);

  @override
  _FilterCarState createState() => _FilterCarState();
}

class _FilterCarState extends State<FilterCar> {

  List<String> cars = [];
  List<String> carBrands = [];
  Map<String,String> carIdWithName = {};
  CarModel carModel = CarModel();
  final ScrollController scrollController = ScrollController();
  final TextEditingController startValueController = TextEditingController();
  final TextEditingController endValueController = TextEditingController();
  bool isVisible = true;
  bool isLoading = true;
  Flag budget = Flag.invisible;
  Flag brand = Flag.invisible;
  Flag fuelType = Flag.invisible;
  Flag bodyType = Flag.invisible;
  late double _width;
  double _startValue = 1;
  double _endValue = 100;
  Map<String,bool> checkedBrand = {};
  Map<String,bool> checkedFuel = {'Petrol' : false, 'Diesel' : false, 'CNG' : false, 'Electric' : false};
  Map<String,bool> checkedBody = {'Sedan' : false, 'Hatchback' : false, 'Coupe' : false, 'SUV' : false, 'MUV' : false};

  @override
  void initState() {
    super.initState();
    visibleDisplay();
    findAllCar();
  }

  void visibleDisplay() {
    if(widget.value == "Brand") {
      brand = Flag.visible;
    }
    else if(widget.value == "Fuel Type") {
      fuelType = Flag.visible;
    }
    else if(widget.value == "Budget") {
      budget = Flag.visible;
    }
    else if(widget.value == "Body Type") {
      bodyType = Flag.visible;
    }
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
    startValueController.text = _startValue.round().toString();//rangeValues.start.round().toString();
    startValueController.selection = TextSelection.fromPosition(TextPosition(offset: startValueController.text.length));
    endValueController.text = _endValue.round().toString();//rangeValues.end.round().toString();
    endValueController.selection = TextSelection.fromPosition(TextPosition(offset: endValueController.text.length));
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: (isVisible) ? const Color(0xff000000).withOpacity(.05) : Colors.white,
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
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black45,
                    ),
                    onPressed: () {
                      setState(() {
                        (isVisible) ? Navigator.of(context).pop() : isVisible = true;
                      });
                      cars.clear();
                      carIdWithName.clear();
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
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  (isVisible) ? "Filter Car" : "Cars",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              (isVisible) ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    checkedBrand.updateAll((key, value) => false);
                                    checkedBody.updateAll((key, value) => false);
                                    checkedFuel.updateAll((key, value) => false);
                                    _startValue = 1;
                                    _endValue = 100;
                                  });
                                },
                                child: const Text(
                                  "Reset",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ) : Container(),
                              const SizedBox(width: 15),
                            ],
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
              child: (isVisible) ? Container(
                padding: const EdgeInsets.all(7),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top:13, bottom: 13),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.transparent),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  (brand == Flag.invisible) ?
                                  brand = Flag.visible : brand = Flag.invisible;
                                });
                              },
                              child: displayText("Brand", brand),
                            ),
                            (brand == Flag.visible) ?
                            Visibility(
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  for(int i = 0; i < carBrands.length; i+=2)
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: _width/2.3,
                                          child: displayCheckbox(carBrands[i], checkedBrand.values.elementAt(i), "brand"),
                                        ),
                                        ((i + 1) < carBrands.length) ?
                                        SizedBox(
                                          width: _width/2.3,
                                          child: displayCheckbox(carBrands[i+1], checkedBrand.values.elementAt(i+1), "brand"),
                                        ) : Container(),
                                      ],
                                    ),
                                ],
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top:13, bottom: 13),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.transparent),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  (fuelType == Flag.invisible) ?
                                  fuelType = Flag.visible : fuelType = Flag.invisible;
                                });
                              },
                              child: displayText("Fuel Type", fuelType),
                            ),
                            (fuelType == Flag.visible) ?
                            Visibility(
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  for(int i = 0; i < checkedFuel.length; i+=2)
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: _width/2.3,
                                          child: displayCheckbox(checkedFuel.keys.elementAt(i), checkedFuel.values.elementAt(i), "fuel"),
                                        ),
                                        ((i + 1) < checkedFuel.length) ?
                                        SizedBox(
                                          width: _width/2.3,
                                          child: displayCheckbox(checkedFuel.keys.elementAt(i+1), checkedFuel.values.elementAt(i+1), "fuel"),
                                        ) : Container(),
                                      ],
                                    ),
                                ],
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top:13, bottom: 13),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.transparent),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  (budget == Flag.invisible) ?
                                  budget = Flag.visible : budget = Flag.invisible;
                                });
                              },
                              child: displayText("Budget", budget),
                            ),
                            (budget == Flag.visible) ?
                            Visibility(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(height: 35),
                                  RangeSlider(
                                    values: RangeValues(_startValue, _endValue),//rangeValues,
                                    min: 1,
                                    max: 100,
                                    activeColor: Colors.redAccent,
                                    inactiveColor: Colors.redAccent.shade100,
                                    divisions: 99,
                                    labels: RangeLabels(
                                      (_startValue.round() < 100) ?
                                      _startValue.round().toString() + " L" :
                                      "1+ Cr",
                                      (_endValue.round() < 100) ?
                                      _endValue.round().toString() + " L" :
                                      "1+ Cr",
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _startValue = values.start;
                                        _endValue = values.end;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 100,
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: _width / 3.3,
                                          child: TextFormField(
                                            autofocus: false,
                                            maxLength: 3,
                                            controller: startValueController,
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if(value!.isEmpty || int.parse(value) < 1 || int.parse(value) >= int.parse(endValueController.text)) {
                                                return("Invalid amount");
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              if(startValueController.text.isNotEmpty) {
                                                var s = double.parse(startValueController.text);
                                                setState(() {
                                                  if(s >= 1 && s < _endValue) {
                                                    _startValue = double.parse(value.toString()).roundToDouble();
                                                  }
                                                  if(s < 1) {
                                                    _startValue = 1;
                                                  }
                                                });
                                              }
                                            },
                                            //to save value user enters
                                            onSaved: (value) {
                                              startValueController.text = value!;
                                              startValueController.selection = TextSelection.fromPosition(TextPosition(offset: startValueController.text.length));
                                            },
                                            decoration: InputDecoration(
                                              suffixText: "Lakh",
                                              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                              counterText: "",
                                              errorMaxLines: 2,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "to",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: _width / 3.3,
                                          child: TextFormField(
                                            autofocus: false,
                                            maxLength: 3,
                                            controller: endValueController,
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if(value!.isEmpty || int.parse(value) > 100 || int.parse(value) <= int.parse(startValueController.text)) {
                                                return("Invalid amount");
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              if(endValueController.text.isNotEmpty && _startValue < double.parse(endValueController.text)) {
                                                var s = double.parse(endValueController.text);
                                                setState(() {
                                                  if(s <= 100 && _startValue < s) {
                                                    _endValue = double.parse(value.toString()).roundToDouble();
                                                  }
                                                  if(s > 100) {
                                                    _endValue = 100.0;
                                                  }
                                                });
                                              }
                                            },
                                            //to save value user enters
                                            onSaved: (value) {
                                              endValueController.text = value!;
                                              endValueController.selection = TextSelection.fromPosition(TextPosition(offset: endValueController.text.length));
                                            },
                                            decoration: InputDecoration(
                                              suffixText: "Lakh",
                                              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                              counterText: "",
                                              errorMaxLines: 2,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top:13, bottom: 13),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.transparent),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  (bodyType == Flag.invisible) ?
                                  bodyType = Flag.visible : bodyType = Flag.invisible;
                                });
                              },
                              child: displayText("Body Type", bodyType),
                            ),
                            (bodyType == Flag.visible) ?
                            Visibility(
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            (checkedBody.values.elementAt(0)) ?
                                            checkedBody['Sedan'] = false : checkedBody['Sedan'] = true;
                                          });
                                        },
                                        child: bodyTypeDisplay("Sedan", 'assets/Sedan.png', checkedBody['Sedan']),
                                      ),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            (checkedBody.values.elementAt(1)) ?
                                            checkedBody['Hatchback'] = false : checkedBody['Hatchback'] = true;
                                          });
                                        },
                                        child: bodyTypeDisplay("Hatchback", 'assets/Hatchback.png', checkedBody['Hatchback']),
                                      ),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            (checkedBody.values.elementAt(2)) ?
                                            checkedBody['Coupe'] = false : checkedBody['Coupe'] = true;
                                          });
                                        },
                                        child: bodyTypeDisplay("Coupe", 'assets/Coupe.png', checkedBody['Coupe']),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            (checkedBody.values.elementAt(3)) ?
                                            checkedBody['SUV'] = false : checkedBody['SUV'] = true;
                                          });
                                        },
                                        child: bodyTypeDisplay("SUV", 'assets/SUV.png', checkedBody['SUV']),
                                      ),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            (checkedBody.values.elementAt(4)) ?
                                            checkedBody['MUV'] = false : checkedBody['MUV'] = true;
                                          });
                                        },
                                        child: bodyTypeDisplay("MUV", 'assets/MUV.png', checkedBody['MUV']),
                                      ),
                                      const SizedBox(width: 20),
                                    ],
                                  ),
                                ],
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.redAccent,
                        child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          minWidth: _width / 1.3,
                          onPressed: () async {
                            await initiateSearch();
                            setState(() {
                              isVisible = false;
                              scrollController.jumpTo(0);
                            });
                          },
                          child: const Text("Apply", textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ) :
              (isLoading) ? const Center(child: CircularProgressIndicator()) :
              (cars.isEmpty) ? const Center(
                child: Text(
                  "No Cars Available",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 19,
                  ),
                ),
              ) :
              ListView(
                children: <Widget>[
                  const SizedBox(height: 5),
                  for(int i = 0; i < cars.length; i++)
                  GestureDetector(
                    onTap: () async {
                      var s = await getCarId(cars[i].toString());
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ViewCar(s)));
                      FocusScope.of(context).unfocus();
                    },
                    child: ListTile(title: makeResult(cars[i].toString())),
                  ),
                ],
              ),
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
    await FirebaseFirestore.instance.collection("cars").get().then((val) {
      for(int i = 0; i < val.docs.length; i++) {
        carModel =  CarModel.fromJson(val.docs[i].data());
        if(!carBrands.any((element) => element.compareTo(carModel.brand!) == 0)) {
          carBrands.add(carModel.brand!);
          checkedBrand[carModel.brand!] = false;
        }
      }
    });
    setState(() {});
  }

  initiateSearch() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection("cars").get().then((val) {
      List<String> tmpf = [];
      List<String> tmpbt = [];
      for(int i = 0; i < val.docs.length; i++) {
        carModel =  CarModel.fromJson(val.docs[i].data());
        var tmp = carModel.price?.substring(0, carModel.price?.indexOf(" ")).trim();
        if(_startValue <= double.parse(tmp!) && (_endValue >= double.parse(tmp) || _endValue == 100)) {
          var b = checkedBrand.keys.where((k) => checkedBrand[k] == true);
          var f = checkedFuel.keys.where((k) => checkedFuel[k] == true);
          var bt= checkedBody.keys.where((k) => checkedBody[k] == true);
          var s = carModel.brand! + " " + carModel.name! + " " + carModel.variant!;
          if(b.isEmpty && f.isEmpty && bt.isEmpty) {
            carIdWithName[carModel.carId!] = s.toString();
            cars.add(s.toString());
          }
          else {
            for (var value in b) {
              if (carModel.brand?.compareTo(value) == 0) {
                carIdWithName[carModel.carId!] = s.toString();
                cars.add(s.toString());
              }
            }
            for (var value in f) {
              if (carModel.fuelType?.compareTo(value) == 0) {
                carIdWithName[carModel.carId!] = s.toString();
                tmpf.add(s.toString());
              }
            }
            for (var value in bt) {
              if (carModel.bodyType?.compareTo(value) == 0) {
                carIdWithName[carModel.carId!] = s.toString();
                tmpbt.add(s.toString());
              }
            }
          }
        }
      }
      if(cars.isEmpty) {
        for(var a in tmpf) {
          cars.add(a);
        }
        for(var a in tmpbt) {
          cars.add(a);
        }
      }
      else {
        if(tmpf.isNotEmpty) {
          List<String> tmp = [];
          for(var a in cars) {
            tmp.add(a);
          }
          cars.clear();
          for(var a in tmpf) {
            if(tmp.contains(a)) {
              cars.add(a);
            }
          }
        }
        if(tmpbt.isNotEmpty) {
          List<String> tmp = [];
          for(var a in cars) {
            tmp.add(a);
          }
          cars.clear();
          for(var a in tmpbt) {
            if(tmp.contains(a)) {
              cars.add(a);
            }
          }
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Widget bodyTypeDisplay(title, imageURL, checkedValue) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: _width / 3.8,
          height: 70,
          child: Image.asset(imageURL),
        ),
        Text(
          title,
          style: TextStyle(
            color: (checkedValue) ? Colors.redAccent : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget displayCheckbox(title, checkedValue, data) {
    return CheckboxListTile(
      title: Transform.translate(
        offset: const Offset(-15, 0),
        child: Text(
          title,
          style: TextStyle(
            color: (checkedValue) ? Colors.redAccent : Colors.black,
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: checkedValue,
      onChanged: (value) {
        setState(() {
          if(data == "brand") {
            checkedBrand[title] = value!;
          }
          else if(data == "fuel") {
            checkedFuel[title] = value!;
          }
        });
      },
    );
  }

  Widget displayText(title, iconChange) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Icon(
          (iconChange == Flag.invisible) ?
          Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
          color: Colors.redAccent,
        ),
      ],
    );
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
}
