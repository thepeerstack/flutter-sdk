import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThePeerUserRefModel with EquatableMixin {
  final String name;
  final String hash;
  ThePeerUserRefModel({
    required this.name,
    required this.hash,
  });

  ThePeerUserRefModel copyWith({
    String? name,
    String? hash,
  }) {
    return ThePeerUserRefModel(
      name: name ?? this.name,
      hash: hash ?? this.hash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hash': hash,
    };
  }

  factory ThePeerUserRefModel.fromMap(Map<String, dynamic> map) {
    return ThePeerUserRefModel(
      name: map['name'],
      hash: map['hash'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerUserRefModel.fromJson(String source) =>
      ThePeerUserRefModel.fromMap(json.decode(source));

  @override
  String toString() => 'ThePeerUserRefModel(name: $name, hash: $hash)';

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, hash];
}
