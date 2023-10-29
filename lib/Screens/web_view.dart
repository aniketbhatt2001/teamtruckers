import 'dart:io';

import 'package:book_rides/Utils/Constatnts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url;

  MyWebView({required this.url});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  var loadingPercentage = 0;
  WebViewController controller = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (Platform.isAndroid)
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          print('page started');
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          print('page in progress');
          setState(() {
            print(progress);
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          print('page finised');
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: primary,
        //   title: Text('Web view'),
        // ),
        body: Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            backgroundColor: Colors.white,
            value: loadingPercentage / 100.0,
          ),
      ],
    ));
  }
}
