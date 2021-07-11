import 'dart:ui';

import 'dart:js' as js;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rwk20/enums/transaction_enums.dart';
import 'package:rwk20/models/package.dart';
import 'package:rwk20/ui/base_widget.dart';
import 'package:rwk20/ui/sizing_information.dart';
import 'package:rwk20/ui/views/package_preview_slider.dart';
import 'package:rwk20/ui/views/payment_page.dart';
import 'package:rwk20/utils/payment_api.dart';
import 'package:rwk20/utils/ui_utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool initPageVisible = true;
  bool nextPageVisibility = false;
  String selectedPackage = 'Premium Package';

  Order order = Order();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var locationController = TextEditingController();
  var emailController = TextEditingController();
  DateTime _curDate = DateTime.now();

  String color = "blue";
  String groupValue = 'color';
  List<String> sizes = ["Small", "Medium", "Large"];
  List<String> packages = [
    'Premium package',
    'Shirt and free nose mask',
    'cap',
    'Pen & Jotter'
  ];
  List<String> colors = ['black', 'blue', 'wine', 'ash'];
  String size = "Small";
  String package = "Premium package";
  double price = 3500.0;
  double charges = 10.0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle typeTitleTextStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    TextStyle typeTextStyle =
        TextStyle(fontWeight: FontWeight.w400, fontSize: 18);

    return BaseWidget(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('RW \'20 Preorder'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      orderSummary(context),
                      initialPage(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                      visible: initPageVisible,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // orderPage.isVisible =!orderPage.isVisible;
                              // initPageVisible = !initPageVisible;
                              initPageVisible = !initPageVisible;
                              nextPageVisibility = !nextPageVisibility;
                            });

                            // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSummary()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Proceed",
                              style: TextStyle(fontSize: 20),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Center orderSummary(BuildContext context) {
    return Center(
      child: Visibility(
        visible: nextPageVisibility,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          initPageVisible = !initPageVisible;
                          nextPageVisibility = !nextPageVisibility;
                        });
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Package Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('$selectedPackage'),
                                    Text('\u20A6${price.toString()}', style: TextStyle(fontWeight: FontWeight.w600),),

                                  ],
                                ),
                                Divider(),

                               YourDetails(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text('kindly confirm your details before proceeding to pay', style: TextStyle(color: Colors.grey, fontSize: 10 ),),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Charges'),
                      Text(charges.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '\u20A6${charges+price}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ])),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSummary()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Pay now",
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Padding YourDetails() {
    return Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children:[
                                   Text('Your details', style: TextStyle(fontWeight: FontWeight.w600),),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Container(
                                     margin: EdgeInsets.only(bottom: 10),
                                     child: Row(
                                 children: [
                                     Text('Name:'),
                                     Container(
                                         margin: EdgeInsets.only(left: 10),
                                         child: Text(nameController.text)),
                                 ]
                               ),
                                   ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                      children: [
                                        Text('Email:'),
                                        Container(margin: EdgeInsets.only(left: 10),
                                            child: Text(emailController.text)),
                                      ]
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                      children: [
                                        Text('Tel:'),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(phoneController.text)),
                                      ]
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                      children: [
                                        Text('Name:'),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(nameController.text)),
                                      ]
                                  ),
                                ),
                                Row(
                                    children: [
                                      Text('Location:'),
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(locationController.text)),
                                    ]
                                ),
                                ]),
                             );
  }

  Center initialPage() {
    return Center(
      child: Visibility(
        visible: initPageVisible,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  // textStyle: TextStyle(color: Colors.white),
                  color: Colors.grey.shade200,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: mobileWidthLimit,
                    margin: const EdgeInsets.all(10),
                    child: BaseWidget(
                      builder: (context, sizingInfo) {
                        SizingInformation si = sizingInfo;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              PackagePreviewSlide(),
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Kindly fill the following details',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Container(
                                              child: Column(children: [
                                                Row(children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Color:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: DropdownButton(
                                                        isExpanded: true,
                                                        items: List.generate(
                                                            colors.length,
                                                            (index) =>
                                                                DropdownMenuItem(
                                                                  child: Text(
                                                                      "${colors[index]}"),
                                                                  value: colors[
                                                                      index],
                                                                )),
                                                        value: color,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            color = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container()),
                                                ]),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Package:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: DropdownButton(
                                                          isExpanded: true,
                                                          items: List.generate(
                                                              packages.length,
                                                              (index) =>
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                        "${packages[index]}"),
                                                                    value: packages[
                                                                        index],
                                                                  )),
                                                          value: package,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              package = value;
                                                              selectedPackage =
                                                                  package;
                                                              switch (value) {
                                                                case 'Premium package':
                                                                  price =
                                                                      3500.00;
                                                                  break;
                                                                case 'Shirt and free nose mask':
                                                                  price =
                                                                      2500.00;
                                                                  break;
                                                                case 'cap':
                                                                  price =
                                                                      1000.00;
                                                                  break;
                                                                case 'Pen & Jotter':
                                                                  price =
                                                                      500.00;
                                                                  break;
                                                                default:
                                                                  price = 0.00;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "\u20A6 $price",
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Size:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: DropdownButton(
                                                          isExpanded: true,
                                                          items: List.generate(
                                                              sizes.length,
                                                              (index) =>
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                        "${sizes[index]}"),
                                                                    value: sizes[
                                                                        index],
                                                                  )),
                                                          value: size,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              size = value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Container()),
                                                  ],
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InputField(
                                      label: "Full Name",
                                      controller: nameController,
                                    ),
                                    InputField(
                                      label: "Phone Number",
                                      controller: phoneController,
                                    ),
                                    InputField(
                                      label: "Email Address",
                                      controller: emailController,
                                    ),
                                    InputField(
                                      label: "Location",
                                      controller: locationController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future submitForm(BuildContext context) async {
    if (formKey.currentState.validate()) {
      // Upload Order here
      order.package = package;
      order.customerName = nameController.text;
      order.color = color;
      order.phone = phoneController.text;
      order.email = emailController.text;
      order.location = locationController.text;
      order.size = size;
      order.price = price;
      await Future.delayed(Duration(seconds: 1));

      print("Getting firebase instance");
      final CollectionReference orders =
          FirebaseFirestore.instance.collection("orders");

      await orders.add({
        'package': order.package,
        'full_name': order.customerName,
        'color': order.color,
        'phone_number': order.phone,
        'email': order.email,
        'location': order.location,
        'size': order.size,
        'price': order.price,
        'date': order.date,
      }).then((value) async {
        print('Details Added');

        PaymentApi.initializePayment(order.price.round() * 100, order.email)
            .then((value) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => PaymentPage(paymentInitData: value)));

          js.context.callMethod('open', ['${value.authorizationUrl}']);
        });
      }).catchError((onError) {
        Fluttertoast.showToast(
            msg: "An Error Occurred... Please try again!",
            toastLength: Toast.LENGTH_LONG);
        print('$onError');
      });

      // Navigator.pop(context);
    } else
      Fluttertoast.showToast(
          msg: "Fill all fields", backgroundColor: Colors.red.withOpacity(0.5));
  }
}

class InputField extends StatelessWidget {
  final String label;
  final int lines;
  final TextInputType inputType;
  final TextEditingController controller;
  final Function validator;

  const InputField({
    Key key,
    this.label,
    this.lines = 1,
    this.inputType,
    this.validator,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator == null
            ? (val) {
                if (val.isEmpty)
                  return "This field cannot be empty!";
                else
                  return null;
              }
            : validator,
        controller: controller,
        minLines: lines,
        maxLines: lines,
        keyboardType: inputType,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: "$label",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
