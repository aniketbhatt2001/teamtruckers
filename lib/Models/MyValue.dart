import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class MyValue {
  final int value;
  final String desc;

  const MyValue(
    this.value,
    this.desc,
  );

  MyValue copyWith({
    int? value,
    String? desc,
  }) {
    return MyValue(
      value ?? this.value,
      desc ?? this.desc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'desc': desc,
    };
  }

  factory MyValue.fromMap(Map<String, dynamic> map) {
    return MyValue(
      map['value'] as int,
      map['desc'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyValue.fromJson(String source) =>
      MyValue.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MyValue(value: $value, desc: $desc)';

  @override
  bool operator ==(covariant MyValue other) {
    if (identical(this, other)) return true;

    return other.value == value && other.desc == desc;
  }

  @override
  int get hashCode => value.hashCode ^ desc.hashCode;
}
