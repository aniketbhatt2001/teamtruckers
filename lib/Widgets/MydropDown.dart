// import 'package:book_rides/Models/CountryListModel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class MyDropDown extends ConsumerStatefulWidget {
//   const MyDropDown({Key? key}) : super(key: key);

//   @override
//   _MyDropDownState createState() => _MyDropDownState();
// }

// class _MyDropDownState extends ConsumerState<MyDropDown> {
// // Initial Selected Value
//   String? dropdownvalue;

// // List of items in our dropdown menu
//   List<String> items = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     items = ref
//         .read(countryListProvider)
//         .response!
//         .map((e) => e.dialCode!)
//         .toList();
//     //  / items
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton(
//       hint: Text('+91'),
//       underline: SizedBox(),
//       // Initial Value
//       value: dropdownvalue,

//       // Down Arrow Icon
//       icon: const Icon(Icons.keyboard_arrow_down),

//       // Array list of items
//       items: items.map((String items) {
//         return DropdownMenuItem(
//           value: items,
//           child: SizedBox(width: 50, child: Text(items)),
//         );
//       }).toList(),
//       // After selecting the desired option,it will
//       // change button value to selected value
//       onChanged: (String? newValue) {
//         setState(() {
//           dropdownvalue = newValue!;
//         });
//       },
//     );
//   }
// }
