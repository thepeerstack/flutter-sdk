import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThePeerUserRefModel with EquatableMixin {
  final String name;
  final String? reference;
  final String? hash;
  ThePeerUserRefModel({
    required this.name,
    required this.hash,
    required this.reference,
  });

  ThePeerUserRefModel copyWith({
    String? name,
    String? hash,
    String? reference,
  }) {
    return ThePeerUserRefModel(
      name: name ?? this.name,
      hash: hash ?? this.hash,
      reference: reference ?? this.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hash': hash,
      'reference': reference,
    };
  }

  factory ThePeerUserRefModel.fromMap(Map<String, dynamic> map) {
    return ThePeerUserRefModel(
      name: map['name'],
      hash: map['hash'],
      reference: map['reference'],
    );
  }

  factory ThePeerUserRefModel.empty() {
    return ThePeerUserRefModel(
      name: '',
      hash: '',
      reference: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerUserRefModel.fromJson(String source) =>
      ThePeerUserRefModel.fromMap(json.decode(source));

  @override
  String toString() => 'ThePeerUserRefModel(name: $name, hash: $reference)';

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, reference??  '', hash ?? ''];
}
