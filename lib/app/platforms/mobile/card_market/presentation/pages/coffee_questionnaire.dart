// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/coffee_order_loader.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// class CoffeeQuestionnairePage extends StatefulWidget {
//   CoffeeQuestionnairePage({Key? key}) : super(key: key);
//
//   @override
//   State<CoffeeQuestionnairePage> createState() =>
//       _CoffeeQuestionnairePageState();
// }
//
// class _CoffeeQuestionnairePageState extends State<CoffeeQuestionnairePage> {
//   int currentQuestion = 0;
//
//   String newValue = "";
//   int shoeSize = 39;
//   List<Map<String, dynamic>> questions = [];
//   Color greenColor = Color(0xffEDFE79);
//   String temperature = "cold";
//   bool loadingButton = false;
//   String birthDate = "";
//   bool buttonLoad = false;
//   var appleWalletResponse;
//   String avatarUrl = "";
//   final auth = FirebaseAuth.instance;
//   var userUID = "";
//   int coffeeShots = 2;
//   List<int> coffeeShotsList = [1, 2, 3, 4];
//
//   String size = "Short (8)"; // Initialize with a default value
//   final List<String> sizeOptions = [
//     "Short (8)",
//     "Tall (12)",
//     "Grande (16)",
//     "Venti (20)"
//   ];
//
//   String selection = "Cappuchino"; // Initialize with a default value
//   final List<String> selectionOptions = [
//     "Cappuchino",
//     "Espresso",
//     "Macchiato",
//     "Americano",
//     "Latte",
//     "Mocha"
//   ];
//
//   String milk = "Almond milk"; // Initialize with a default value
//   final List<String> milkOptions = [
//     "Almond milk",
//     "Half & Half",
//     "Heavy cream",
//     "Notfat milk",
//     "Oat milk",
//     "Soy"
//         "Whole milk"
//   ];
//
//   String topping = "Almond milk foam";
//   final List<String> toppingOptions = [
//     "Almond milk foam",
//     "Caramel drizzle",
//     "Chocolate shavings",
//     "Cinnamon",
//     "Cocoa powder",
//     "Coconut flakes",
//     "Hazelnut syrup",
//     "Whipped cream"
//   ];
//
//   String flavor = "Almond";
//   final List<String> flavorOptions = [
//     "Almond",
//     "Butterscotch",
//     "Caramel",
//     "Chocolate",
//     "Cinnamon",
//     "Hazelnut",
//     "Mocha",
//     "Toffee",
//     "Vanilla"
//   ];
//
//   FixedExtentScrollController sizeController =
//       FixedExtentScrollController(initialItem: 0);
//   FixedExtentScrollController milkController =
//       FixedExtentScrollController(initialItem: 0);
//   FixedExtentScrollController selectionController =
//       FixedExtentScrollController(initialItem: 0);
//   FixedExtentScrollController toppingController =
//       FixedExtentScrollController(initialItem: 0);
//   FixedExtentScrollController flavorController =
//       FixedExtentScrollController(initialItem: 0);
//
//   @override
//   void initState() {
//     questions = [
//       {
//         "question": "How do you prefer your coffee temperature?",
//         "field": SizedBox()
//       },
//       {"question": "Your coffee selection:", "field": SizedBox()},
//       {"question": "What size coffee would you like?", "field": SizedBox()},
//       {
//         "question": "How would you like your coffee with milk?",
//         "field": SizedBox()
//       },
//       {
//         "question": "Do you prefer any espresso shots in your coffee?",
//         "field": SizedBox()
//       },
//       {
//         "question": "What toppings would you like on your coffee?",
//         "field": SizedBox()
//       },
//       {
//         "question": "Would you like to add any flavor to your coffee?",
//         "field": SizedBox()
//       },
//     ];
//     super.initState();
//   }
//
//   void dispose() {
//     sizeController.dispose();
//     milkController.dispose();
//     toppingController.dispose();
//     flavorController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cardData =
//         ModalRoute.of(context)!.settings.arguments as CardModel;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(top: 60, left: 10),
//                   // Adjust the top padding as needed
//                   child: IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       size: 18,
//                     ),
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               width: 100.w,
//               height: 75.h,
//               child: ListView.builder(
//                   itemCount: questions.length,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: (BuildContext context, int index) {
//                     return Container(
//                       margin: EdgeInsets.only(left: 25, right: 25),
//                       width: 100.w,
//                       //color: Colors.white,
//                       child: index == 0
//                           ? currentQuestion != 0 && currentQuestion != 1
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "${questions[currentQuestion - 2]["question"]}",
//                                       style: TextStyle(
//                                         color: Colors.black.withOpacity(0.1),
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 24,
//                                       ),
//                                     ),
//                                     questions[currentQuestion - 2]["field"],
//                                     Container(
//                                         width: 100.w * 0.55,
//                                         child: Divider(
//                                           thickness: 4,
//                                           color: Colors.black.withOpacity(0.1),
//                                         ))
//                                   ],
//                                 )
//                               : SizedBox()
//                           : index == 1
//                               ? currentQuestion != 0
//                                   ? Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "${questions[currentQuestion - 1]["question"]}",
//                                           style: TextStyle(
//                                             color:
//                                                 Colors.black.withOpacity(0.2),
//                                             fontWeight: FontWeight.w700,
//                                             fontSize: 24,
//                                           ),
//                                         ),
//                                         questions[currentQuestion - 1]["field"],
//                                         Container(
//                                             width: 100.w * 0.55,
//                                             child: Divider(
//                                               thickness: 4,
//                                               color:
//                                                   Colors.black.withOpacity(0.2),
//                                             ))
//                                       ],
//                                     )
//                                   : SizedBox()
//                               : index == 2
//                                   ? Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "${questions[currentQuestion]["question"]}",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w700,
//                                             fontSize: 24,
//                                           ),
//                                         ),
//                                         questions[currentQuestion]["field"],
//                                         currentQuestion == 0
//                                             ? Container(
//                                                 width: 100.w * 0.70,
//                                                 height: 100,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceAround,
//                                                   children: [
//                                                     InkWell(
//                                                         onTap: () {
//                                                           setState(() {
//                                                             temperature =
//                                                                 "cold";
//                                                           });
//                                                         },
//                                                         child: SvgPicture.asset(
//                                                           "assets/cold.svg",
//                                                           height: temperature ==
//                                                                   "cold"
//                                                               ? 45
//                                                               : 32,
//                                                           color: temperature ==
//                                                                   "cold"
//                                                               ? Colors
//                                                                   .black // Assuming you're using the Flutter framework and have imported the material library
//                                                               : Colors.black
//                                                                   .withOpacity(
//                                                                       0.5),
//                                                         )),
//                                                     InkWell(
//                                                         onTap: () {
//                                                           setState(() {
//                                                             temperature = "hot";
//                                                           });
//                                                         },
//                                                         child: SvgPicture.asset(
//                                                           "assets/hot.svg",
//                                                           height: temperature ==
//                                                                   "hot"
//                                                               ? 45
//                                                               : 32,
//                                                           color: temperature ==
//                                                                   "hot"
//                                                               ? Colors
//                                                                   .black // Assuming you're using the Flutter framework and have imported the material library
//                                                               : Colors.black
//                                                                   .withOpacity(
//                                                                       0.5),
//                                                         )),
//                                                   ],
//                                                 ),
//                                               )
//                                             : currentQuestion == 1
//                                                 ? Container(
//                                                     width: 100.w * 0.55,
//                                                     height: 165,
//                                                     child: Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               vertical: 18),
//                                                       child: CupertinoPicker(
//                                                         itemExtent: 50,
//                                                         //scrollController:sizeController,
//                                                         onSelectedItemChanged:
//                                                             (int index) {
//                                                           setState(() {
//                                                             selection =
//                                                                 selectionOptions[
//                                                                     index];
//                                                           });
//                                                         },
//                                                         children:
//                                                             selectionOptions
//                                                                 .map((String
//                                                                     option) {
//                                                           return Center(
//                                                             child: Text(
//                                                               option,
//                                                               style: TextStyle(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 fontSize: 18,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         }).toList(),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : currentQuestion == 2
//                                                     ? Container(
//                                                         width: 100.w * 0.55,
//                                                         height: 165,
//                                                         child: Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   vertical: 18),
//                                                           child:
//                                                               CupertinoPicker(
//                                                             itemExtent: 50,
//                                                             //scrollController:sizeController,
//                                                             onSelectedItemChanged:
//                                                                 (int index) {
//                                                               setState(() {
//                                                                 size =
//                                                                     sizeOptions[
//                                                                         index];
//                                                               });
//                                                             },
//                                                             children: sizeOptions
//                                                                 .map((String
//                                                                     option) {
//                                                               return Center(
//                                                                 child: Text(
//                                                                   option,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                     fontSize:
//                                                                         18,
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             }).toList(),
//                                                           ),
//                                                         ),
//                                                       )
//                                                     : currentQuestion == 3
//                                                         ? Container(
//                                                             width: 100.w * 0.55,
//                                                             height: 165,
//                                                             child: Padding(
//                                                               padding: EdgeInsets
//                                                                   .symmetric(
//                                                                       vertical:
//                                                                           18),
//                                                               child:
//                                                                   CupertinoPicker(
//                                                                 itemExtent: 50,
//                                                                 //scrollController:milkController,
//                                                                 onSelectedItemChanged:
//                                                                     (int
//                                                                         index) {
//                                                                   setState(() {
//                                                                     milk = milkOptions[
//                                                                         index];
//                                                                   });
//                                                                 },
//                                                                 children: milkOptions
//                                                                     .map((String
//                                                                         option) {
//                                                                   return Center(
//                                                                     child: Text(
//                                                                       option,
//                                                                       style:
//                                                                           TextStyle(
//                                                                         color: Colors
//                                                                             .black,
//                                                                         fontWeight:
//                                                                             FontWeight.w700,
//                                                                         fontSize:
//                                                                             18,
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 }).toList(),
//                                                               ),
//                                                             ),
//                                                           )
//                                                         : currentQuestion == 4
//                                                             ? Container(
//                                                                 width: 100.w *
//                                                                     0.55,
//                                                                 height: 165,
//                                                                 child: Padding(
//                                                                   padding: EdgeInsets
//                                                                       .symmetric(
//                                                                           vertical:
//                                                                               18),
//                                                                   child:
//                                                                       CupertinoPicker(
//                                                                     itemExtent:
//                                                                         50,
//                                                                     children: coffeeShotsList
//                                                                         .map((int
//                                                                             option) {
//                                                                       return Center(
//                                                                         child:
//                                                                             Text(
//                                                                           option
//                                                                               .toString(),
//                                                                           style:
//                                                                               TextStyle(
//                                                                             color:
//                                                                                 Colors.black,
//                                                                             fontWeight:
//                                                                                 FontWeight.w700,
//                                                                             fontSize:
//                                                                                 24,
//                                                                           ),
//                                                                         ),
//                                                                       );
//                                                                     }).toList(),
//                                                                     onSelectedItemChanged:
//                                                                         (int
//                                                                             value) {
//                                                                       setState(
//                                                                           () {
//                                                                         coffeeShots =
//                                                                             value;
//                                                                       });
//                                                                     },
//                                                                   ),
//                                                                 ))
//                                                             : currentQuestion ==
//                                                                     5
//                                                                 ? Container(
//                                                                     width: 100
//                                                                             .w *
//                                                                         0.55,
//                                                                     height: 165,
//                                                                     child:
//                                                                         Padding(
//                                                                       padding: EdgeInsets.symmetric(
//                                                                           vertical:
//                                                                               18),
//                                                                       child:
//                                                                           CupertinoPicker(
//                                                                         itemExtent:
//                                                                             50,
//                                                                         //scrollController:toppingController,
//                                                                         onSelectedItemChanged:
//                                                                             (int
//                                                                                 index) {
//                                                                           setState(
//                                                                               () {
//                                                                             topping =
//                                                                                 toppingOptions[index];
//                                                                           });
//                                                                         },
//                                                                         children:
//                                                                             toppingOptions.map((String
//                                                                                 option) {
//                                                                           return Center(
//                                                                             child:
//                                                                                 Text(
//                                                                               option,
//                                                                               style: TextStyle(
//                                                                                 color: Colors.black,
//                                                                                 fontWeight: FontWeight.w700,
//                                                                                 fontSize: 18,
//                                                                               ),
//                                                                             ),
//                                                                           );
//                                                                         }).toList(),
//                                                                       ),
//                                                                     ),
//                                                                   )
//                                                                 : currentQuestion ==
//                                                                         6
//                                                                     ? Container(
//                                                                         width: 100.w *
//                                                                             0.55,
//                                                                         height:
//                                                                             165,
//                                                                         child:
//                                                                             Padding(
//                                                                           padding:
//                                                                               EdgeInsets.symmetric(vertical: 18),
//                                                                           child:
//                                                                               CupertinoPicker(
//                                                                             itemExtent:
//                                                                                 50,
//                                                                             //scrollController:flavorController,
//                                                                             onSelectedItemChanged:
//                                                                                 (int index) {
//                                                                               setState(() {
//                                                                                 flavor = flavorOptions[index];
//                                                                               });
//                                                                             },
//                                                                             children:
//                                                                                 flavorOptions.map((String option) {
//                                                                               return Center(
//                                                                                 child: Text(
//                                                                                   option,
//                                                                                   style: TextStyle(
//                                                                                     color: Colors.black,
//                                                                                     fontWeight: FontWeight.w700,
//                                                                                     fontSize: 18,
//                                                                                   ),
//                                                                                 ),
//                                                                               );
//                                                                             }).toList(),
//                                                                           ),
//                                                                         ),
//                                                                       )
//                                                                     : Container(
//                                                                         width: 100.w *
//                                                                             0.55,
//                                                                         child:
//                                                                             Divider(
//                                                                           thickness:
//                                                                               4,
//                                                                           color:
//                                                                               Colors.white,
//                                                                         ))
//                                       ],
//                                     )
//                                   : Text(""),
//                     );
//                   }),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 currentQuestion != 0
//                     ? Padding(
//                         padding: const EdgeInsets.only(left: 20.0, bottom: 20),
//                         child: InkWell(
//                           onTap: () {
//                             if (currentQuestion != 0) {
//                               currentQuestion = currentQuestion - 1;
//                               setState(() {});
//                             }
//                           },
//                           child: Container(
//                             width: 110,
//                             height: 60,
//                             color: Colors.white,
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Back",
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     : SizedBox(),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20.0, bottom: 20),
//                   child: InkWell(
//                     onTap: () {
//                       if (currentQuestion == 6) {
//                         Navigator.pushNamed(
//                             context, AppRoutes.cardMarketPlace.coffeeLoader,
//                             arguments: CoffeeOrderLoaderArgs(
//                               coffeeTemperature: temperature,
//                               coffeeSelection: selection,
//                               coffeeSize: size,
//                               coffeeMilk: milk,
//                               coffeeShots: coffeeShots.toString(),
//                               coffeeTopping: topping,
//                               coffeeFlavor: flavor,
//                               cardData: cardData,
//                             ));
//                       } else {
//                         if ((currentQuestion + 1) <= questions.length) {
//                           if (currentQuestion != questions.length - 1) {
//                             currentQuestion = currentQuestion + 1;
//                           }
//                           //int index = questions.length;
//                           //questions.add("");
//                           setState(() {});
//                           //_listKey.currentState?.insertItem(index);
//                         } else {
//                           print("aaa");
//                         }
//                       }
//                     },
//                     child: AnimatedContainer(
//                       width: loadingButton ? 50 : 110,
//                       height: 60,
//                       color: Colors.white,
//                       duration: Duration(milliseconds: 350),
//                       child: loadingButton
//                           ? const Center(
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: CircularProgressIndicator(
//                                   color: Colors.black,
//                                   strokeWidth: 3,
//                                 ),
//                               ),
//                             )
//                           : Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text("Next"),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   SvgPicture.asset("assets/arrow_right.svg")
//                                 ],
//                               ),
//                             ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
