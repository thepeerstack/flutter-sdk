import 'dart:convert';

import 'package:equatable/equatable.dart';

enum ThePeerIdentifierType { email, username }

class ThePeerBusinessModel with EquatableMixin {
  final ThePeerBusiness? business;
  ThePeerBusinessModel({
    required this.business,
  });

  ThePeerBusinessModel copyWith({
    ThePeerBusiness? business,
  }) {
    return ThePeerBusinessModel(
      business: business ?? this.business,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'business': business?.toMap(),
    };
  }

  factory ThePeerBusinessModel.fromMap(Map<String, dynamic> map) {
    return ThePeerBusinessModel(
      business: ThePeerBusiness.fromMap(map['business']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerBusinessModel.fromJson(String source) =>
      ThePeerBusinessModel.fromMap(json.decode(source));

  @override
  String toString() => 'ThePeerBusinessModel(business: $business)';
  @override
  List<Object> get props => [business ?? ''];
}

class ThePeerBusiness with EquatableMixin {
  final String id;
  final String name;
  final String email;
  final String? logo;
  final String identifier_type;
  ThePeerBusiness({
    required this.id,
    required this.name,
    required this.email,
    required this.logo,
    required this.identifier_type,
  });

  bool get isUsernameIdentifier => identifier_type == 'username';

  ThePeerIdentifierType get identifierType => () {
        switch (identifier_type) {
          case 'email':
            return ThePeerIdentifierType.email;
          default:
            return ThePeerIdentifierType.username;
        }
      }();

  String get hintText =>
      isUsernameIdentifier == true ? '@valkyrie' : 'heimdall@asgard.com';

  ThePeerBusiness copyWith({
    String? id,
    String? name,
    String? email,
    String? logo,
    String? identifier_type,
  }) {
    return ThePeerBusiness(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      logo: logo ?? this.logo,
      identifier_type: identifier_type ?? this.identifier_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'logo': logo,
      'identifier_type': identifier_type,
    };
  }

  factory ThePeerBusiness.fromMap(Map<String, dynamic> map) {
    return ThePeerBusiness(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      logo: map['logo'],
      identifier_type: map['identifier_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerBusiness.fromJson(String source) =>
      ThePeerBusiness.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Business(id: $id, name: $name, email: $email, logo: $logo, identifier_type: $identifier_type)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      logo ?? '',
      identifier_type,
    ];
  }
}
