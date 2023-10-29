class EarningsHistoryModel {
  int? status;
  String? message;
  int? count;
  List<Response>? response;

  EarningsHistoryModel({this.status, this.message, this.count, this.response});

  EarningsHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  String? orderNo;
  String? orderDetailId;
  String? fare;
  String? percentage;
  String? finalFare;
  String? finalTotalAmount;
  String? orderDateTime;
  String? responseMessage;
  String? responseImg;
  String? responseDate;
  String? viewStatus;
  String? bgColor;
  String? color;

  Response(
      {this.orderId,
      this.orderNo,
      this.orderDetailId,
      this.fare,
      this.percentage,
      this.finalFare,
      this.finalTotalAmount,
      this.orderDateTime,
      this.responseMessage,
      this.responseImg,
      this.responseDate,
      this.viewStatus,
      this.bgColor,
      this.color});

  Response.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNo = json['order_no'];
    orderDetailId = json['order_detail_id'];
    fare = json['fare'];
    percentage = json['percentage'];
    finalFare = json['final_fare'];
    finalTotalAmount = json['final_total_amount '];
    orderDateTime = json['order_date_time'];
    responseMessage = json['response_message'];
    responseImg = json['response_img'];
    responseDate = json['response_date'];
    viewStatus = json['view_status'];
    bgColor = json['bg_color'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_no'] = this.orderNo;
    data['order_detail_id'] = this.orderDetailId;
    data['fare'] = this.fare;
    data['percentage'] = this.percentage;
    data['final_fare'] = this.finalFare;
    data['final_total_amount '] = this.finalTotalAmount;
    data['order_date_time'] = this.orderDateTime;
    data['response_message'] = this.responseMessage;
    data['response_img'] = this.responseImg;
    data['response_date'] = this.responseDate;
    data['view_status'] = this.viewStatus;
    data['bg_color'] = this.bgColor;
    data['color'] = this.color;
    return data;
  }
}
