import 'package:book_rides/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../Utils/Constatnts.dart';

class RideShare extends StatelessWidget {
  const RideShare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Rideshare',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text(
                    'Ride Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text(
                    'Request',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: myDecoration,
            child: ListTile(
              title: const Text("From"),
              // subtitle: const Text(
              //   'To',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: myDecoration,
            child: ListTile(
              title: const Text("To"),
              // subtitle: const Text(
              //   'To',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: myDecoration,
                  child: ListTile(
                    title: const Text("From"),
                    // subtitle: const Text(
                    //   'To',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: myDecoration,
                  child: ListTile(
                    title: const Text("Seats"),
                    // subtitle: const Text(
                    //   'To',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, shape: roundedRectangleBorder),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Find ride'),
              ),
            ),
          ),
          const Divider(
            height: 30,
          ),
          const Text(
            'Here you\'ll see rides that suit you',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            maxLines: null,
          )
        ],
      ),
    );
  }
}
