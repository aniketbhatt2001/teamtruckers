import 'dart:developer';

class SingleBookingModel {
  int? status;
  String? message;
  int? count;
  List<Response>? response;

  SingleBookingModel({this.status, this.message, this.count, this.response});

  SingleBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    print('status$status');
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
    data['status'] = status;
    data['message'] = message;
    data['count'] = count;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BidInfo {
  String? bookDriverBidId;
  String? bdBidId;
  String? finalFare;
  String? percentage;
  String? amountMsg;

  String? rating_average;
  String? rating_average_user;
  String? userId;
  String? driverUserId;
  String? bdId;
  String? bookingDate;
  String? bookingTime;
  String? fare;
  String? comments;
  String? shownBidStatus;
  String? shownBidStatusBgcolor;
  String? showAcceptBtn;
  String? showAcceptBtnTitle;
  String? showRejectBtn;
  String? showRejectBtnTitle;
  List<BidDriverUserInfo>? bidDriverUserInfo;

  BidInfo(
      {this.bookDriverBidId,
      this.bdBidId,
      this.userId,
      this.amountMsg,
      this.finalFare,
      this.percentage,
      this.driverUserId,
      this.bdId,
      this.bookingDate,
      this.bookingTime,
      this.fare,
      this.comments,
      this.shownBidStatus,
      this.shownBidStatusBgcolor,
      this.showAcceptBtn,
      this.showAcceptBtnTitle,
      this.showRejectBtn,
      this.showRejectBtnTitle,
      this.rating_average_user,
      this.rating_average,
      this.bidDriverUserInfo});

  BidInfo.fromJson(Map<String, dynamic> json) {
    bookDriverBidId = json['book_driver_bid_id'];
    bdBidId = json['bd_bid_id'];
    userId = json['user_id'];
    finalFare = json['final_fare'].toString();
    percentage = json['percentage'].toString();
    amountMsg = json['amount_msg'].toString();
    driverUserId = json['driver_user_id'];
    bdId = json['bd_id'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    fare = json['fare'];
    comments = json['comments'];
    shownBidStatus = json['shown_bid_status'];
    shownBidStatusBgcolor = json['shown_bid_status_bgcolor'];
    showAcceptBtn = json['show_accept_btn'];
    showAcceptBtnTitle = json['show_accept_btn_title'];
    showRejectBtn = json['show_reject_btn'];
    showRejectBtnTitle = json['show_reject_btn_title'];
    rating_average = json['rating_average'];
    rating_average_user = json['rating_average_user'];
    if (json['bid_driver_user_info'] != null) {
      bidDriverUserInfo = <BidDriverUserInfo>[];
      json['bid_driver_user_info'].forEach((v) {
        bidDriverUserInfo!.add(new BidDriverUserInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_driver_bid_id'] = this.bookDriverBidId;
    data['bd_bid_id'] = this.bdBidId;
    data['user_id'] = this.userId;
    data['driver_user_id'] = this.driverUserId;
    data['bd_id'] = this.bdId;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['fare'] = this.fare;
    data['comments'] = this.comments;
    data['shown_bid_status'] = this.shownBidStatus;
    data['shown_bid_status_bgcolor'] = this.shownBidStatusBgcolor;
    data['show_accept_btn'] = this.showAcceptBtn;
    data['show_accept_btn_title'] = this.showAcceptBtnTitle;
    data['show_reject_btn'] = this.showRejectBtn;
    data['show_reject_btn_title'] = this.showRejectBtnTitle;
    if (this.bidDriverUserInfo != null) {
      data['bid_driver_user_info'] =
          this.bidDriverUserInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BidDriverUserInfo {
  String? userId;
  String? userSlug;
  String? fname;
  String? lname;
  String? email;
  String? mobile;
  String? profilePic;
  String? latitudes;
  String? longitude;
  String? rating;
  String? ratingAverage;
  String? ratingAverageUser;

  BidDriverUserInfo(
      {this.userId,
      this.userSlug,
      this.fname,
      this.lname,
      this.email,
      this.mobile,
      this.profilePic,
      this.latitudes,
      this.longitude,
      this.rating,
      this.ratingAverage,
      this.ratingAverageUser});

  BidDriverUserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userSlug = json['user_slug'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    profilePic = json['profile_pic'];
    latitudes = json['latitudes'];
    longitude = json['longitude'];
    rating = json['rating'];
    ratingAverage = json['rating_average'];
    ratingAverageUser = json['rating_average_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userId;
    data['user_slug'] = userSlug;
    data['fname'] = fname;
    data['lname'] = lname;
    data['email'] = email;
    data['mobile'] = mobile;
    data['profile_pic'] = profilePic;
    data['latitudes'] = latitudes;
    data['longitude'] = longitude;
    data['rating'] = rating;
    data['rating_average'] = ratingAverage;
    data['rating_average_user'] = ratingAverageUser;
    return data;
  }
}

class Response {
  String? bookDriverId;
  String? bdId;
  String? userId;
  String? catSlug;
  String? catName;
  String? dateTime;
  String? amountMsg;
  String? sourceLatitude;
  String? sourceLongitude;
  String? destinationLatitude;
  String? destinationLongitude;
  String? sourceCity;
  String? destinationCity;
  String? sourceLocationAddress;
  String? destinationLocationAddress;
  String? bookingDate;
  String? bookingTime;
  String? fare;
  String? finalFare;
  String? percentage;
  String? comments;
  String? mainTitle;
  String? showTopTitleLine;
  String? showTopTitle;
  String? showTime;
  String? showCancelReqBtn;
  String? showCancelReqBtnTitle;
  String? driverUserStatus;
  String? driverUserReason;
  String? userStatus;
  String? userStsDateTime;
  String? userReason;
  String? driverUserRating;
  String? driverUserReview;
  String? driverUserRrDateTime;
  String? userRating;
  String? userReview;
  String? userRrDateTime;
  String? verifyCode;
  String? verifyCodeMsg;
  String? driverUserComplete;
  String? driverUserCompleteDateTime;
  String? bookingActive;
  String? showStatus;
  String? showStatusBgcolor;
  String? distance;
  String? awayDistance;
  String? awayTime;
  String? isDriverBidOn;
  String? showSuggestBtn;
  String? showSuggestBtnTitle;
  List<UserInfo>? userInfo;
  List? driverUserInfo;
  String? bidInfoShow;
  List<BidInfo>? bidInfo;

  Response(
      {this.bookDriverId,
      this.bdId,
      this.userId,
      this.catSlug,
      this.catName,
      this.amountMsg,
      this.dateTime,
      this.sourceLatitude,
      this.sourceLongitude,
      this.destinationLatitude,
      this.destinationLongitude,
      this.sourceCity,
      this.destinationCity,
      this.sourceLocationAddress,
      this.destinationLocationAddress,
      this.bookingDate,
      this.bookingTime,
      this.fare,
      this.finalFare,
      this.percentage,
      this.comments,
      this.mainTitle,
      this.showTopTitleLine,
      this.showTopTitle,
      this.showTime,
      this.showCancelReqBtn,
      this.showCancelReqBtnTitle,
      this.driverUserStatus,
      this.driverUserReason,
      this.userStatus,
      this.userStsDateTime,
      this.userReason,
      this.driverUserRating,
      this.driverUserReview,
      this.driverUserRrDateTime,
      this.userRating,
      this.userReview,
      this.userRrDateTime,
      this.verifyCode,
      this.verifyCodeMsg,
      this.driverUserComplete,
      this.driverUserCompleteDateTime,
      this.bookingActive,
      this.showStatus,
      this.showStatusBgcolor,
      this.distance,
      this.awayDistance,
      this.awayTime,
      this.isDriverBidOn,
      this.showSuggestBtn,
      this.showSuggestBtnTitle,
      this.userInfo,
      this.driverUserInfo,
      this.bidInfoShow,
      this.bidInfo});

  Response.fromJson(Map<String, dynamic> json) {
    bookDriverId = json['book_driver_id'];
    finalFare = json['final_fare'];
    percentage = json['percentage'];
    bdId = json['bd_id'];
    amountMsg = json['amountMsg'];
    userId = json['user_id'];
    catSlug = json['cat_slug'];
    catName = json['cat_name'];
    dateTime = json['date_time'];
    sourceLatitude = json['source_latitude'];
    sourceLongitude = json['source_longitude'];
    destinationLatitude = json['destination_latitude'];
    destinationLongitude = json['destination_longitude'];
    sourceCity = json['source_city'];
    destinationCity = json['destination_city'];
    sourceLocationAddress = json['source_location_address'];
    destinationLocationAddress = json['destination_location_address'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    fare = json['fare'];
    comments = json['comments'];
    mainTitle = json['main_title'];
    showTopTitleLine = json['show_top_title_line'];
    showTopTitle = json['show_top_title'];
    showTime = json['show_time'];
    showCancelReqBtn = json['show_cancel_req_btn'];
    showCancelReqBtnTitle = json['show_cancel_req_btn_title'];
    driverUserStatus = json['driver_user_status'];
    driverUserReason = json['driver_user_reason'];
    userStatus = json['user_status'];
    userStsDateTime = json['user_sts_date_time'];
    userReason = json['user_reason'];
    driverUserRating = json['driver_user_rating'];
    driverUserReview = json['driver_user_review'];
    driverUserRrDateTime = json['driver_user_rr_date_time'];
    userRating = json['user_rating'];
    userReview = json['user_review'];
    userRrDateTime = json['user_rr_date_time'];
    verifyCode = json['verify_code'];
    verifyCodeMsg = json['verify_code_msg'];
    driverUserComplete = json['driver_user_complete'];
    driverUserCompleteDateTime = json['driver_user_complete_date_time'];
    bookingActive = json['booking_active'];
    showStatus = json['show_status'];
    showStatusBgcolor = json['show_status_bgcolor'];
    distance = json['distance'];
    awayDistance = json['away_distance'];
    awayTime = json['away_time'];
    isDriverBidOn = json['is_driver_bid_on'];
    showSuggestBtn = json['show_suggest_btn'];
    showSuggestBtnTitle = json['show_suggest_btn_title'];
    if (json['user_info'] != null) {
      userInfo = <UserInfo>[];
      json['user_info'].forEach((v) {
        userInfo!.add(new UserInfo.fromJson(v));
      });
    }
    if (json['driver_user_info'] != null) {
      driverUserInfo = [];
      json['driver_user_info'].forEach((v) {
        driverUserInfo!.add((v));
      });
    }
    bidInfoShow = json['bid_info_show'];
    if (json['bid_info'] != null) {
      bidInfo = [];
      json['bid_info'].forEach((v) {
        bidInfo!.add(BidInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_driver_id'] = bookDriverId;
    data['bd_id'] = bdId;
    data['user_id'] = userId;
    data['amountMsg'] = amountMsg;
    data['percentage'] = percentage;
    data['final_fare'] = finalFare;
    data['cat_slug'] = catSlug;
    data['cat_name'] = catName;
    data['date_time'] = dateTime;
    data['source_latitude'] = sourceLatitude;
    data['source_longitude'] = sourceLongitude;
    data['destination_latitude'] = destinationLatitude;
    data['destination_longitude'] = destinationLongitude;
    data['source_city'] = sourceCity;
    data['destination_city'] = destinationCity;
    data['source_location_address'] = sourceLocationAddress;
    data['destination_location_address'] = destinationLocationAddress;
    data['booking_date'] = bookingDate;
    data['booking_time'] = bookingTime;
    data['fare'] = fare;
    data['comments'] = comments;
    data['main_title'] = mainTitle;
    data['show_top_title_line'] = showTopTitleLine;
    data['show_top_title'] = showTopTitle;
    data['show_time'] = showTime;
    data['show_cancel_req_btn'] = showCancelReqBtn;
    data['show_cancel_req_btn_title'] = showCancelReqBtnTitle;
    data['driver_user_status'] = driverUserStatus;
    data['driver_user_reason'] = driverUserReason;
    data['user_status'] = userStatus;
    data['user_sts_date_time'] = userStsDateTime;
    data['user_reason'] = userReason;
    data['driver_user_rating'] = driverUserRating;
    data['driver_user_review'] = driverUserReview;
    data['driver_user_rr_date_time'] = driverUserRrDateTime;
    data['user_rating'] = userRating;
    data['user_review'] = userReview;
    data['user_rr_date_time'] = userRrDateTime;
    data['verify_code'] = verifyCode;
    data['verify_code_msg'] = verifyCodeMsg;
    data['driver_user_complete'] = driverUserComplete;
    data['driver_user_complete_date_time'] = driverUserCompleteDateTime;
    data['booking_active'] = bookingActive;
    data['show_status'] = showStatus;
    data['show_status_bgcolor'] = showStatusBgcolor;
    data['distance'] = distance;
    data['away_distance'] = awayDistance;
    data['away_time'] = awayTime;
    data['is_driver_bid_on'] = isDriverBidOn;
    data['show_suggest_btn'] = showSuggestBtn;
    data['show_suggest_btn_title'] = showSuggestBtnTitle;
    if (userInfo != null) {
      data['user_info'] = userInfo!.map((v) => v.toJson()).toList();
    }
    if (driverUserInfo != null) {
      data['driver_user_info'] =
          driverUserInfo!.map((v) => v.toJson()).toList();
    }
    data['bid_info_show'] = bidInfoShow;
    if (bidInfo != null) {
      data['bid_info'] = bidInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserInfo {
  String? userId;
  String? userSlug;
  String? fname;
  String? lname;
  String? email;
  String? mobile;
  String? profilePic;
  String? latitudes;
  String? longitude;
  String? rating;
  String? ratingAverage;
  String? ratingAverageUser;

  UserInfo(
      {this.userId,
      this.userSlug,
      this.fname,
      this.lname,
      this.email,
      this.mobile,
      this.profilePic,
      this.latitudes,
      this.longitude,
      this.rating,
      this.ratingAverage,
      this.ratingAverageUser});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userSlug = json['user_slug'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    profilePic = json['profile_pic'];
    latitudes = json['latitudes'];
    longitude = json['longitude'];
    rating = json['rating'];
    ratingAverage = json['rating_average'];
    ratingAverageUser = json['rating_average_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userId;
    data['user_slug'] = userSlug;
    data['fname'] = fname;
    data['lname'] = lname;
    data['email'] = email;
    data['mobile'] = mobile;
    data['profile_pic'] = profilePic;
    data['latitudes'] = latitudes;
    data['longitude'] = longitude;
    data['rating'] = rating;
    data['rating_average'] = ratingAverage;
    data['rating_average_user'] = ratingAverageUser;
    return data;
  }
}
