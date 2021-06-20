import 'dart:convert';

import 'package:equatable/equatable.dart';

/// The Peer Receipt model
class ThePeerReceiptModel with EquatableMixin {
  /// Transaction Amount
  final int amount;

  /// Transaction remark
  final String remark;

  /// Origin User id
  final String to;

  /// Destination User id
  final String from;

  ThePeerReceiptModel({
    required this.amount,
    required this.remark,
    required this.to,
    required this.from,
  });

  ThePeerReceiptModel copyWith({
    /// Transaction Amount
    int? amount,

    /// Transaction remark
    String? remark,

    /// Origin User id
    String? to,

    /// Destination User id
    String? from,
  }) {
    return ThePeerReceiptModel(
      amount: amount ?? this.amount,
      remark: remark ?? this.remark,
      to: to ?? this.to,
      from: from ?? this.from,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'remark': remark,
      'to': to,
      'from': from,
    };
  }

  factory ThePeerReceiptModel.fromMap(Map<String, dynamic> map) {
    return ThePeerReceiptModel(
      amount: map['amount'],
      remark: map['remark'],
      to: map['to'],
      from: map['from'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerReceiptModel.fromJson(String source) =>
      ThePeerReceiptModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ThePeerReceiptModel(amount: $amount, remark: $remark, to: $to, from: $from)';
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [amount, remark, to, from];
}
