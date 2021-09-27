import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThePeerData with EquatableMixin {
  /// Your public key an be found on your dashboard settings
  final String publicKey;

  /// The user reference returned by the Thepeer API when a user has been indexed
  final String userReference;

  /// This is a callback to your application's backend where we would pass a query string `"?receipt=$receipt_id"` where you are expected to initiate the send endpoint on your backend using your secret key.
  final String? receiptUrl;

  /// The amount you intend to send and must be pass as an integer in kobo
  final int amount;

  /// Optional Medata data needed
  final Map<String, Object> meta;

  bool get isProd => publicKey.contains('test') == false;

  ThePeerData({
    required this.publicKey,
    required this.userReference,
    required this.amount,
    this.meta = const {},
    this.receiptUrl,
  });

  ThePeerData copyWith({
    String? publicKey,
    String? userReference,
    String? firstName,
    String? receiptUrl,
    Map<String, Object>? meta,
    int? amount,
  }) {
    return ThePeerData(
      publicKey: publicKey ?? this.publicKey,
      userReference: userReference ?? this.userReference,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      amount: amount ?? this.amount,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'publicKey': publicKey,
      'userReference': userReference,
      'receiptUrl': receiptUrl,
      'amount': amount,
      'meta': meta,
    };
  }

  factory ThePeerData.fromMap(Map<String, dynamic> map) {
    return ThePeerData(
      publicKey: map['publicKey'],
      userReference: map['userReference'],
      receiptUrl: map['receiptUrl'],
      amount: map['amount'],
      meta: map['meta'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerData.fromJson(String source) =>
      ThePeerData.fromMap(json.decode(source));

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [
        publicKey,
        userReference,
        receiptUrl ?? '',
        amount,
        meta,
      ];
}
