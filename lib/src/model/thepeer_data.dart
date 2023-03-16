import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThepeerData with EquatableMixin {
  /// Your public key an be found on your dashboard settings
  final String publicKey;

  /// The user reference returned by the Thepeer API when a user has been indexed
  final String userReference;

  /// The amount you intend to send and must be pass as an integer in kobo
  final int amount;

  /// The currency of the `amount` to be paid
  final String currency;

  /// Optional Medata data needed
  final Map<String, Object> meta;

  bool get isProd => publicKey.contains('test') == false;

  ThepeerData({
    required this.publicKey,
    required this.userReference,
    required this.currency,
    required this.amount,
    this.meta = const {},
  });

  ThepeerData copyWith({
    String? publicKey,
    String? userReference,
    String? currency,
    String? receiptUrl,
    Map<String, Object>? meta,
    int? amount,
  }) {
    return ThepeerData(
      publicKey: publicKey ?? this.publicKey,
      userReference: userReference ?? this.userReference,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'publicKey': publicKey,
      'userReference': userReference,
      'amount': amount,
      'meta': meta,
    };
  }

  factory ThepeerData.fromMap(Map<String, dynamic> map) {
    return ThepeerData(
      publicKey: map['publicKey'],
      userReference: map['userReference'],
      amount: map['amount'],
      currency: map['currency'],
      meta: map['meta'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThepeerData.fromJson(String source) =>
      ThepeerData.fromMap(json.decode(source));

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [
        publicKey,
        userReference,
        amount,
        currency,
        meta,
      ];
}
