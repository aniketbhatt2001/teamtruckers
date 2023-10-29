class HistoryHeaders {
  int? status;
  String? message;
  int? count;
  List<Response>? response;

  HistoryHeaders({this.status, this.message, this.count, this.response});

  HistoryHeaders.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? value;
  String? bgColor;
  String? color;
  String? count;

  Response({this.title, this.value, this.bgColor, this.color, this.count});

  Response.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
    bgColor = json['bg_color'];
    color = json['color'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['value'] = this.value;
    data['bg_color'] = this.bgColor;
    data['color'] = this.color;
    data['count'] = this.count;
    return data;
  }
}
