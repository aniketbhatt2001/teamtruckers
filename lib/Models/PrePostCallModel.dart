class PrePostCallModel {
  int? status;
  String? message;
  int? count;
  List<Response>? response;

  PrePostCallModel({this.status, this.message, this.count, this.response});

  PrePostCallModel.fromJson(Map<String, dynamic> json) {
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
  String? orderTotalCost;
  String? finalTotalAmount;
  String? redirectToPaymentGateway;
  String? redirectToFinalPayment;
  String? userId;
  String? orderNo;
  String? userName;
  String? userEmail;
  String? userMobile;
  String? userAddress;
  String? userCountries;
  String? userState;
  String? userCity;
  String? userPincode;

  Response(
      {this.orderTotalCost,
      this.finalTotalAmount,
      this.redirectToPaymentGateway,
      this.redirectToFinalPayment,
      this.userId,
      this.orderNo,
      this.userName,
      this.userEmail,
      this.userMobile,
      this.userAddress,
      this.userCountries,
      this.userState,
      this.userCity,
      this.userPincode});

  Response.fromJson(Map<String, dynamic> json) {
    orderTotalCost = json['order_total_cost'];
    finalTotalAmount = json['final_total_amount'];
    redirectToPaymentGateway = json['redirect_to_payment_gateway'];
    redirectToFinalPayment = json['redirect_to_final_payment'];
    userId = json['user_id'];
    orderNo = json['order_no'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userMobile = json['user_mobile'];
    userAddress = json['user_address'];
    userCountries = json['user_countries'];
    userState = json['user_state'];
    userCity = json['user_city'];
    userPincode = json['user_pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_total_cost'] = this.orderTotalCost;
    data['final_total_amount'] = this.finalTotalAmount;
    data['redirect_to_payment_gateway'] = this.redirectToPaymentGateway;
    data['redirect_to_final_payment'] = this.redirectToFinalPayment;
    data['user_id'] = this.userId;
    data['order_no'] = this.orderNo;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_mobile'] = this.userMobile;
    data['user_address'] = this.userAddress;
    data['user_countries'] = this.userCountries;
    data['user_state'] = this.userState;
    data['user_city'] = this.userCity;
    data['user_pincode'] = this.userPincode;
    return data;
  }
}
