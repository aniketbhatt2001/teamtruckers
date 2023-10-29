class GetChatModel {
  int? status;
  String? message;
  int? count;
  List<Response>? response;

  GetChatModel({this.status, this.message, this.count, this.response});

  GetChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? date;
  List<Chat>? chat;

  Response({this.date, this.chat});

  Response.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['chat'] != null) {
      chat = <Chat>[];
      json['chat'].forEach((v) {
        chat!.add(new Chat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.chat != null) {
      data['chat'] = this.chat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chat {
  String? cId;
  String? bookDriverId;
  String? senderId;
  String? receiverId;
  String? message;
  String? attachment;
  String? dateTime;
  String? isSent;
  String? isRead;
  String? showOn;

  Chat(
      {this.cId,
      this.bookDriverId,
      this.senderId,
      this.receiverId,
      this.message,
      this.attachment,
      this.dateTime,
      this.isSent,
      this.isRead,
      this.showOn});

  Chat.fromJson(Map<String, dynamic> json) {
    cId = json['c_id'];
    bookDriverId = json['book_driver_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    attachment = json['attachment'];
    dateTime = json['date_time'];
    isSent = json['is_sent'];
    isRead = json['is_read'];
    showOn = json['show_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['c_id'] = this.cId;
    data['book_driver_id'] = this.bookDriverId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['date_time'] = this.dateTime;
    data['is_sent'] = this.isSent;
    data['is_read'] = this.isRead;
    data['show_on'] = this.showOn;
    return data;
  }
}
