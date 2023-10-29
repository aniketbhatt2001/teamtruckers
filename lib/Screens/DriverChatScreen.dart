// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:book_rides/Models/DriverSingleBookingModel.dart';
import 'package:book_rides/Services/apis_services.dart';
import 'package:book_rides/Utils/Constatnts.dart';
import 'package:book_rides/providers/UserModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/GetChatModel.dart';

// final passengerchatProvider =
//     FutureProvider.autoDispose.family((ref, String bookDriverId) {
//   return getPassengerMessage(ref.read(userModelProvider).userId!, bookDriverId);
// });

class DriverChatScreen extends ConsumerStatefulWidget {
  String bookDriverId;
  UserInfo userInfo;
  String message_send_call;
  String message_send_text;
  DriverChatScreen(this.bookDriverId, this.userInfo, this.message_send_call,
      this.message_send_text);
  @override
  _DriverChatScreenState createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends ConsumerState<DriverChatScreen> {
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = [];
  ScrollController scrollController = ScrollController();

  void _handleSubmitted(
    String text,
  ) {
    _textController.clear();
    if (text.trim().isNotEmpty) {
      driverSendMessage(
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => FutureBuilder(
        future: getDriverMessage(
            ref.read(userModelProvider).userId!, widget.bookDriverId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data;
            return LayoutBuilder(
              builder: (p0, p1) => Scaffold(
                  // bottomNavigationBar: _buildTextComposer(
                  //     widget.message_send_call, widget.message_send_text),
                  appBar: AppBar(
                    backgroundColor: primary,
                    // elevation: 0,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              widget.userInfo.profilePic!.isNotEmpty
                                  ? NetworkImage(widget.userInfo.profilePic!)
                                  : null,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(widget.userInfo.fname!),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: ChatList(
                          snapshot: snapshot,
                          scrollController: scrollController,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, top: 10),
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
                                            hintStyle: TextStyle(
                                                color: Colors.black54),
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
                  )
                  // SingleChildScrollView(
                  //   child: Column(
                  //     children: [
                  //       SizedBox(
                  // //           height: p1.maxHeight * 0.81,
                  //           child: ChatList(
                  //             snapshot: snapshot,
                  //             scrollController: scrollController,
                  //           )),
                  //       _buildTextComposer(
                  //           widget.message_send_call, widget.message_send_text)
                  //     ],
                  //   ),
                  // )
                  ),
            );
          } else {
            return Scaffold(
                // bottomNavigationBar: _buildTextComposer(
                //     widget.message_send_call, widget.message_send_text),
                appBar: AppBar(
                  backgroundColor: primary,
                  elevation: 0,
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
                )
                // Column(
                //   children: <Widget>[
                //     Flexible(
                //       child:,
                //     ),
                //     const Divider(height: 1.0),
                //     Container(
                //       decoration: BoxDecoration(color: Theme.of(context).cardColor),
                //       child: _buildTextComposer(
                //           widget.message_send_call, widget.message_send_text),
                //     ),
                //   ],
                // ),
                );
          }
        },
      ),
    );
  }

  // renderChats(AsyncSnapshot<GetChatModel?> snapshot) {
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   // scrollController.jumpTo(scrollController.position.maxScrollExtent);
  //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
  // });

  //   return ChatList();
  // }

  Widget _buildChatListDummy() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _messages.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(_messages[index]),
        );
      },
    );
  }

  Widget _buildTextComposer(String sendCall, String sendText) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Row(
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
                      : Text(
                          sendText,
                          maxLines: null,
                        ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ],
          ),
        ],
      ),
    );

    // Container(
    //   decoration: BoxDecoration(color: Theme.of(context).cardColor),
    //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //   child: Row(
    //     children: <Widget>[
    //       Flexible(
    //         child: Padding(
    //           padding: EdgeInsets.only(
    //               bottom: MediaQuery.of(context).viewInsets.bottom),
    //           child: sendCall != '0'
    //               ? TextField(
    //                   maxLines: null,
    //                   controller: _textController,
    //                   onSubmitted: _handleSubmitted,
    //                   decoration: const InputDecoration.collapsed(
    //                     hintText: 'Send a message',
    //                   ),
    //                 )
    //               : Text(
    //                   sendText,
    //                   maxLines: null,
    //                 ),
    //         ),
    //       ),
    //       IconButton(
    //         icon: const Icon(Icons.send),
    //         onPressed: () => _handleSubmitted(_textController.text),
    //       ),
    //     ],
    //   ),
    // );
    ;
  }
}

class ChatList extends StatefulWidget {
  final AsyncSnapshot<GetChatModel?> snapshot;
  final ScrollController scrollController;
  const ChatList({
    required this.snapshot,
    required this.scrollController,
    super.key,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
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
                    final String dateTime = chat.dateTime!;
                    final bool isSent = chat.showOn == 'right';
                    final bool messageSent = chat.isSent == '1';
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
