import 'dart:ui' as ui;
import 'package:car_app/model/car_model.dart';
import 'package:car_app/screens/view_car_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Flag {
  visible,
  invisible,
}

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key? key}) : super(key: key);

  @override
  _AdvancedSearchState createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {

  List<String> cars = [];
  Map<String,String> carIdWithName = {};
  CarModel carModel = CarModel();
  final ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController startValueController = TextEditingController();
  final TextEditingController endValueController = TextEditingController();
  bool isVisible = true;
  bool isLoading = true;
  Flag budget = Flag.visible;
  Flag brand = Flag.invisible;
  Flag fuelType = Flag.invisible;
  Flag bodyType = Flag.invisible;
  late double _width;
  double _startValue = 1;
  double _endValue = 100;
  Map<String,bool> checkedBrand = {'Audi' : false, 'BMW' : false, 'Datsun' : false, 'Honda' : false,
                                   'Hyundai' : false, 'Jeep' : false, 'Kia' : false, 'Mahindra' : false,
                                   'Maruti Suzuki' : false, 'MG' : false, 'Nissan' : false, 'Renault' : false,
                                   'Skoda' : false, 'Tata' : false, 'Toyota' : false, 'Volkswagen' : false};
  Map<String,bool> checkedFuel = {'Petrol' : false, 'Diesel' : false, 'CNG' : false};
  Map<String,bool> checkedBody = {'Sedan' : false, 'Hatchback' : false, 'Coupe' : false, 'SUV' : false, 'MUV' : false};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RenderErrorBox.backgroundColor = Colors.white;
    RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
    startValueController.text = _startValue.round().toString();
    startValueController.selection = TextSelection.fromPosition(TextPosition(offset: startValueController.text.length));
    endValueController.text = _endValue.round().toString();
    endValueController.selection = TextSelection.fromPosition(TextPosition(offset: endValueController.text.length));
    _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          (isVisible) ? Navigator.of(context).pop() : isVisible = true;
        });
        cars.clear();
        carIdWithName.clear();
        return false;
      },
      child: Scaffold(
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
                                    (isVisible) ? "Advanced Search" : "Cars",
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
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(0)) ?
                                              checkedBrand['Audi'] = false : checkedBrand['Audi'] = true;
                                            });
                                          },
                                          child: brandDisplay("Audi", 'assets/brands/audi.png', checkedBrand['Audi']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(1)) ?
                                              checkedBrand['BMW'] = false : checkedBrand['BMW'] = true;
                                            });
                                          },
                                          child: brandDisplay("BMW", 'assets/brands/bmw.png', checkedBrand['BMW']),
                                        ),
                                        const Expanded(child: SizedBox(),),GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(2)) ?
                                              checkedBrand['Datsun'] = false : checkedBrand['Datsun'] = true;
                                            });
                                          },
                                          child: brandDisplay("Datsun", 'assets/brands/datsun.png', checkedBrand['Datsun']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(3)) ?
                                              checkedBrand['Honda'] = false : checkedBrand['Honda'] = true;
                                            });
                                          },
                                          child: brandDisplay("Honda", 'assets/brands/honda.png', checkedBrand['Honda']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(4)) ?
                                              checkedBrand['Hyundai'] = false : checkedBrand['Hyundai'] = true;
                                            });
                                          },
                                          child: brandDisplay("Hyundai", 'assets/brands/hyundai.png', checkedBrand['Hyundai']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(5)) ?
                                              checkedBrand['Jeep'] = false : checkedBrand['Jeep'] = true;
                                            });
                                          },
                                          child: brandDisplay("Jeep", 'assets/brands/jeep.png', checkedBrand['Jeep']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(6)) ?
                                              checkedBrand['Kia'] = false : checkedBrand['Kia'] = true;
                                            });
                                          },
                                          child: brandDisplay("Kia", 'assets/brands/kia.png', checkedBrand['Kia']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(7)) ?
                                              checkedBrand['Mahindra'] = false : checkedBrand['Mahindra'] = true;
                                            });
                                          },
                                          child: brandDisplay("Mahindra", 'assets/brands/mahindra.png', checkedBrand['Mahindra']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(8)) ?
                                              checkedBrand['Maruti Suzuki'] = false : checkedBrand['Maruti Suzuki'] = true;
                                            });
                                          },
                                          child: brandDisplay("Maruti Suzuki", 'assets/brands/MarutiSuzuki.png', checkedBrand['Maruti Suzuki']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(9)) ?
                                              checkedBrand['MG'] = false : checkedBrand['MG'] = true;
                                            });
                                          },
                                          child: brandDisplay("MG", 'assets/brands/mg.png', checkedBrand['MG']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(10)) ?
                                              checkedBrand['Nissan'] = false : checkedBrand['Nissan'] = true;
                                            });
                                          },
                                          child: brandDisplay("Nissan", 'assets/brands/nissan.png', checkedBrand['Nissan']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(11)) ?
                                              checkedBrand['Renault'] = false : checkedBrand['Renault'] = true;
                                            });
                                          },
                                          child: brandDisplay("Renault", 'assets/brands/renault.png', checkedBrand['Renault']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(12)) ?
                                              checkedBrand['Skoda'] = false : checkedBrand['Skoda'] = true;
                                            });
                                          },
                                          child: brandDisplay("Skoda", 'assets/brands/skoda.png', checkedBrand['Skoda']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(13)) ?
                                              checkedBrand['Tata'] = false : checkedBrand['Tata'] = true;
                                            });
                                          },
                                          child: brandDisplay("Tata", 'assets/brands/tata.png', checkedBrand['Tata']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(14)) ?
                                              checkedBrand['Toyota'] = false : checkedBrand['Toyota'] = true;
                                            });
                                          },
                                          child: brandDisplay("Toyota", 'assets/brands/toyota.png', checkedBrand['Toyota']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBrand.values.elementAt(15)) ?
                                              checkedBrand['Volkswagen'] = false : checkedBrand['Volkswagen'] = true;
                                            });
                                          },
                                          child: brandDisplay("Volkswagen", 'assets/brands/volkswagen.png', checkedBrand['Volkswagen']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        SizedBox(
                                          width: _width / 3.8,
                                          height: 70,
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        SizedBox(
                                          width: _width / 3.8,
                                          height: 70,
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
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
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedFuel.values.elementAt(0)) ?
                                              checkedFuel['Petrol'] = false : checkedFuel['Petrol'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("Petrol", 'assets/fuel/petrol.png', checkedFuel['Petrol']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedFuel.values.elementAt(1)) ?
                                              checkedFuel['Diesel'] = false : checkedFuel['Diesel'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("Diesel", 'assets/fuel/diesel.png', checkedFuel['Diesel']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedFuel.values.elementAt(2)) ?
                                              checkedFuel['CNG'] = false : checkedFuel['CNG'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("CNG", 'assets/fuel/cng.png', checkedFuel['CNG']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
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
                                    Form(
                                      key: _formKey,
                                      child: SizedBox(
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
                                                  if(value!.isEmpty || endValueController.text.isEmpty || int.parse(value) < 1 || int.parse(value) >= int.parse(endValueController.text)) {
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
                                                  if(value!.isEmpty || startValueController.text.isEmpty || int.parse(value) > 100 || int.parse(value) <= int.parse(startValueController.text)) {
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
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBody.values.elementAt(0)) ?
                                              checkedBody['Sedan'] = false : checkedBody['Sedan'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("Sedan", 'assets/Sedan.png', checkedBody['Sedan']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBody.values.elementAt(1)) ?
                                              checkedBody['Hatchback'] = false : checkedBody['Hatchback'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("Hatchback", 'assets/Hatchback.png', checkedBody['Hatchback']),
                                        ),
                                        //const SizedBox(width: 10),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBody.values.elementAt(2)) ?
                                              checkedBody['Coupe'] = false : checkedBody['Coupe'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("Coupe", 'assets/Coupe.png', checkedBody['Coupe']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBody.values.elementAt(3)) ?
                                              checkedBody['SUV'] = false : checkedBody['SUV'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("SUV", 'assets/SUV.png', checkedBody['SUV']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              (checkedBody.values.elementAt(4)) ?
                                              checkedBody['MUV'] = false : checkedBody['MUV'] = true;
                                            });
                                          },
                                          child: bodyTypeDisplay("MUV", 'assets/MUV.png', checkedBody['MUV']),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        SizedBox(
                                          width: _width / 3.8,
                                          height: 70,
                                        ),
                                        const Expanded(child: SizedBox(),),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ) : Container(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.redAccent,
                                  child: MaterialButton(
                                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                    onPressed: () async {
                                      if(isVisible) {
                                        if(_formKey.currentState!.validate()) {
                                          isVisible = false;
                                          await initiateSearch();
                                          setState(() {
                                            scrollController.jumpTo(0);
                                          });
                                        }
                                        else {
                                          Fluttertoast.showToast(msg: "Check budget");
                                        }
                                      }
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
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

  initiateSearch() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection("cars").get().then((val) {
      List<String> tmpb = [];
      List<String> tmpf = [];
      List<String> tmpbt = [];
      var b = checkedBrand.keys.where((k) => checkedBrand[k] == true);
      var f = checkedFuel.keys.where((k) => checkedFuel[k] == true);
      var bt= checkedBody.keys.where((k) => checkedBody[k] == true);
      for(int i = 0; i < val.docs.length; i++) {
        carModel =  CarModel.fromJson(val.docs[i].data());
        var tmp = carModel.price?.substring(0, carModel.price?.indexOf(" ")).trim();
        if(_startValue <= double.parse(tmp!) && (_endValue >= double.parse(tmp) || _endValue == 100)) {
          var s = carModel.brand! + " " + carModel.name! + " " + carModel.variant!;
          carIdWithName[carModel.carId!] = s.toString();
          cars.add(s.toString());
          for (var value in b) {
            if (carModel.brand?.compareTo(value) == 0) {
              tmpb.add(s.toString());
            }
          }
          for (var value in f) {
            if (carModel.fuelType?.compareTo(value) == 0) {
              tmpf.add(s.toString());
            }
          }
          for (var value in bt) {
            if (carModel.bodyType?.compareTo(value) == 0) {
              tmpbt.add(s.toString());
            }
          }
        }
      }
      if(b.isNotEmpty) {
        cars.removeWhere((item) => !tmpb.contains(item));
      }
      if(f.isNotEmpty) {
        cars.removeWhere((item) => !tmpf.contains(item));
      }
      if(bt.isNotEmpty) {
        cars.removeWhere((item) => !tmpbt.contains(item));
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Widget brandDisplay(title, imageURL, checkedValue) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: _width / 4,
          height: 60,
          child: Image.asset(imageURL),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: (checkedValue) ? Colors.redAccent : Colors.black,
          ),
        ),
      ],
    );
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
