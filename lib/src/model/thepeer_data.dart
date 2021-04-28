import 'dart:convert';

class ThePeerData {
  /// Your public key an be found on your dashboard settings
  final String publicKey;

  /// The user reference returned by the Thepeer API when a user has been indexed
  final String userReference;

  /// Your user's first name
  final String? firstName;

  /// This is a callback to your application's backend where we would pass a query string `"?receipt=$receipt_id"` where you are expected to initiate the send endpoint on your backend using your secret key.
  final String? receiptUrl;

  /// The amount you intend to send and must be pass as an integer in kobo
  final int amount;

  ThePeerData({
    required this.publicKey,
    required this.userReference,
    required this.firstName,
    required this.receiptUrl,
    required this.amount,
  });

  ThePeerData copyWith({
    String? publicKey,
    String? userReference,
    String? firstName,
    String? receiptUrl,
    int? amount,
  }) {
    return ThePeerData(
      publicKey: publicKey ?? this.publicKey,
      userReference: userReference ?? this.userReference,
      firstName: firstName ?? this.firstName,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'publicKey': publicKey,
      'userReference': userReference,
      'firstName': firstName,
      'receiptUrl': receiptUrl,
      'amount': amount,
    };
  }

  factory ThePeerData.fromMap(Map<String, dynamic> map) {
    return ThePeerData(
      publicKey: map['publicKey'],
      userReference: map['userReference'],
      firstName: map['firstName'],
      receiptUrl: map['receiptUrl'],
      amount: map['amount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerData.fromJson(String source) =>
      ThePeerData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ThePeerData(publicKey: $publicKey, userReference: $userReference, firstName: $firstName, receiptUrl: $receiptUrl, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThePeerData &&
        other.publicKey == publicKey &&
        other.userReference == userReference &&
        other.firstName == firstName &&
        other.receiptUrl == receiptUrl &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return publicKey.hashCode ^
        userReference.hashCode ^
        firstName.hashCode ^
        receiptUrl.hashCode ^
        amount.hashCode;
  }
}
