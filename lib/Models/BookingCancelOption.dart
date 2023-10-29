class BookingCancelOptions {
  int? status;
  String? message;
  int? count;
  List<Options>? response;

  BookingCancelOptions({this.status, this.message, this.count, this.response});

  BookingCancelOptions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['response'] != null) {
      response = <Options>[];
      json['response'].forEach((v) {
        response!.add(new Options.fromJson(v));
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

class Options {
  String? type;
  String? optionName;

  Options({this.type, this.optionName});

  Options.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    optionName = json['option_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['option_name'] = this.optionName;
    return data;
  }
}
