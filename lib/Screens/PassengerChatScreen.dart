// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:book_rides/Models/UserSingleBookingModel.dart';
import 'package:book_rides/Screens/RequestHistory.dart';
import 'package:book_rides/Screens/UserSingleBooking.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../Models/GetChatModel.dart';
import 'DriverSingleBooking.dart';

// final passengerchatProvider =
//     FutureProvider.autoDispose.family((ref, String bookDriverId) {
//   return getPassengerMessage(ref.read(userModelProvider).userId!, bookDriverId);
// });

class PassengerChatSCreen extends ConsumerStatefulWidget {
  String bookDriverId;
  String message_send_call;
  String message_send_text;
  DriverUserInfo driverUserInfo;
  PassengerChatSCreen(this.bookDriverId, this.message_send_call,
      this.message_send_text, this.driverUserInfo);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<PassengerChatSCreen> {
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = [];
  ScrollController scrollController = ScrollController();

  void _handleSubmitted(
    String text,
  ) {
    _textController.clear();
    if (mounted) {
      passengerSendMessage(
          ref.read(userModelProvider).userId!, widget.bookDriverId, text);
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(UserSingleBooking(
          book_driver_id: widget.bookDriverId,
        ));
        return false;
      },
      child: FutureBuilder(
        future: getPassengerMessage(
            ref.read(userModelProvider).userId!, widget.bookDriverId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // final data = snapshot.data;
            return LayoutBuilder(
              builder: (p0, p1) => Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Get.off(UserSingleBooking(
                        book_driver_id: widget.bookDriverId,
                      ));
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  backgroundColor: primary,
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget
                                .driverUserInfo.profilePic!.isNotEmpty
                            ? NetworkImage(widget.driverUserInfo.profilePic!)
                            : null,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(widget.driverUserInfo.fname!),
                    ],
                  ),
                ),
                body: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: PassengerChatList(
                        snapshot: snapshot,
                        scrollController: scrollController,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        height: 60,
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: widget.message_send_call != '0'
                                  ? TextField(
                                      controller: _textController,
                                      decoration: InputDecoration(
                                          hintText: "Write message...",
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none),
                                    )
                                  : Text(
                                      widget.message_send_text,
                                      maxLines: null,
                                    ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            widget.message_send_call != '0'
                                ? FloatingActionButton(
                                    onPressed: () {
                                      _handleSubmitted(_textController.text);
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    backgroundColor: primary,
                                    elevation: 0,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: primary,
                title: const Text('Chat'),
              ),
              body: Stack(
                children: <Widget>[
                  _buildChatListDummy(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: widget.message_send_call != '0'
                                ? TextField(
                                    controller: _textController,
                                    decoration: InputDecoration(
                                        hintText: "Write message...",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        border: InputBorder.none),
                                  )
                                : Text(
                                    widget.message_send_text,
                                    maxLines: null,
                                  ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          widget.message_send_call != '0'
                              ? FloatingActionButton(
                                  onPressed: () {
                                    _handleSubmitted(_textController.text);
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  backgroundColor: primary,
                                  elevation: 0,
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildChatListDummy() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(_messages[index]),
        );
      },
    );
  }

// }
  Widget _buildTextComposer(String sendCall, String sendText) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: sendCall != '0'
                  ? TextField(
                      maxLines: null,
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Send a message',
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        sendText,
                        textAlign: TextAlign.center,
                        maxLines: null,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ),
          sendCall != '0'
              ? IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class PassengerChatList extends ConsumerStatefulWidget {
  final AsyncSnapshot<GetChatModel?> snapshot;
  final ScrollController scrollController;
  const PassengerChatList({
    required this.scrollController,
    required this.snapshot,
    super.key,
  });

  @override
  ConsumerState<PassengerChatList> createState() => _PassengerChatListState();
}

class _PassengerChatListState extends ConsumerState<PassengerChatList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // scrollController.jumpTo(scrollController.position.maxScrollExtent);
      widget.scrollController
          .jumpTo(widget.scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.snapshot.data!.response!.length,
          itemBuilder: (BuildContext context, int myindex) {
            final chatData = widget.snapshot.data!.response![myindex];
            final String date = chatData.date!;
            //final List<Map<String, dynamic>> chats = chatData.chat;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(date),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      widget.snapshot.data!.response![myindex].chat!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final chat =
                        widget.snapshot.data!.response![myindex].chat![index];
                    final String message = chat.message!;
                    //final String senderId = chat.senderId!;
                    final bool isSent = chat.showOn == 'right';
                    final bool messageSent = chat.isSent == '1';
                    final String dateTime = chat.dateTime!;
                    return Align(
                      alignment:
                          isSent ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isSent ? primary : Colors.grey,
                          ),
                          width: 230,
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: chat.showOn == 'right'
                              //     ? MainAxisAlignment.end
                              //     : MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    message,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: null,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        dateTime,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      messageSent
                                          ? Icon(
                                              //   messageSent ? Icons.done_all : null,
                                              Icons.done_all,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                ),
              ],
            );
          },
        ),

        // Container(
        //   decoration: BoxDecoration(
        //       color: Theme.of(context).cardColor),
        //   child: _buildTextComposer(),
        // ),
      ],
    );
  }
}
