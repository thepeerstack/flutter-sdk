import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'the_peer_app_list_model.dart';

class ThePeerAppDetailsModel with EquatableMixin {
  final ThePeerBusiness business;
  ThePeerAppDetailsModel({
    required this.business,
  });

  ThePeerAppDetailsModel copyWith({
    ThePeerBusiness? business,
  }) {
    return ThePeerAppDetailsModel(
      business: business ?? this.business,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'business': business.toMap(),
    };
  }

  factory ThePeerAppDetailsModel.fromMap(Map<String, dynamic> map) {
    return ThePeerAppDetailsModel(
      business: ThePeerBusiness.fromMap(map['business']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerAppDetailsModel.fromJson(String source) =>
      ThePeerAppDetailsModel.fromMap(json.decode(source));

  @override
  String toString() => 'ThePeerAppDetailsModel(business: $business)';

  @override
  List<Object> get props => [business];
}
