// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryList {
  int? status;
  String? message;
  int? count;
  List<Country>? response;

  CountryList({
    this.status,
    this.message,
    this.count,
    this.response,
  });

  CountryList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['response'] != null) {
      response = <Country>[];
      json['response'].forEach((v) {
        response!.add(new Country.fromJson(v));
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

  CountryList copyWith({
    int? status,
    String? message,
    int? count,
    List<Country>? response,
  }) {
    return CountryList(
      status: status ?? this.status,
      message: message ?? this.message,
      count: count ?? this.count,
      response: response ?? this.response,
    );
  }

  @override
  String toString() {
    return 'CountryList(status: $status, message: $message, count: $count, response: $response)';
  }

  @override
  bool operator ==(covariant CountryList other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.message == message &&
        other.count == count &&
        listEquals(other.response, response);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        count.hashCode ^
        response.hashCode;
  }
}

class Country {
  String? name;
  String? flag;
  String? code;
  String? dialCode;
  String? id;
  String? img;

  Country({this.name, this.flag, this.code, this.dialCode, this.id, this.img});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    flag = json['flag'];
    code = json['code'];
    dialCode = json['dial_code'];
    id = json['id'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['flag'] = this.flag;
    data['code'] = this.code;
    data['dial_code'] = this.dialCode;
    data['id'] = this.id;
    data['img'] = this.img;
    return data;
  }

  Country copyWith({
    String? name,
    String? flag,
    String? code,
    String? dialCode,
    String? id,
    String? img,
  }) {
    return Country(
      name: name ?? this.name,
      flag: flag ?? this.flag,
      code: code ?? this.code,
      dialCode: dialCode ?? this.dialCode,
      id: id ?? this.id,
      img: img ?? this.img,
    );
  }
}

// final countryProvider =
//     StateNotifierProvider((ref) => SelectedCountryProvider(Country()));
final countryListProvider = StateNotifierProvider<CountryNotifier, CountryList>(
    (ref) => CountryNotifier(CountryList()));

class SelectedCountryProvider extends StateNotifier<Country> {
  SelectedCountryProvider(super.state);

  updateDialCode(String dialCode) {
    state = state.copyWith(dialCode: dialCode);
  }

  updateCode(String code) {
    state = state.copyWith(code: code);
  }

  updateName(String name) {
    state = state.copyWith(name: name);
  }
}

class CountryNotifier extends StateNotifier<CountryList> {
  CountryNotifier(super.state);

  updateState(CountryList countryList) {
    state = countryList;
  }
}
