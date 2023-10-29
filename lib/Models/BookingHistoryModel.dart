class BookingHistoryModel {
  int? status;
  String? message;
  int? count;
  List<Response>? response;

  BookingHistoryModel({this.status, this.message, this.count, this.response});

  BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? bookDriverId;
  String? bdId;
  String? userId;
  String? catSlug;
  String? catName;
  String? dateTime;
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
  String? final_fare;
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
  List<BidDriverUserInfo>? driverUserInfo;
  String? bidInfoShow;
  List<BidInfo>? bidInfo;

  Response(
      {this.bookDriverId,
      this.bdId,
      this.userId,
      this.catSlug,
      this.catName,
      this.dateTime,
      this.sourceLatitude,
      this.sourceLongitude,
      this.destinationLatitude,
      this.destinationLongitude,
      this.sourceCity,
      this.final_fare,
      this.destinationCity,
      this.sourceLocationAddress,
      this.destinationLocationAddress,
      this.bookingDate,
      this.bookingTime,
      this.fare,
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
    bdId = json['bd_id'];
    userId = json['user_id'];
    catSlug = json['cat_slug'];
    catName = json['cat_name'];
    dateTime = json['date_time'];
    final_fare = json['final_fare'];
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
        userInfo!.add(UserInfo.fromJson(v));
      });
    }
    if (json['driver_user_info'] != null) {
      driverUserInfo = [];
      json['driver_user_info'].forEach((v) {
        driverUserInfo!.add(BidDriverUserInfo.fromJson(v));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['book_driver_id'] = this.bookDriverId;
    data['bd_id'] = this.bdId;
    data['user_id'] = this.userId;
    data['cat_slug'] = this.catSlug;
    data['cat_name'] = this.catName;
    data['date_time'] = this.dateTime;
    data['source_latitude'] = this.sourceLatitude;
    data['source_longitude'] = this.sourceLongitude;
    data['destination_latitude'] = this.destinationLatitude;
    data['destination_longitude'] = this.destinationLongitude;
    data['source_city'] = this.sourceCity;
    data['destination_city'] = this.destinationCity;
    data['source_location_address'] = this.sourceLocationAddress;
    data['destination_location_address'] = this.destinationLocationAddress;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['fare'] = this.fare;
    data['comments'] = this.comments;
    data['main_title'] = this.mainTitle;
    data['show_top_title_line'] = this.showTopTitleLine;
    data['show_top_title'] = this.showTopTitle;
    data['show_time'] = this.showTime;
    data['show_cancel_req_btn'] = this.showCancelReqBtn;
    data['show_cancel_req_btn_title'] = this.showCancelReqBtnTitle;
    data['driver_user_status'] = this.driverUserStatus;
    data['driver_user_reason'] = this.driverUserReason;
    data['user_status'] = this.userStatus;
    data['user_sts_date_time'] = this.userStsDateTime;
    data['user_reason'] = this.userReason;
    data['driver_user_rating'] = this.driverUserRating;
    data['driver_user_review'] = this.driverUserReview;
    data['driver_user_rr_date_time'] = this.driverUserRrDateTime;
    data['user_rating'] = this.userRating;
    data['user_review'] = this.userReview;
    data['user_rr_date_time'] = this.userRrDateTime;
    data['verify_code'] = this.verifyCode;
    data['verify_code_msg'] = this.verifyCodeMsg;
    data['driver_user_complete'] = this.driverUserComplete;
    data['driver_user_complete_date_time'] = this.driverUserCompleteDateTime;
    data['booking_active'] = this.bookingActive;
    data['show_status'] = this.showStatus;
    data['show_status_bgcolor'] = this.showStatusBgcolor;
    data['distance'] = this.distance;
    data['away_distance'] = this.awayDistance;
    data['away_time'] = this.awayTime;
    data['is_driver_bid_on'] = this.isDriverBidOn;
    data['show_suggest_btn'] = this.showSuggestBtn;
    data['show_suggest_btn_title'] = this.showSuggestBtnTitle;
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo!.map((v) => v.toJson()).toList();
    }
    if (this.driverUserInfo != null) {
      data['driver_user_info'] =
          this.driverUserInfo!.map((v) => v.toJson()).toList();
    }
    data['bid_info_show'] = this.bidInfoShow;
    if (this.bidInfo != null) {
      data['bid_info'] = this.bidInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BidInfo {
  String? bookDriverBidId;
  String? bdBidId;
  String? userId;
  String? driverUserId;
  String? bdId;
  String? bookingDate;
  String? bookingTime;
  String? fare;
  String? comments;
  String? dateTime;
  String? showTime;
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
      this.driverUserId,
      this.bdId,
      this.bookingDate,
      this.bookingTime,
      this.fare,
      this.comments,
      this.dateTime,
      this.showTime,
      this.shownBidStatus,
      this.shownBidStatusBgcolor,
      this.showAcceptBtn,
      this.showAcceptBtnTitle,
      this.showRejectBtn,
      this.showRejectBtnTitle,
      this.bidDriverUserInfo});

  BidInfo.fromJson(Map<String, dynamic> json) {
    bookDriverBidId = json['book_driver_bid_id'];
    bdBidId = json['bd_bid_id'];
    userId = json['user_id'];
    driverUserId = json['driver_user_id'];
    bdId = json['bd_id'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    fare = json['fare'];
    comments = json['comments'];
    dateTime = json['date_time'];
    showTime = json['show_time'];
    shownBidStatus = json['shown_bid_status'];
    shownBidStatusBgcolor = json['shown_bid_status_bgcolor'];
    showAcceptBtn = json['show_accept_btn'];
    showAcceptBtnTitle = json['show_accept_btn_title'];
    showRejectBtn = json['show_reject_btn'];
    showRejectBtnTitle = json['show_reject_btn_title'];
    if (json['bid_driver_user_info'] != null) {
      bidDriverUserInfo = <BidDriverUserInfo>[];
      json['bid_driver_user_info'].forEach((v) {
        bidDriverUserInfo!.add(BidDriverUserInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['book_driver_bid_id'] = this.bookDriverBidId;
    data['bd_bid_id'] = this.bdBidId;
    data['user_id'] = this.userId;
    data['driver_user_id'] = this.driverUserId;
    data['bd_id'] = this.bdId;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['fare'] = this.fare;
    data['comments'] = this.comments;
    data['date_time'] = this.dateTime;
    data['show_time'] = this.showTime;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_slug'] = this.userSlug;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['profile_pic'] = this.profilePic;
    data['latitudes'] = this.latitudes;
    data['longitude'] = this.longitude;
    data['rating'] = this.rating;
    data['rating_average'] = this.ratingAverage;
    data['rating_average_user'] = this.ratingAverageUser;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_slug'] = this.userSlug;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['profile_pic'] = this.profilePic;
    data['latitudes'] = this.latitudes;
    data['longitude'] = this.longitude;
    data['rating'] = this.rating;
    data['rating_average'] = this.ratingAverage;
    data['rating_average_user'] = this.ratingAverageUser;
    return data;
  }
}
