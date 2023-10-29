import 'package:book_rides/Models/vehicleInfo.dart';
import 'package:book_rides/Screens/MyOrders.dart';
import 'package:book_rides/Screens/NewRide.dart';
import 'package:book_rides/Screens/RideShare.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/Services/mapServices.dart';
import 'package:book_rides/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'PassengerMapScreen.dart';

final countProvider = StateProvider((ref) => 0);

class OutStation extends StatefulWidget {
  OutStation({super.key});

  @override
  State<OutStation> createState() => _OutStationState();
}

class _OutStationState extends State<OutStation> {
  int _currentIndex = 0;
  final List<Widget> screens = [
    //const NewRide(),
    const RideShare(),
    const MyOrders()
  ];
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.circlePlus),
              label: 'New ride',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.car),
              label: 'Ride share',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.clockRotateLeft),
              label: 'My orders',
            ),
          ],
        ),
      ),
      body: screens[_currentIndex],
      drawer: MyDrawer(),
    );
  }
}
