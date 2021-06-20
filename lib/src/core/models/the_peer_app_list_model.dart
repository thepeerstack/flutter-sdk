import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'the_peer_business_model.dart';

class ThePeerAppListModel with EquatableMixin {
  final List<ThePeerBusiness>? businesses;
  ThePeerAppListModel({
    required this.businesses,
  });

  ThePeerAppListModel copyWith({
    List<ThePeerBusiness>? businesses,
  }) {
    return ThePeerAppListModel(
      businesses: businesses ?? this.businesses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businesses': businesses?.map((x) => x.toMap()).toList(),
    };
  }

  factory ThePeerAppListModel.fromMap(Map<String, dynamic> map) {
    return ThePeerAppListModel(
      businesses: List<ThePeerBusiness>.from(
          map['businesses']?.map((x) => ThePeerBusiness.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerAppListModel.fromJson(String source) =>
      ThePeerAppListModel.fromMap(json.decode(source));

  @override
  String toString() => 'ThePeerAppListModel(businesses: $businesses)';

  @override
  int get hashCode => businesses.hashCode;

  @override
  List<Object> get props => [businesses ?? ''];
}
