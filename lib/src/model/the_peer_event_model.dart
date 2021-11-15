import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThepeerEventModel with EquatableMixin {
  final String type;
  ThepeerEventModel({
    required this.type,
  });

  ThepeerEventModel copyWith({
    String? type,
  }) {
    return ThepeerEventModel(
      type: type ?? this.type,
    );
  }

  Map<String, Object> toMap() {
    return {
      'type': type,
    };
  }

  factory ThepeerEventModel.fromMap(Map<String, dynamic> map) {
    return ThepeerEventModel(
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThepeerEventModel.fromJson(String source) =>
      ThepeerEventModel.fromMap(
        json.decode(source),
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type];
}
